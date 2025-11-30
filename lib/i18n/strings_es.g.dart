///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsEs extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEs({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.es,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <es>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsEs _root = this; // ignore: unused_field

	@override 
	TranslationsEs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEs(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'Ricochlime';
	@override late final _TranslationsHomePageEs homePage = _TranslationsHomePageEs._(_root);
	@override late final _TranslationsPlayPageEs playPage = _TranslationsPlayPageEs._(_root);
	@override late final _TranslationsSettingsPageEs settingsPage = _TranslationsSettingsPageEs._(_root);
	@override late final _TranslationsGameOverPageEs gameOverPage = _TranslationsGameOverPageEs._(_root);
	@override late final _TranslationsRestartGameDialogEs restartGameDialog = _TranslationsRestartGameDialogEs._(_root);
	@override late final _TranslationsTutorialPageEs tutorialPage = _TranslationsTutorialPageEs._(_root);
	@override late final _TranslationsShopPageEs shopPage = _TranslationsShopPageEs._(_root);
}

// Path: homePage
class _TranslationsHomePageEs extends TranslationsHomePageEn {
	_TranslationsHomePageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get shopButton => 'Comercio';
	@override String get tutorialButton => 'tutorial';
	@override String get playButton => 'Jugar';
	@override String get settingsButton => 'Ajustes';
}

// Path: playPage
class _TranslationsPlayPageEs extends TranslationsPlayPageEn {
	_TranslationsPlayPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get coins => 'monedas';
	@override String get undo => 'Deshacer movimiento';
	@override String highScore({required Object p}) => 'Mejor: ${p}';
}

// Path: settingsPage
class _TranslationsSettingsPageEs extends TranslationsSettingsPageEn {
	_TranslationsSettingsPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get showFpsCounter => 'Mostrar contador de FPS';
	@override String get stylizedPageTransitions => 'Transiciones de página estilizadas';
	@override String get showReflectionInAimGuide => 'Mostrar reflejo en la guía de objetivos.';
	@override String get hyperlegibleFont => 'Fuente fácil de leer';
	@override String get biggerBullets => 'balas mas grandes';
	@override String get gameplay => 'Como se Juega';
	@override String get accessibility => 'Accesibilidad';
	@override String get maxFps => 'FPS máx.';
	@override String get showUndoButton => 'Permitir deshacer movimientos';
	@override String get title => 'Ajustes';
	@override String get bgmVolume => 'Volumen de la música de fondo';
	@override String get appInfo => 'Informacion de la applicacion';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nEste programa no tiene ninguna garantía. Este es un software gratuito y puede redistribuirlo bajo ciertas condiciones.\n';
}

// Path: gameOverPage
class _TranslationsGameOverPageEs extends TranslationsGameOverPageEn {
	_TranslationsGameOverPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

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

// Path: restartGameDialog
class _TranslationsRestartGameDialogEs extends TranslationsRestartGameDialogEn {
	_TranslationsRestartGameDialogEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get title => '¿Reinicia el juego?';
	@override String get areYouSure => '¿Estás seguro de que quieres reiniciar? No puedes deshacer esto';
	@override String get waitCancel => '¡Espera, cancela!';
	@override String get yesImSure => '¡Sí estoy seguro!';
}

// Path: tutorialPage
class _TranslationsTutorialPageEs extends TranslationsTutorialPageEn {
	_TranslationsTutorialPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

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
class _TranslationsShopPageEs extends TranslationsShopPageEn {
	_TranslationsShopPageEs._(TranslationsEs root) : this._root = root, super.internal(root);

	final TranslationsEs _root; // ignore: unused_field

	// Translations
	@override String get buy1000Coins => 'Comprar 1000 monedas';
	@override String get buy5000Coins => 'Comprar 5000 monedas';
	@override String get restorePurchases => 'Restaurar las compras';
	@override String get premium => 'De primera calidad';
	@override String get bulletShapes => 'Formas de bala';
	@override String get bulletColors => 'Colores de bala';
	@override String get title => 'Comercio';
}
