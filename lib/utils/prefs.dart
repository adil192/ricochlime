import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ricochlime/flame/game_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Prefs {
  /// If true, the user's preferences will not be loaded and the default values
  /// will be used instead.
  /// The values will not be saved either.
  @visibleForTesting
  static bool testingMode = false;

  /// If true, a warning will be printed if a pref is accessed before
  /// it is loaded.
  ///
  /// If [testingMode] is true, the warning will not be printed
  /// even if this is true.
  @visibleForTesting
  static bool warnIfPrefAccessedBeforeLoaded = true;

  static late final PlainPref<GameData?> currentGame;
  static late final PlainPref<int> highScore;

  static late final PlainPref<bool> hyperlegibleFont;

  static late final PlainPref<int?> birthYear;

  static late final PlainPref<double> bgmVolume;

  static late final PlainPref<bool> showUndoButton;

  static late final PlainPref<bool> fasterPageTransitions;

  static late final PlainPref<int> coins;

  static void init() {
    currentGame = PlainPref('currentGame', null);
    highScore = PlainPref('highScore', 0);

    hyperlegibleFont = PlainPref('hyperlegibleFont', false);

    birthYear = PlainPref('birthYear', null);

    bgmVolume = PlainPref('bgmVolume', 0);

    showUndoButton = PlainPref('showUndoButton', true);

    fasterPageTransitions = PlainPref('fasterPageTransitions', false);

    coins = PlainPref('coins', 0);
  }
}

abstract class IPref<T> extends ValueNotifier<T> {
  IPref(
    this.key,
    this.defaultValue, {
    List<String>? historicalKeys,
    List<String>? deprecatedKeys,
  })  : historicalKeys = historicalKeys ?? [],
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

  final String key;

  /// The keys that were used in the past for this Pref.
  /// If one of these keys is found, the value will be moved to the current key.
  final List<String> historicalKeys;

  /// The keys that were used in the past for a similar Pref.
  /// If one of these keys is found, it will be deleted.
  final List<String> deprecatedKeys;

  final T defaultValue;

  bool _loaded = false;

  /// Whether this pref has changes that have yet to be saved to disk.
  @protected
  bool _saved = true;

  Future<T?> _load();
  Future<void> _afterLoad();
  Future<void> _save();
  @protected
  Future<T?> getValueWithKey(String key);

  /// Removes the value from shared prefs, and resets it to its default value.
  @visibleForTesting
  Future<void> delete();

  @override
  T get value {
    if (!loaded && !Prefs.testingMode && Prefs.warnIfPrefAccessedBeforeLoaded) {
      if (kDebugMode) {
        print("WARNING: Pref '$key' accessed before it was loaded.");
      }
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
  PlainPref(
    super.key,
    super.defaultValue, {
    super.historicalKeys,
    super.deprecatedKeys,
  }) : assert(
          T == bool ||
              T == int ||
              T == double ||
              T == String ||
              T == typeOf<int?>() ||
              T == typeOf<Uint8List?>() ||
              T == typeOf<List<String>>() ||
              T == typeOf<Set<String>>() ||
              T == typeOf<Queue<String>>() ||
              T == AxisDirection ||
              T == ThemeMode ||
              T == TargetPlatform ||
              T == typeOf<GameData?>(),
        );

  SharedPreferences? _prefs;

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
      unawaited(_prefs!.remove(historicalKey));

      return currentValue;
    }

    for (final deprecatedKey in deprecatedKeys) {
      unawaited(_prefs!.remove(deprecatedKey));
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
        return _prefs!.setBool(key, value as bool);
      } else if (T == int || T == typeOf<int?>()) {
        if (value == null) {
          return _prefs!.remove(key);
        } else {
          return _prefs!.setInt(key, value as int);
        }
      } else if (T == double) {
        return _prefs!.setDouble(key, value as double);
      } else if (T == typeOf<Uint8List?>()) {
        final bytes = value as Uint8List?;
        if (bytes == null) {
          return _prefs!.remove(key);
        } else {
          return _prefs!.setString(key, base64Encode(bytes));
        }
      } else if (T == typeOf<List<String>>()) {
        return _prefs!.setStringList(key, value as List<String>);
      } else if (T == typeOf<Set<String>>()) {
        return _prefs!.setStringList(key, (value as Set<String>).toList());
      } else if (T == typeOf<Queue<String>>()) {
        return _prefs!.setStringList(key, (value as Queue<String>).toList());
      } else if (T == AxisDirection) {
        return _prefs!.setInt(key, (value as AxisDirection).index);
      } else if (T == ThemeMode) {
        return _prefs!.setInt(key, (value as ThemeMode).index);
      } else if (T == TargetPlatform) {
        return _prefs!.setInt(key, (value as TargetPlatform).index);
      } else if (T == typeOf<GameData?>()) {
        final json = jsonEncode(value);
        return _prefs!.setString(key, json);
      } else {
        return _prefs!.setString(key, value as String);
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
