/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 3
/// Strings: 171 (57 per locale)
///
/// Built on 2024-06-13 at 23:03 UTC

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
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	es(languageCode: 'es', build: _StringsEs.build),
	kk(languageCode: 'kk', build: _StringsKk.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
Translations get t => LocaleSettings.instance.currentTranslations;

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
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
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
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
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
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get appName => 'Ricochlime';
	late final _StringsHomePageEn homePage = _StringsHomePageEn._(_root);
	late final _StringsPlayPageEn playPage = _StringsPlayPageEn._(_root);
	late final _StringsSettingsPageEn settingsPage = _StringsSettingsPageEn._(_root);
	late final _StringsAgeDialogEn ageDialog = _StringsAgeDialogEn._(_root);
	late final _StringsGameOverPageEn gameOverPage = _StringsGameOverPageEn._(_root);
	late final _StringsAdWarningEn adWarning = _StringsAdWarningEn._(_root);
	late final _StringsRestartGameDialogEn restartGameDialog = _StringsRestartGameDialogEn._(_root);
	late final _StringsTutorialPageEn tutorialPage = _StringsTutorialPageEn._(_root);
	late final _StringsShopPageEn shopPage = _StringsShopPageEn._(_root);
	late final _StringsCommonEn common = _StringsCommonEn._(_root);
}

// Path: homePage
class _StringsHomePageEn {
	_StringsHomePageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get playButton => 'Play';
	String get shopButton => 'Shop';
	String get settingsButton => 'Settings';
	String get tutorialButton => 'Tutorial';
}

// Path: playPage
class _StringsPlayPageEn {
	_StringsPlayPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String highScore({required Object p}) => 'Best: ${p}';
	String get undo => 'Undo move';
	String get coins => 'Coins';
}

// Path: settingsPage
class _StringsSettingsPageEn {
	_StringsSettingsPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Settings';
	String get ads => 'Ads';
	String get gameplay => 'Gameplay';
	String get accessibility => 'Accessibility';
	String get adConsent => 'Change ad consent';
	String get hyperlegibleFont => 'Easy-to-read font';
	String get bgmVolume => 'Bg music volume';
	String get showUndoButton => 'Allow undoing moves';
	String get fasterPageTransitions => 'Faster page transitions';
	String get biggerBullets => 'Bigger bullets';
	String get maxFps => 'Max FPS';
	String get appInfo => 'App info';
	String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nThis program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.';
}

// Path: ageDialog
class _StringsAgeDialogEn {
	_StringsAgeDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get yourAge => 'Your age';
	String get letMeGuessYourAge => 'Let me guess your age';
	String get unknown => 'Unknown';
	String get reason => 'We need to know your age to make sure the ads you see are appropriate for you. This will not affect gameplay.';
	String guessNumber({required Object n}) => 'Guess \#${n}';
	String areYou({required Object age}) => 'Are you ${age}?';
	String get younger => 'No, I\'m younger';
	String get older => 'No, I\'m older';
	String yesMyAgeIs({required Object age}) => 'Yes, I\'m ${age}';
	String get reset => 'Reset';
	String get howOldAreYou => 'How old are you?';
	String get invalidAge => 'Please enter a valid age';
	String get useMinigame => 'Play the age guessing minigame';
	String get useSimpleInput => 'I want to enter my age manually';
}

// Path: gameOverPage
class _StringsGameOverPageEn {
	_StringsGameOverPageEn._(this._root);

	final Translations _root; // ignore: unused_field

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
	String get continueWithCoins => '100 to continue';
	String get restartGameButton => 'Restart game';
	String get homeButton => 'Home';
}

// Path: adWarning
class _StringsAdWarningEn {
	_StringsAdWarningEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	TextSpan getCoins({required InlineSpan c, required InlineSpan t}) => TextSpan(children: [
		const TextSpan(text: 'Get '),
		c,
		const TextSpan(text: ' 100 after this ad ('),
		t,
		const TextSpan(text: ')'),
	]);
}

// Path: restartGameDialog
class _StringsRestartGameDialogEn {
	_StringsRestartGameDialogEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Restart game?';
	String get areYouSure => 'Are you sure you want to restart? You can\'t undo this';
	String get waitCancel => 'Wait, cancel!';
	String get yesImSure => 'Yes I\'m sure!';
}

// Path: tutorialPage
class _StringsTutorialPageEn {
	_StringsTutorialPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get tutorial => 'Tutorial';
	String get aimAtMonsters => 'Drag your finger to aim and release to shoot. Defeat a monster by emptying its health bar.';
	String get bounceOffWalls => 'Bounce your shots off the walls to hit the most monsters.';
	String get tapSpeedUp => 'Tap the screen to speed up your shots.';
	String get dangerZone => 'If a monster reaches the danger zone, you\'ll lose on your next turn if you don\'t defeat it.';
	String get moreMonsters => 'More rows of monsters will spawn each turn as you progress, so the danger zone will also get bigger.';
}

// Path: shopPage
class _StringsShopPageEn {
	_StringsShopPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Shop';
	String get bulletColors => 'Bullet colors';
	String get bulletShapes => 'Bullet shapes';
}

// Path: common
class _StringsCommonEn {
	_StringsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancel => 'Cancel';
	String get ok => 'Okay';
}

// Path: <root>
class _StringsEs extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEs.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	@override late final _StringsEs _root = this; // ignore: unused_field

	// Translations
	@override String get appName => 'Ricochlime';
	@override late final _StringsHomePageEs homePage = _StringsHomePageEs._(_root);
	@override late final _StringsPlayPageEs playPage = _StringsPlayPageEs._(_root);
	@override late final _StringsSettingsPageEs settingsPage = _StringsSettingsPageEs._(_root);
	@override late final _StringsAgeDialogEs ageDialog = _StringsAgeDialogEs._(_root);
	@override late final _StringsGameOverPageEs gameOverPage = _StringsGameOverPageEs._(_root);
	@override late final _StringsAdWarningEs adWarning = _StringsAdWarningEs._(_root);
	@override late final _StringsRestartGameDialogEs restartGameDialog = _StringsRestartGameDialogEs._(_root);
	@override late final _StringsTutorialPageEs tutorialPage = _StringsTutorialPageEs._(_root);
	@override late final _StringsShopPageEs shopPage = _StringsShopPageEs._(_root);
	@override late final _StringsCommonEs common = _StringsCommonEs._(_root);
}

// Path: homePage
class _StringsHomePageEs extends _StringsHomePageEn {
	_StringsHomePageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get shopButton => 'Comercio';
	@override String get tutorialButton => 'tutorial';
	@override String get playButton => 'Jugar';
	@override String get settingsButton => 'Ajustes';
}

// Path: playPage
class _StringsPlayPageEs extends _StringsPlayPageEn {
	_StringsPlayPageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get coins => 'monedas';
	@override String get undo => 'Deshacer movimiento';
	@override String highScore({required Object p}) => 'Mejor: ${p}';
}

// Path: settingsPage
class _StringsSettingsPageEs extends _StringsSettingsPageEn {
	_StringsSettingsPageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get ads => 'Anuncios';
	@override String get hyperlegibleFont => 'Fuente fácil de leer';
	@override String get biggerBullets => 'balas mas grandes';
	@override String get gameplay => 'Como se Juega';
	@override String get accessibility => 'Accesibilidad';
	@override String get maxFps => 'FPS máx.';
	@override String get fasterPageTransitions => 'Transiciones de página más rápidas';
	@override String get showUndoButton => 'Permitir deshacer movimientos';
	@override String get title => 'Ajustes';
	@override String get adConsent => 'Cambiar el consentimiento de los anuncios';
	@override String get bgmVolume => 'Volumen de la música de fondo';
	@override String get appInfo => 'Informacion de la applicacion';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nEste programa no tiene ninguna garantía. Este es un software gratuito y puede redistribuirlo bajo ciertas condiciones.\n';
}

// Path: ageDialog
class _StringsAgeDialogEs extends _StringsAgeDialogEn {
	_StringsAgeDialogEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get yourAge => 'Tu edad';
	@override String get letMeGuessYourAge => 'Déjame adivinar tu edad';
	@override String get unknown => 'Desconocida';
	@override String get reason => 'Necesitamos saber su edad para asegurarnos de que los anuncios que ve sean apropiados para usted. Esto no afectará el juego.';
	@override String guessNumber({required Object n}) => 'Adivina \#${n}';
	@override String areYou({required Object age}) => '¿Tienes ${age} años?';
	@override String get younger => 'No, soy más joven';
	@override String get older => 'No, soy mayor';
	@override String yesMyAgeIs({required Object age}) => 'Sí, soy ${age}';
	@override String get reset => 'Reiniciar';
	@override String get howOldAreYou => '¿Cuántos años tiene?';
	@override String get invalidAge => 'Por favor ingresa una edad válida';
	@override String get useMinigame => 'Juega al minijuego de adivinar la edad';
	@override String get useSimpleInput => 'Quiero ingresar mi edad manualmente';
}

// Path: gameOverPage
class _StringsGameOverPageEs extends _StringsGameOverPageEn {
	_StringsGameOverPageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get continueWithCoins => '100 para continuar';
	@override String get title => '¡Juego terminado!';
	@override String highScoreNotBeaten({required Object p}) => '¡Obtuviste ${p} puntos!';
	@override TextSpan highScoreBeaten({required InlineSpan pOld, required InlineSpan pNew}) => TextSpan(children: [
		const TextSpan(text: '¡Tu puntuación más alta ahora es '),
		pOld,
		const TextSpan(text: ' antiguos '),
		pNew,
		const TextSpan(text: '!'),
	]);
	@override String get restartGameButton => 'Reinicia el juego';
	@override String get homeButton => 'Hogar';
}

// Path: adWarning
class _StringsAdWarningEs extends _StringsAdWarningEn {
	_StringsAdWarningEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override TextSpan getCoins({required InlineSpan c, required InlineSpan t}) => TextSpan(children: [
		const TextSpan(text: 'Obtenga '),
		c,
		const TextSpan(text: ' 100 después de este anuncio ('),
		t,
		const TextSpan(text: ')'),
	]);
}

// Path: restartGameDialog
class _StringsRestartGameDialogEs extends _StringsRestartGameDialogEn {
	_StringsRestartGameDialogEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Reinicia el juego?';
	@override String get areYouSure => '¿Estás seguro de que quieres reiniciar? No puedes deshacer esto';
	@override String get waitCancel => '¡Espera, cancela!';
	@override String get yesImSure => '¡Sí estoy seguro!';
}

// Path: tutorialPage
class _StringsTutorialPageEs extends _StringsTutorialPageEn {
	_StringsTutorialPageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get tutorial => 'tutorial';
	@override String get aimAtMonsters => 'Arrastra el dedo para apuntar y suelta para disparar. Derrota a un monstruo vaciando su barra de salud.';
	@override String get bounceOffWalls => 'Rebota tus tiros en las paredes para golpear a la mayor cantidad de monstruos.';
	@override String get tapSpeedUp => 'Toca la pantalla para acelerar tus disparos.';
	@override String get dangerZone => 'Si un monstruo llega a la zona de peligro, perderás en tu próximo turno si no lo derrotas.';
	@override String get moreMonsters => 'Aparecerán más filas de monstruos en cada turno a medida que avances, por lo que la zona de peligro también se hará más grande.';
}

// Path: shopPage
class _StringsShopPageEs extends _StringsShopPageEn {
	_StringsShopPageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get bulletShapes => 'Formas de bala';
	@override String get bulletColors => 'Colores de bala';
	@override String get title => 'Comercio';
}

// Path: common
class _StringsCommonEs extends _StringsCommonEn {
	_StringsCommonEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Cancelar';
	@override String get ok => 'Bueno';
}

// Path: <root>
class _StringsKk extends Translations {
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
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	@override late final _StringsKk _root = this; // ignore: unused_field

	// Translations
	@override String get appName => 'Рикошырыш';
	@override late final _StringsHomePageKk homePage = _StringsHomePageKk._(_root);
	@override late final _StringsPlayPageKk playPage = _StringsPlayPageKk._(_root);
	@override late final _StringsSettingsPageKk settingsPage = _StringsSettingsPageKk._(_root);
	@override late final _StringsAgeDialogKk ageDialog = _StringsAgeDialogKk._(_root);
	@override late final _StringsGameOverPageKk gameOverPage = _StringsGameOverPageKk._(_root);
	@override late final _StringsAdWarningKk adWarning = _StringsAdWarningKk._(_root);
	@override late final _StringsRestartGameDialogKk restartGameDialog = _StringsRestartGameDialogKk._(_root);
	@override late final _StringsTutorialPageKk tutorialPage = _StringsTutorialPageKk._(_root);
	@override late final _StringsShopPageKk shopPage = _StringsShopPageKk._(_root);
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
	@override String get shopButton => 'дүкен';
}

// Path: playPage
class _StringsPlayPageKk extends _StringsPlayPageEn {
	_StringsPlayPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String highScore({required Object p}) => 'Үздік: ${p}';
	@override String get coins => 'Монеталар';
	@override String get undo => 'Қозғалысты болдырмау';
}

// Path: settingsPage
class _StringsSettingsPageKk extends _StringsSettingsPageEn {
	_StringsSettingsPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get title => 'Баптау';
	@override String get adConsent => 'Жарнамаға келісімді баптау';
	@override String get appInfo => 'Қолданба ақпары';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nБұл бағдарлама еш кепілдіксіз жеткізіледі. Ол еркін екенін ескере отырып, сіз оны кейбір шарттардың аясында еркін тарата аласыз.';
	@override String get ads => 'Жарнамалар';
	@override String get hyperlegibleFont => 'Оқуға оңай шрифт';
	@override String get biggerBullets => 'Үлкенірек оқтар';
	@override String get gameplay => 'Ойын барысы';
	@override String get accessibility => 'Қол жетімділік';
	@override String get maxFps => 'Максималды FPS';
	@override String get fasterPageTransitions => 'Беттерді жылдамырақ ауыстыру';
	@override String get showUndoButton => 'Қозғалысты қайтаруға рұқсат беріңіз';
	@override String get bgmVolume => 'Фондық музыканың дыбыс деңгейі';
}

// Path: ageDialog
class _StringsAgeDialogKk extends _StringsAgeDialogEn {
	_StringsAgeDialogKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get yourAge => 'Жасыңыз';
	@override String get letMeGuessYourAge => 'Жасыңызды болжау';
	@override String get unknown => 'Белгісіз';
	@override String get reason => 'Сіз көретін жарнама сізге қолайлы болатынына көз жеткізу үшін жасыңызды білуіміз керек. Ойынның өзіне бұл әсер етпейді.';
	@override String areYou({required Object age}) => 'Жасыңыз ${age}?';
	@override String get younger => 'Жоқ, жасым кішірек';
	@override String get older => 'Жоқ, жасым үлкенірек';
	@override String yesMyAgeIs({required Object age}) => 'Иә, жасым ${age}';
	@override String get reset => 'Арылту';
	@override String get howOldAreYou => 'Сен қанша жастасың?';
	@override String get invalidAge => 'Жарамды жасты енгізіңіз';
	@override String get useMinigame => 'Жасты болжайтын шағын ойынды ойнаңыз';
	@override String get useSimpleInput => 'Мен жасымды қолмен енгізгім келеді';
	@override String guessNumber({required Object n}) => 'Ойланыңыз \#${n}';
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
	@override String get restartGameButton => 'Жаңадан бастау';
	@override String get homeButton => 'Мәзір';
	@override String get continueWithCoins => 'Жалғастыру үшін 100';
}

// Path: adWarning
class _StringsAdWarningKk extends _StringsAdWarningEn {
	_StringsAdWarningKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override TextSpan getCoins({required InlineSpan c, required InlineSpan t}) => TextSpan(children: [
		const TextSpan(text: 'Осы жарнамадан кейін '),
		c,
		const TextSpan(text: ' 100 алыңыз ('),
		t,
		const TextSpan(text: ')'),
	]);
}

// Path: restartGameDialog
class _StringsRestartGameDialogKk extends _StringsRestartGameDialogEn {
	_StringsRestartGameDialogKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ойынды қайта бастау керек пе?';
	@override String get areYouSure => 'Қайта іске қосқыңыз келетініне сенімдісіз бе? Мұны қайтара алмайсыз';
	@override String get waitCancel => 'Күте тұрыңыз, бас тартыңыз!';
	@override String get yesImSure => 'Иә мен сенімдімін!';
}

// Path: tutorialPage
class _StringsTutorialPageKk extends _StringsTutorialPageEn {
	_StringsTutorialPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get tutorial => 'Нұсқаулық';
	@override String get aimAtMonsters => 'Көздеу үшін саусағыңызды жылжытыңыз, ату үшін босатып жіберіңіз. Шырышты жеңу үшін оның денсаулық жолағын нөлге дейін жеткізіңіз.';
	@override String get bounceOffWalls => 'Қабырғадан ыршыған оқ көбірек шырышқа тие алады.';
	@override String get tapSpeedUp => 'Оқ қозғалысын тездету үшін экранды түртіңіз.';
	@override String get dangerZone => 'Қауіпті аймаққа кірген шырышты жеңбесеңіз, келесі жүрісте ұтыласыз.';
	@override String get moreMonsters => 'Сіз ілгерілеген сайын құбыжықтардың көбірек қатарлары пайда болады, сондықтан қауіпті аймақ ұлғаяды.';
}

// Path: shopPage
class _StringsShopPageKk extends _StringsShopPageEn {
	_StringsShopPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get bulletShapes => 'Оқ пішіндері';
	@override String get bulletColors => 'Оқ түсті';
	@override String get title => 'дүкен';
}

// Path: common
class _StringsCommonKk extends _StringsCommonEn {
	_StringsCommonKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Болдырмау';
	@override String get ok => 'ОК';
}
