/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 4
/// Strings: 276 (69 per locale)
///
/// Built on 2024-08-07 at 22:25 UTC

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
	kk(languageCode: 'kk', build: _StringsKk.build),
	ru(languageCode: 'ru', build: _StringsRu.build);

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
	String get removeAdsInShop => 'Want to remove ads? Check out the options in the shop!';
	String get hyperlegibleFont => 'Easy-to-read font';
	String get stylizedPageTransitions => 'Stylized page transitions';
	String get bgmVolume => 'Bg music volume';
	String get showUndoButton => 'Allow undoing moves';
	String get showReflectionInAimGuide => 'Show reflection in aim guide';
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
	String get dragAndRelease => 'Defeat the monsters by dragging to aim and releasing to shoot.';
	String get pointAndClick => 'Defeat the monsters by moving your mouse to aim and clicking to shoot.';
	String get goldMonsters => 'After defeating a gold monster, you\'ll get a coin.';
	String get greenMonsters => 'After defeating a green monster, you\'ll get an extra bullet.';
	String get bounceOffWalls => 'Bounce your shots off the walls to hit the most monsters.';
	String get tapSpeedUp => 'Tap the screen to speed up your shots.';
	String get skullLine => 'A monster that reaches the skull line means game over if you don\'t defeat it in the next turn.';
	String get moreMonsters => 'More rows of monsters will spawn each turn as you progress, so the skull line will move up.';
	String get useCoinsInShop => 'Save up coins to unlock new items in the shop...';
	String get orUseCoinsToContinue => '...or use them to continue after a game over.';
}

// Path: shopPage
class _StringsShopPageEn {
	_StringsShopPageEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Shop';
	String get bulletColors => 'Bullet colors';
	String get bulletShapes => 'Bullet shapes';
	String get premium => 'Premium';
	String get removeAdsForever => 'Remove ads forever';
	String get restorePurchases => 'Restore purchases';
	String get buy1000Coins => 'Buy 1000 coins';
	String get buy5000Coins => 'Buy 5000 coins';
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
	@override String get stylizedPageTransitions => 'Transiciones de página estilizadas';
	@override String get removeAdsInShop => '¿Quieres eliminar los anuncios? ¡Consulta las opciones en la tienda!';
	@override String get showReflectionInAimGuide => 'Mostrar reflejo en la guía de objetivos.';
	@override String get ads => 'Anuncios';
	@override String get hyperlegibleFont => 'Fuente fácil de leer';
	@override String get biggerBullets => 'balas mas grandes';
	@override String get gameplay => 'Como se Juega';
	@override String get accessibility => 'Accesibilidad';
	@override String get maxFps => 'FPS máx.';
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
	@override String get dragAndRelease => 'Derrota a los monstruos arrastrándolos para apuntar y soltándolos para disparar.';
	@override String get pointAndClick => 'Derrota a los monstruos moviendo el mouse para apuntar y haciendo clic para disparar.';
	@override String get goldMonsters => 'Después de derrotar a un monstruo dorado, obtendrás una moneda.';
	@override String get greenMonsters => 'Después de derrotar a un monstruo verde, recibirás una bala extra.';
	@override String get skullLine => 'Un monstruo que llega a la línea del cráneo significa que el juego se acaba si no lo derrotas en el siguiente turno.';
	@override String get useCoinsInShop => 'Ahorra monedas para desbloquear nuevos artículos en la tienda...';
	@override String get orUseCoinsToContinue => '...o úsalos para continuar después de que termine el juego.';
	@override String get tutorial => 'tutorial';
	@override String get bounceOffWalls => 'Rebota tus tiros en las paredes para golpear a la mayor cantidad de monstruos.';
	@override String get tapSpeedUp => 'Toca la pantalla para acelerar tus disparos.';
	@override String get moreMonsters => 'Aparecerán más filas de monstruos en cada turno a medida que avances, por lo que la zona de peligro también se hará más grande.';
}

// Path: shopPage
class _StringsShopPageEs extends _StringsShopPageEn {
	_StringsShopPageEs._(_StringsEs root) : this._root = root, super._(root);

	@override final _StringsEs _root; // ignore: unused_field

	// Translations
	@override String get buy1000Coins => 'Comprar 1000 monedas';
	@override String get buy5000Coins => 'Comprar 5000 monedas';
	@override String get restorePurchases => 'Restaurar las compras';
	@override String get premium => 'De primera calidad';
	@override String get removeAdsForever => 'Eliminar anuncios para siempre';
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
	@override String get stylizedPageTransitions => 'Стильденген беттердің ауысуы';
	@override String get appInfo => 'Қолданба ақпары';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nБұл бағдарлама еш кепілдіксіз жеткізіледі. Ол еркін екенін ескере отырып, сіз оны кейбір шарттардың аясында еркін тарата аласыз.';
	@override String get removeAdsInShop => 'Жарнамаларды өшіргіңіз келе ме? Дүкенде опцияларды тексеріңіз!';
	@override String get showReflectionInAimGuide => 'Мақсат нұсқаулығында рефлексияны көрсетіңіз';
	@override String get ads => 'Жарнамалар';
	@override String get hyperlegibleFont => 'Оқуға оңай шрифт';
	@override String get biggerBullets => 'Үлкенірек оқтар';
	@override String get gameplay => 'Ойын барысы';
	@override String get accessibility => 'Қол жетімділік';
	@override String get maxFps => 'Максималды FPS';
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
	@override String get bounceOffWalls => 'Қабырғадан ыршыған оқ көбірек шырышқа тие алады.';
	@override String get tapSpeedUp => 'Оқ қозғалысын тездету үшін экранды түртіңіз.';
	@override String get dragAndRelease => 'Мақсатқа апару және ату үшін босату арқылы құбыжықтарды жеңіңіз.';
	@override String get pointAndClick => 'Тінтуірді мақсатқа жылжыту және ату үшін басу арқылы құбыжықтарды жеңіңіз.';
	@override String get goldMonsters => 'Алтын құбыжықты жеңгеннен кейін сіз тиын аласыз.';
	@override String get greenMonsters => 'Жасыл құбыжықты жеңгеннен кейін сіз қосымша оқ аласыз.';
	@override String get skullLine => 'Бас сүйегінің сызығына жеткен құбыжық келесі кезекте оны жеңбесеңіз, ойын аяқталды дегенді білдіреді.';
	@override String get useCoinsInShop => 'Дүкенде жаңа заттардың құлпын ашу үшін тиындарды сақтаңыз...';
	@override String get orUseCoinsToContinue => '...немесе оларды ойын аяқталғаннан кейін жалғастыру үшін пайдаланыңыз.';
	@override String get moreMonsters => 'Сіз ілгерілеген сайын құбыжықтардың көбірек қатарлары пайда болады, сондықтан қауіпті аймақ ұлғаяды.';
}

// Path: shopPage
class _StringsShopPageKk extends _StringsShopPageEn {
	_StringsShopPageKk._(_StringsKk root) : this._root = root, super._(root);

	@override final _StringsKk _root; // ignore: unused_field

	// Translations
	@override String get buy5000Coins => '5000 тиын сатып алыңыз';
	@override String get buy1000Coins => '1000 тиын сатып алыңыз';
	@override String get restorePurchases => 'Сатып алуларды қалпына келтіріңіз';
	@override String get premium => 'Премиум';
	@override String get removeAdsForever => 'Жарнамаларды біржола алып тастаңыз';
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

// Path: <root>
class _StringsRu extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsRu.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	@override late final _StringsRu _root = this; // ignore: unused_field

	// Translations
	@override String get appName => 'Рикошлим';
	@override late final _StringsHomePageRu homePage = _StringsHomePageRu._(_root);
	@override late final _StringsPlayPageRu playPage = _StringsPlayPageRu._(_root);
	@override late final _StringsSettingsPageRu settingsPage = _StringsSettingsPageRu._(_root);
	@override late final _StringsAgeDialogRu ageDialog = _StringsAgeDialogRu._(_root);
	@override late final _StringsGameOverPageRu gameOverPage = _StringsGameOverPageRu._(_root);
	@override late final _StringsAdWarningRu adWarning = _StringsAdWarningRu._(_root);
	@override late final _StringsRestartGameDialogRu restartGameDialog = _StringsRestartGameDialogRu._(_root);
	@override late final _StringsTutorialPageRu tutorialPage = _StringsTutorialPageRu._(_root);
	@override late final _StringsShopPageRu shopPage = _StringsShopPageRu._(_root);
	@override late final _StringsCommonRu common = _StringsCommonRu._(_root);
}

// Path: homePage
class _StringsHomePageRu extends _StringsHomePageEn {
	_StringsHomePageRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get playButton => 'Играть';
	@override String get shopButton => 'Купить';
	@override String get settingsButton => 'Настройки';
	@override String get tutorialButton => 'Как играть';
}

// Path: playPage
class _StringsPlayPageRu extends _StringsPlayPageEn {
	_StringsPlayPageRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String highScore({required Object p}) => 'Лучший: ${p}';
	@override String get undo => 'Отменить бросок';
	@override String get coins => 'Монетки';
}

// Path: settingsPage
class _StringsSettingsPageRu extends _StringsSettingsPageEn {
	_StringsSettingsPageRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override String get ads => 'Реклама';
	@override String get gameplay => 'Игра';
	@override String get accessibility => 'Доступность';
	@override String get adConsent => 'Изменить согласие с рекламой';
	@override String get hyperlegibleFont => 'Большой шрифт';
	@override String get stylizedPageTransitions => 'Стилизованные переходы страниц';
	@override String get bgmVolume => 'Громкость фоновой музыки';
	@override String get showUndoButton => 'Разрешить отмену бросков';
	@override String get showReflectionInAimGuide => 'Показывать отскок в прицельной траектории';
	@override String get biggerBullets => 'Большие мячики';
	@override String get maxFps => 'Максимальный FPS';
	@override String get appInfo => 'О программе';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nThis program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.';
	@override String get removeAdsInShop => 'Хотите удалить рекламу? Посмотрите варианты в магазине!';
}

// Path: ageDialog
class _StringsAgeDialogRu extends _StringsAgeDialogEn {
	_StringsAgeDialogRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get yourAge => 'Ваш возраст';
	@override String get letMeGuessYourAge => 'Давайте-ка угадаю ваш возраст';
	@override String get unknown => 'Неизвестно';
	@override String get reason => 'Нам нужно знать ваш возраст чтобы знать какую рекламу показывать. Это не влияет на саму игру.';
	@override String guessNumber({required Object n}) => 'Угадайте число \#${n}';
	@override String areYou({required Object age}) => 'Вам ${age} лет?';
	@override String get younger => 'Не, я моложе';
	@override String get older => 'Нет, я старше';
	@override String yesMyAgeIs({required Object age}) => 'Да, мне ${age} лет';
	@override String get reset => 'Сбросить';
	@override String get howOldAreYou => 'Сколько вам лет?';
	@override String get invalidAge => 'Пожалуйста введите ваш возраст';
	@override String get useMinigame => 'Поиграть в угадайку';
	@override String get useSimpleInput => 'Ввести вручную';
}

// Path: gameOverPage
class _StringsGameOverPageRu extends _StringsGameOverPageEn {
	_StringsGameOverPageRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Игра окончена!';
	@override String highScoreNotBeaten({required Object p}) => 'Вы заработали ${p} очков!';
	@override TextSpan highScoreBeaten({required InlineSpan pOld, required InlineSpan pNew}) => TextSpan(children: [
		const TextSpan(text: 'Ваше наилучшее достижение теперь '),
		pOld,
		const TextSpan(text: ' '),
		pNew,
		const TextSpan(text: ' очков!'),
	]);
	@override String get continueWithCoins => 'Продолжить за 100';
	@override String get restartGameButton => 'Перезапустить игру';
	@override String get homeButton => 'На главную';
}

// Path: adWarning
class _StringsAdWarningRu extends _StringsAdWarningEn {
	_StringsAdWarningRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override TextSpan getCoins({required InlineSpan c, required InlineSpan t}) => TextSpan(children: [
		const TextSpan(text: 'Получить '),
		c,
		const TextSpan(text: ' 100 после этой рекламы ('),
		t,
		const TextSpan(text: ')'),
	]);
}

// Path: restartGameDialog
class _StringsRestartGameDialogRu extends _StringsRestartGameDialogEn {
	_StringsRestartGameDialogRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Перезапустить игру?';
	@override String get areYouSure => 'Вы уверену что хотите начать снова? Вы не сможете вернуться';
	@override String get waitCancel => 'Подождите, я передумал!';
	@override String get yesImSure => 'Ну конечно!';
}

// Path: tutorialPage
class _StringsTutorialPageRu extends _StringsTutorialPageEn {
	_StringsTutorialPageRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get tutorial => 'Как играть';
	@override String get dragAndRelease => 'Defeat the monsters by dragging to aim and releasing to shoot.';
	@override String get pointAndClick => 'Defeat the monsters by moving your mouse to aim and clicking to shoot.';
	@override String get goldMonsters => 'Убив золотого монстра получаете монетку.';
	@override String get greenMonsters => 'Убив зелёного монстра получаете дополнительный мячик.';
	@override String get bounceOffWalls => 'Bounce your shots off the walls to hit the most monsters.';
	@override String get tapSpeedUp => 'Прикоснитесь к экрану чтобы ускорить ваш выстрел.';
	@override String get skullLine => 'A monster that reaches the skull line means game over if you don\'t defeat it in the next turn.';
	@override String get moreMonsters => 'More rows of monsters will spawn each turn as you progress, so the skull line will move up.';
	@override String get useCoinsInShop => 'Save up coins to unlock new items in the shop...';
	@override String get orUseCoinsToContinue => '...or use them to continue after a game over.';
}

// Path: shopPage
class _StringsShopPageRu extends _StringsShopPageEn {
	_StringsShopPageRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Магазин';
	@override String get bulletColors => 'Цвета мячика';
	@override String get bulletShapes => 'Формы мячика';
	@override String get premium => 'Премиум';
	@override String get removeAdsForever => 'Удалить рекламу навсегда';
	@override String get restorePurchases => 'Востановить покупки';
	@override String get buy1000Coins => 'Купить 1000 монет';
	@override String get buy5000Coins => 'Купить 5000 монет';
}

// Path: common
class _StringsCommonRu extends _StringsCommonEn {
	_StringsCommonRu._(_StringsRu root) : this._root = root, super._(root);

	@override final _StringsRu _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'Отмена';
	@override String get ok => 'Окей';
}
