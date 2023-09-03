import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Prefs {

  /// If true, the user's preferences will not be loaded and the default values will be used instead.
  /// The values will not be saved either.
  @visibleForTesting
  static bool testingMode = false;

  /// If true, a warning will be printed if a pref is accessed before it is loaded.
  ///
  /// If [testingMode] is true, the warning will not be printed even if this is true.
  @visibleForTesting
  static bool warnIfPrefAccessedBeforeLoaded = true;

  static late final PlainPref<GameData?> currentGame;
  static late final PlainPref<int> highScore;

  static late final PlainPref<bool> hyperlegibleFont;

  static late final PlainPref<int?> birthYear;

  static void init() {
    currentGame = PlainPref('currentGame', null);
    highScore = PlainPref('highScore', 0);

    hyperlegibleFont = PlainPref('hyperlegibleFont', false);

    birthYear = PlainPref('birthYear', null);
  }
}

abstract class IPref<T> extends ValueNotifier<T> {
  final String key;
  /// The keys that were used in the past for this Pref. If one of these keys is found, the value will be migrated to the current key.
  final List<String> historicalKeys;
  /// The keys that were used in the past for a similar Pref. If one of these keys is found, it will be deleted.
  final List<String> deprecatedKeys;

  final T defaultValue;

  bool _loaded = false;

  /// Whether this pref has changes that have yet to be saved to disk.
  @protected
  bool _saved = true;

  IPref(this.key, this.defaultValue, {
    List<String>? historicalKeys,
    List<String>? deprecatedKeys,
  }) : historicalKeys = historicalKeys ?? [],
        deprecatedKeys = deprecatedKeys ?? [],
        super(defaultValue) {
    if (Prefs.testingMode) {
      _loaded = true;
      return;
    } else {
      _load().then((T? loadedValue) {
        _loaded = true;
        if (loadedValue != null) {
          value = loadedValue;
        }
        _afterLoad();
        addListener(_save);
      });
    }
  }

  Future<T?> _load();
  Future<void> _afterLoad();
  Future<void> _save();
  @protected
  Future<T?> getValueWithKey(String key);

  /// Removes the value from shared preferences, and resets the pref to its default value.
  @visibleForTesting
  Future<void> delete();

  @override
  T get value {
    if (!loaded && !Prefs.testingMode && Prefs.warnIfPrefAccessedBeforeLoaded) {
      if (kDebugMode) print("WARNING: Pref '$key' accessed before it was loaded.");
    }
    return super.value;
  }
  bool get loaded => _loaded;
  bool get saved => _saved;

  Future<void> waitUntilLoaded() async {
    while (!loaded) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Waits until the value has been saved to disk.
  /// Note that there is no guarantee with shared preferences that
  /// the value will actually be saved to disk.
  Future<void> waitUntilSaved() async {
    while (!saved) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Lets us use notifyListeners outside of the class
  /// as super.notifyListeners is @protected
  @override
  void notifyListeners() => super.notifyListeners();
}
class PlainPref<T> extends IPref<T> {
  SharedPreferences? _prefs;

  PlainPref(
    super.key,
    super.defaultValue, {
    super.historicalKeys,
    super.deprecatedKeys,
  }): assert(
    T == bool || T == int || T == double || T == String
      || T == typeOf<int?>()
      || T == typeOf<Uint8List?>()
      || T == typeOf<List<String>>() || T == typeOf<Set<String>>()
      || T == typeOf<Queue<String>>()
      || T == AxisDirection || T == ThemeMode || T == TargetPlatform
      || T == typeOf<GameData?>()
  );

  @override
  Future<T?> _load() async {
    _prefs ??= await SharedPreferences.getInstance();

    T? currentValue = await getValueWithKey(key);
    if (currentValue != null) return currentValue;

    for (final historicalKey in historicalKeys) {
      currentValue = await getValueWithKey(historicalKey);
      if (currentValue == null) continue;

      // migrate to new key
      await _save();
      _prefs!.remove(historicalKey);

      return currentValue;
    }

    for (final deprecatedKey in deprecatedKeys) {
      _prefs!.remove(deprecatedKey);
    }

    return null;
  }
  @override
  Future<void> _afterLoad() async {
    _prefs = null;
  }

  @override
  Future _save() async {
    _saved = false;
    try {
      _prefs ??= await SharedPreferences.getInstance();

      if (T == bool) {
        return await _prefs!.setBool(key, value as bool);
      } else if (T == int || T == typeOf<int?>()) {
        if (value == null) {
          return await _prefs!.remove(key);
        } else {
          return await _prefs!.setInt(key, value as int);
        }
      } else if (T == double) {
        return await _prefs!.setDouble(key, value as double);
      } else if (T == typeOf<Uint8List?>()) {
        final bytes = value as Uint8List?;
        if (bytes == null) {
          return await _prefs!.remove(key);
        } else {
          return await _prefs!.setString(key, base64Encode(bytes));
        }
      } else if (T == typeOf<List<String>>()) {
        return await _prefs!.setStringList(key, value as List<String>);
      } else if (T == typeOf<Set<String>>()) {
        return await _prefs!.setStringList(key, (value as Set<String>).toList());
      } else if (T == typeOf<Queue<String>>()) {
        return await _prefs!.setStringList(key, (value as Queue<String>).toList());
      } else if (T == AxisDirection) {
        return await _prefs!.setInt(key, (value as AxisDirection).index);
      } else if (T == ThemeMode) {
        return await _prefs!.setInt(key, (value as ThemeMode).index);
      } else if (T == TargetPlatform) {
        return await _prefs!.setInt(key, (value as TargetPlatform).index);
      } else if (T == typeOf<GameData?>()) {
        final json = jsonEncode(value);
        return await _prefs!.setString(key, json);
      } else {
        return await _prefs!.setString(key, value as String);
      }
    } finally {
      _saved = true;
    }
  }

  @override
  Future<T?> getValueWithKey(String key) async {
    try {
      if (!_prefs!.containsKey(key)) {
        return null;
      } else if (T == typeOf<Uint8List?>()) {
        final base64 = _prefs!.getString(key);
        if (base64 == null) return null;
        return base64Decode(base64) as T;
      } else if (T == typeOf<List<String>>()) {
        return _prefs!.getStringList(key) as T?;
      } else if (T == typeOf<Set<String>>()) {
        return _prefs!.getStringList(key)?.toSet() as T?;
      } else if (T == typeOf<Queue<String>>()) {
        final list = _prefs!.getStringList(key);
        return list != null ? Queue<String>.from(list) as T : null;
      } else if (T == AxisDirection) {
        final index = _prefs!.getInt(key);
        return index != null ? AxisDirection.values[index] as T? : null;
      } else if (T == ThemeMode) {
        final index = _prefs!.getInt(key);
        return index != null ? ThemeMode.values[index] as T? : null;
      } else if (T == TargetPlatform) {
        final index = _prefs!.getInt(key);
        if (index == null) return null;
        if (index == -1) return defaultTargetPlatform as T?;
        return TargetPlatform.values[index] as T?;
      } else if (T == typeOf<GameData?>()) {
        final json = _prefs!.getString(key);
        if (json == null) return null;
        final decoded = jsonDecode(json) as Map<String, dynamic>?;
        if (decoded == null) return null;
        return GameData.fromJson(decoded) as T;
      } else {
        return _prefs!.get(key) as T?;
      }
    } catch (e) {
      if (kDebugMode) print('Error loading $key: $e');
      return null;
    }
  }

  @override
  Future<void> delete() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.remove(key);
  }
}

Type typeOf<T>() => T;
