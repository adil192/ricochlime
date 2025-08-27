///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  );

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'Ricochlime'
	String get appName => 'Ricochlime';

	late final TranslationsHomePageEn homePage = TranslationsHomePageEn.internal(_root);
	late final TranslationsPlayPageEn playPage = TranslationsPlayPageEn.internal(_root);
	late final TranslationsSettingsPageEn settingsPage = TranslationsSettingsPageEn.internal(_root);
	late final TranslationsGameOverPageEn gameOverPage = TranslationsGameOverPageEn.internal(_root);
	late final TranslationsRestartGameDialogEn restartGameDialog = TranslationsRestartGameDialogEn.internal(_root);
	late final TranslationsTutorialPageEn tutorialPage = TranslationsTutorialPageEn.internal(_root);
	late final TranslationsShopPageEn shopPage = TranslationsShopPageEn.internal(_root);
}

// Path: homePage
class TranslationsHomePageEn {
	TranslationsHomePageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Play'
	String get playButton => 'Play';

	/// en: 'Shop'
	String get shopButton => 'Shop';

	/// en: 'Settings'
	String get settingsButton => 'Settings';

	/// en: 'Tutorial'
	String get tutorialButton => 'Tutorial';
}

// Path: playPage
class TranslationsPlayPageEn {
	TranslationsPlayPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Best: $p'
	String highScore({required Object p}) => 'Best: ${p}';

	/// en: 'Undo move'
	String get undo => 'Undo move';

	/// en: 'Coins'
	String get coins => 'Coins';
}

// Path: settingsPage
class TranslationsSettingsPageEn {
	TranslationsSettingsPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Gameplay'
	String get gameplay => 'Gameplay';

	/// en: 'Accessibility'
	String get accessibility => 'Accessibility';

	/// en: 'Easy-to-read font'
	String get hyperlegibleFont => 'Easy-to-read font';

	/// en: 'Stylized page transitions'
	String get stylizedPageTransitions => 'Stylized page transitions';

	/// en: 'Bg music volume'
	String get bgmVolume => 'Bg music volume';

	/// en: 'Allow undoing moves'
	String get showUndoButton => 'Allow undoing moves';

	/// en: 'Show reflection in aim guide'
	String get showReflectionInAimGuide => 'Show reflection in aim guide';

	/// en: 'Bigger bullets'
	String get biggerBullets => 'Bigger bullets';

	/// en: 'Max FPS'
	String get maxFps => 'Max FPS';

	/// en: 'Show FPS counter'
	String get showFpsCounter => 'Show FPS counter';

	/// en: 'App info'
	String get appInfo => 'App info';

	/// en: 'Ricochlime Copyright (C) 2023-$buildYear Adil Hanney This program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.'
	String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nThis program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.';
}

// Path: gameOverPage
class TranslationsGameOverPageEn {
	TranslationsGameOverPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Game over!'
	String get title => 'Game over!';

	/// en: 'You scored $p points!'
	String highScoreNotBeaten({required Object p}) => 'You scored ${p} points!';

	/// en: 'Your high score is now $pOld $pNew points!'
	TextSpan highScoreBeaten({required InlineSpan pOld, required InlineSpan pNew}) => TextSpan(children: [
		const TextSpan(text: 'Your high score is now '),
		pOld,
		const TextSpan(text: ' '),
		pNew,
		const TextSpan(text: ' points!'),
	]);

	/// en: '100 to continue'
	String get continueWithCoins => '100 to continue';

	/// en: 'Restart game'
	String get restartGameButton => 'Restart game';

	/// en: 'Home'
	String get homeButton => 'Home';
}

// Path: restartGameDialog
class TranslationsRestartGameDialogEn {
	TranslationsRestartGameDialogEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Restart game?'
	String get title => 'Restart game?';

	/// en: 'Are you sure you want to restart? You can't undo this'
	String get areYouSure => 'Are you sure you want to restart? You can\'t undo this';

	/// en: 'Wait, cancel!'
	String get waitCancel => 'Wait, cancel!';

	/// en: 'Yes I'm sure!'
	String get yesImSure => 'Yes I\'m sure!';
}

// Path: tutorialPage
class TranslationsTutorialPageEn {
	TranslationsTutorialPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tutorial'
	String get tutorial => 'Tutorial';

	/// en: 'Defeat the monsters by dragging to aim and releasing to shoot.'
	String get dragAndRelease => 'Defeat the monsters by dragging to aim and releasing to shoot.';

	/// en: 'Defeat the monsters by moving your mouse to aim and clicking to shoot.'
	String get pointAndClick => 'Defeat the monsters by moving your mouse to aim and clicking to shoot.';

	/// en: 'After defeating a gold monster, you'll get a coin.'
	String get goldMonsters => 'After defeating a gold monster, you\'ll get a coin.';

	/// en: 'After defeating a green monster, you'll get an extra bullet.'
	String get greenMonsters => 'After defeating a green monster, you\'ll get an extra bullet.';

	/// en: 'Bounce your shots off the walls to hit the most monsters.'
	String get bounceOffWalls => 'Bounce your shots off the walls to hit the most monsters.';

	/// en: 'Tap the screen to speed up your shots.'
	String get tapSpeedUp => 'Tap the screen to speed up your shots.';

	/// en: 'A monster that reaches the skull line means game over if you don't defeat it in the next turn.'
	String get skullLine => 'A monster that reaches the skull line means game over if you don\'t defeat it in the next turn.';

	/// en: 'More rows of monsters will spawn each turn as you progress, so the skull line will move up.'
	String get moreMonsters => 'More rows of monsters will spawn each turn as you progress, so the skull line will move up.';

	/// en: 'Save up coins to unlock new items in the shop...'
	String get useCoinsInShop => 'Save up coins to unlock new items in the shop...';

	/// en: '...or use them to continue after a game over.'
	String get orUseCoinsToContinue => '...or use them to continue after a game over.';
}

// Path: shopPage
class TranslationsShopPageEn {
	TranslationsShopPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Shop'
	String get title => 'Shop';

	/// en: 'Bullet colors'
	String get bulletColors => 'Bullet colors';

	/// en: 'Bullet shapes'
	String get bulletShapes => 'Bullet shapes';

	/// en: 'Premium'
	String get premium => 'Premium';

	/// en: 'Restore purchases'
	String get restorePurchases => 'Restore purchases';

	/// en: 'Buy 1000 coins'
	String get buy1000Coins => 'Buy 1000 coins';

	/// en: 'Buy 5000 coins'
	String get buy5000Coins => 'Buy 5000 coins';
}
