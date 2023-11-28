/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 69 (34 per locale)
///
/// Built on 2023-11-28 at 13:23 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, _StringsEn> {
	en(languageCode: 'en', build: _StringsEn.build),
	kk(languageCode: 'kk', build: _StringsKk.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, _StringsEn> build;

	/// Gets current instance managed by [LocaleSettings].
	_StringsEn get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
_StringsEn get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context).translations;
}

/// The provider for method B
class TranslationProvider extends BaseTranslationProvider<AppLocale, _StringsEn> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, _StringsEn> of(BuildContext context) => InheritedLocaleData.of<AppLocale, _StringsEn>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	_StringsEn get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, _StringsEn> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, _StringsEn> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class _StringsEn implements BaseTranslations<AppLocale, _StringsEn> {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	late final _StringsEn _root = this; // ignore: unused_field

	// Translations
	String get appName => 'Ricochlime';
	late final _StringsHomePageEn homePage = _StringsHomePageEn._(_root);
	late final _StringsPlayPageEn playPage = _StringsPlayPageEn._(_root);
	late final _StringsSettingsPageEn settingsPage = _StringsSettingsPageEn._(_root);
	late final _StringsAgeDialogEn ageDialog = _StringsAgeDialogEn._(_root);
	late final _StringsGameOverPageEn gameOverPage = _StringsGameOverPageEn._(_root);
	late final _StringsTutorialPageEn tutorialPage = _StringsTutorialPageEn._(_root);
	late final _StringsCommonEn common = _StringsCommonEn._(_root);
}

// Path: homePage
class _StringsHomePageEn {
	_StringsHomePageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get playButton => 'Play';
	String get settingsButton => 'Settings';
	String get tutorialButton => 'Tutorial';
}

// Path: playPage
class _StringsPlayPageEn {
	_StringsPlayPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String highScore({required Object p}) => 'Best: ${p}';
}

// Path: settingsPage
class _StringsSettingsPageEn {
	_StringsSettingsPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get adConsent => 'Change ad consent';
	String get hyperlegibleFont => 'Use the Atkinson Hyperlegible font';
	String get appInfo => 'App info';
	String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nThis program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.';
}

// Path: ageDialog
class _StringsAgeDialogEn {
	_StringsAgeDialogEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get yourAge => 'Your age';
	String get title => 'Let me guess your age';
	String get unknown => 'Unknown';
	String get reason => 'We need to know your age to make sure the ads you see are appropriate for you. This will not affect gameplay.';
	String guessNumber({required Object n}) => 'Guess \#${n}';
	String areYou({required Object age}) => 'Are you ${age}?';
	String get younger => 'No, I\'m younger';
	String get older => 'No, I\'m older';
	String yesMyAgeIs({required Object age}) => 'Yes, I\'m ${age}';
	String get reset => 'Reset';
}

// Path: gameOverPage
class _StringsGameOverPageEn {
	_StringsGameOverPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get title => 'Game over!';
	String highScoreNotBeaten({required Object p}) => 'You scored ${p} points!';
	TextSpan highScoreBeaten({required InlineSpan pOld, required InlineSpan pNew}) => TextSpan(children: [
		const TextSpan(text: 'Your high score is now '),
		pOld,
		const TextSpan(text: ' '),
		pNew,
		const TextSpan(text: ' points!'),
	]);
	String get continueWithAdButton => 'Continue with ad';
	String get restartGameButton => 'Restart game';
	String get homeButton => 'Home';
}

// Path: tutorialPage
class _StringsTutorialPageEn {
	_StringsTutorialPageEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get tutorial => 'Tutorial';
	String get aimAtSlimes => 'Drag your finger to aim and release to shoot.';
	String get emptyHealthbar => 'Defeat a slime by emptying its health bar.';
	String get bounceOffWalls => 'Bounce your shots off the walls to hit the most slimes.';
	String get tapSpeedUp => 'Tap the screen to speed up your shots.';
	String get dangerZone => 'If a slime reaches the danger zone, you\'ll lose on your next turn if you don\'t defeat it.';
	String get moreSlimes => 'More rows of slimes will spawn each turn as you progress, so the danger zone will also get bigger.';
}

// Path: common
class _StringsCommonEn {
	_StringsCommonEn._(this._root);

	final _StringsEn _root; // ignore: unused_field

	// Translations
	String get cancel => 'Cancel';
	String get ok => 'Okay';
}

// Path: <root>
class _StringsKk extends _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsKk.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.kk,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <kk>.
	@override final TranslationMetadata<AppLocale, _StringsEn> $meta;

	@override late final _StringsKk _root = this; // ignore: unused_field

	// Translations
	@override String get appName => 'Рикошырыш';
	@override late final _StringsHomePageKk homePage = _StringsHomePageKk._(_root);
	@override late final _StringsPlayPageKk playPage = _StringsPlayPageKk._(_root);
	@override late final _StringsSettingsPageKk settingsPage = _StringsSettingsPageKk._(_root);
	@override late final _StringsAgeDialogKk ageDialog = _StringsAgeDialogKk._(_root);
	@override late final _StringsGameOverPageKk gameOverPage = _StringsGameOverPageKk._(_root);
	@override late final _StringsTutorialPageKk tutorialPage = _StringsTutorialPageKk._(_root);
	@override late final _StringsCommonKk common = _StringsCommonKk._(_root);
}

// Path: homePage
class _StringsHomePageKk extends _StringsHomePageEn {
	_StringsHomePageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get playButton => 'Ойнау';
	@override String get settingsButton => 'Баптау';
	@override String get tutorialButton => 'Нұсқаулық';
}

// Path: playPage
class _StringsPlayPageKk extends _StringsPlayPageEn {
	_StringsPlayPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String highScore({required Object p}) => 'Үздік: ${p}';
}

// Path: settingsPage
class _StringsSettingsPageKk extends _StringsSettingsPageEn {
	_StringsSettingsPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get title => 'Баптау';
	@override String get adConsent => 'Жарнамаға келісімді баптау';
	@override String get hyperlegibleFont => 'Atkinson Hyperlegible қарпін қолдану';
	@override String get appInfo => 'Қолданба ақпары';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nБұл бағдарлама еш кепілдіксіз жеткізіледі. Ол еркін екенін ескере отырып, сіз оны кейбір шарттардың аясында еркін тарата аласыз.';
}

// Path: ageDialog
class _StringsAgeDialogKk extends _StringsAgeDialogEn {
	_StringsAgeDialogKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get yourAge => 'Жасыңыз';
	@override String get title => 'Жасыңызды болжау';
	@override String get unknown => 'Белгісіз';
	@override String get reason => 'Сіз көретін жарнама сізге қолайлы болатынына көз жеткізу үшін жасыңызды білуіміз керек. Ойынның өзіне бұл әсер етпейді.';
	@override String areYou({required Object age}) => 'Жасыңыз ${age}?';
	@override String get younger => 'Жоқ, жасым кішірек';
	@override String get older => 'Жоқ, жасым үлкенірек';
	@override String yesMyAgeIs({required Object age}) => 'Иә, жасым ${age}';
	@override String get reset => 'Арылту';
}

// Path: gameOverPage
class _StringsGameOverPageKk extends _StringsGameOverPageEn {
	_StringsGameOverPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ойын бітті!';
	@override String highScoreNotBeaten({required Object p}) => '${p} ұпай жинадыңыз!';
	@override TextSpan highScoreBeaten({required InlineSpan pOld, required InlineSpan pNew}) => TextSpan(children: [
		const TextSpan(text: 'Енді үздік нәтижеңіз '),
		pOld,
		const TextSpan(text: ' '),
		pNew,
		const TextSpan(text: ' ұпай!'),
	]);
	@override String get continueWithAdButton => 'Жарнама көріп, жалғастыру';
	@override String get restartGameButton => 'Жаңадан бастау';
	@override String get homeButton => 'Мәзір';
}

// Path: tutorialPage
class _StringsTutorialPageKk extends _StringsTutorialPageEn {
	_StringsTutorialPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get tutorial => 'Нұсқаулық';
	@override String get aimAtSlimes => 'Көздеу үшін саусағыңызды жылжытыңыз, ату үшін босатып жіберіңіз.';
	@override String get emptyHealthbar => 'Шырышты жеңу үшін оның денсаулық жолағын нөлге дейін жеткізіңіз.';
	@override String get bounceOffWalls => 'Қабырғадан ыршыған оқ көбірек шырышқа тие алады.';
	@override String get tapSpeedUp => 'Оқ қозғалысын тездету үшін экранды түртіңіз.';
	@override String get dangerZone => 'Қауіпті аймаққа кірген шырышты жеңбесеңіз, келесі жүрісте ұтыласыз.';
	@override String get moreSlimes => 'Жүріс жасалған сайын жаңа шырыш қатары шығады. Ойын барысында бір жүрістен кейін пайда болатын қатарлар көбейіп, қауіпті аймақ та кеңейеді.';
}

// Path: common
class _StringsCommonKk extends _StringsCommonEn {
	_StringsCommonKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Болдырмау';
	@override String get ok => 'ОК';
}
