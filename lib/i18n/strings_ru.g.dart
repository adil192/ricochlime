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
class TranslationsRu extends Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'Рикошлим';
	@override late final _TranslationsHomePageRu homePage = _TranslationsHomePageRu._(_root);
	@override late final _TranslationsPlayPageRu playPage = _TranslationsPlayPageRu._(_root);
	@override late final _TranslationsSettingsPageRu settingsPage = _TranslationsSettingsPageRu._(_root);
	@override late final _TranslationsGameOverPageRu gameOverPage = _TranslationsGameOverPageRu._(_root);
	@override late final _TranslationsRestartGameDialogRu restartGameDialog = _TranslationsRestartGameDialogRu._(_root);
	@override late final _TranslationsTutorialPageRu tutorialPage = _TranslationsTutorialPageRu._(_root);
	@override late final _TranslationsShopPageRu shopPage = _TranslationsShopPageRu._(_root);
}

// Path: homePage
class _TranslationsHomePageRu extends TranslationsHomePageEn {
	_TranslationsHomePageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get playButton => 'Играть';
	@override String get shopButton => 'Купить';
	@override String get settingsButton => 'Настройки';
	@override String get tutorialButton => 'Как играть';
}

// Path: playPage
class _TranslationsPlayPageRu extends TranslationsPlayPageEn {
	_TranslationsPlayPageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String highScore({required Object p}) => 'Лучший: ${p}';
	@override String get undo => 'Отменить бросок';
	@override String get coins => 'Монетки';
}

// Path: settingsPage
class _TranslationsSettingsPageRu extends TranslationsSettingsPageEn {
	_TranslationsSettingsPageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Настройки';
	@override String get gameplay => 'Игра';
	@override String get accessibility => 'Доступность';
	@override String get hyperlegibleFont => 'Большой шрифт';
	@override String get bgmVolume => 'Громкость фоновой музыки';
	@override String get showUndoButton => 'Разрешить отмену бросков';
	@override String get showReflectionInAimGuide => 'Показывать отскок в прицельной траектории';
	@override String get biggerBullets => 'Большие мячики';
	@override String get maxFps => 'Максимальный FPS';
	@override String get appInfo => 'О программе';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nThis program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.';
	@override String get showFpsCounter => 'Показать счетчик FPS';
	@override String get stylizedPageTransitions => 'Стилизованные переходы страниц';
}

// Path: gameOverPage
class _TranslationsGameOverPageRu extends TranslationsGameOverPageEn {
	_TranslationsGameOverPageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

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

// Path: restartGameDialog
class _TranslationsRestartGameDialogRu extends TranslationsRestartGameDialogEn {
	_TranslationsRestartGameDialogRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Перезапустить игру?';
	@override String get areYouSure => 'Вы уверену что хотите начать снова? Вы не сможете вернуться';
	@override String get waitCancel => 'Подождите, я передумал!';
	@override String get yesImSure => 'Ну конечно!';
}

// Path: tutorialPage
class _TranslationsTutorialPageRu extends TranslationsTutorialPageEn {
	_TranslationsTutorialPageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

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
class _TranslationsShopPageRu extends TranslationsShopPageEn {
	_TranslationsShopPageRu._(TranslationsRu root) : this._root = root, super.internal(root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Магазин';
	@override String get bulletColors => 'Цвета мячика';
	@override String get bulletShapes => 'Формы мячика';
	@override String get premium => 'Премиум';
	@override String get restorePurchases => 'Востановить покупки';
	@override String get buy1000Coins => 'Купить 1000 монет';
	@override String get buy5000Coins => 'Купить 5000 монет';
}
