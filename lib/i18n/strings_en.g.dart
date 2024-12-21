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
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
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
	late final TranslationsHomePageEn homePage = TranslationsHomePageEn.internal(_root);
	late final TranslationsPlayPageEn playPage = TranslationsPlayPageEn.internal(_root);
	late final TranslationsSettingsPageEn settingsPage = TranslationsSettingsPageEn.internal(_root);
	late final TranslationsAgeDialogEn ageDialog = TranslationsAgeDialogEn.internal(_root);
	late final TranslationsGameOverPageEn gameOverPage = TranslationsGameOverPageEn.internal(_root);
	late final TranslationsAdWarningEn adWarning = TranslationsAdWarningEn.internal(_root);
	late final TranslationsRestartGameDialogEn restartGameDialog = TranslationsRestartGameDialogEn.internal(_root);
	late final TranslationsTutorialPageEn tutorialPage = TranslationsTutorialPageEn.internal(_root);
	late final TranslationsShopPageEn shopPage = TranslationsShopPageEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
}

// Path: homePage
class TranslationsHomePageEn {
	TranslationsHomePageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get playButton => 'Play';
	String get shopButton => 'Shop';
	String get settingsButton => 'Settings';
	String get tutorialButton => 'Tutorial';
}

// Path: playPage
class TranslationsPlayPageEn {
	TranslationsPlayPageEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String highScore({required Object p}) => 'Best: ${p}';
	String get undo => 'Undo move';
	String get coins => 'Coins';
}

// Path: settingsPage
class TranslationsSettingsPageEn {
	TranslationsSettingsPageEn.internal(this._root);

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
	String get showFpsCounter => 'Show FPS counter';
	String get appInfo => 'App info';
	String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nThis program comes with absolutely no warranty. This is free software, and you are welcome to redistribute it under certain conditions.';
}

// Path: ageDialog
class TranslationsAgeDialogEn {
	TranslationsAgeDialogEn.internal(this._root);

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
class TranslationsGameOverPageEn {
	TranslationsGameOverPageEn.internal(this._root);

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
class TranslationsAdWarningEn {
	TranslationsAdWarningEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	TextSpan getCoins({required InlineSpan c, required InlineSpan t}) => TextSpan(children: [
		const TextSpan(text: 'Watch an optional ad to get '),
		c,
		const TextSpan(text: ' 100 ('),
		t,
		const TextSpan(text: ')'),
	]);
}

// Path: restartGameDialog
class TranslationsRestartGameDialogEn {
	TranslationsRestartGameDialogEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Restart game?';
	String get areYouSure => 'Are you sure you want to restart? You can\'t undo this';
	String get waitCancel => 'Wait, cancel!';
	String get yesImSure => 'Yes I\'m sure!';
}

// Path: tutorialPage
class TranslationsTutorialPageEn {
	TranslationsTutorialPageEn.internal(this._root);

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
class TranslationsShopPageEn {
	TranslationsShopPageEn.internal(this._root);

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
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get cancel => 'Cancel';
	String get ok => 'Okay';
}
