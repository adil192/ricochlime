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
class TranslationsKk extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsKk({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.kk,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

	/// Metadata for the translations of <kk>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	late final TranslationsKk _root = this; // ignore: unused_field

	@override 
	TranslationsKk $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsKk(meta: meta ?? this.$meta);

	// Translations
	@override String get appName => 'Рикошырыш';
	@override late final _TranslationsHomePageKk homePage = _TranslationsHomePageKk._(_root);
	@override late final _TranslationsPlayPageKk playPage = _TranslationsPlayPageKk._(_root);
	@override late final _TranslationsSettingsPageKk settingsPage = _TranslationsSettingsPageKk._(_root);
	@override late final _TranslationsGameOverPageKk gameOverPage = _TranslationsGameOverPageKk._(_root);
	@override late final _TranslationsRestartGameDialogKk restartGameDialog = _TranslationsRestartGameDialogKk._(_root);
	@override late final _TranslationsTutorialPageKk tutorialPage = _TranslationsTutorialPageKk._(_root);
	@override late final _TranslationsShopPageKk shopPage = _TranslationsShopPageKk._(_root);
}

// Path: homePage
class _TranslationsHomePageKk extends TranslationsHomePageEn {
	_TranslationsHomePageKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

	// Translations
	@override String get playButton => 'Ойнау';
	@override String get settingsButton => 'Баптау';
	@override String get tutorialButton => 'Нұсқаулық';
	@override String get shopButton => 'дүкен';
}

// Path: playPage
class _TranslationsPlayPageKk extends TranslationsPlayPageEn {
	_TranslationsPlayPageKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

	// Translations
	@override String highScore({required Object p}) => 'Үздік: ${p}';
	@override String get coins => 'Монеталар';
	@override String get undo => 'Қозғалысты болдырмау';
}

// Path: settingsPage
class _TranslationsSettingsPageKk extends TranslationsSettingsPageEn {
	_TranslationsSettingsPageKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

	// Translations
	@override String get title => 'Баптау';
	@override String get appInfo => 'Қолданба ақпары';
	@override String licenseNotice({required Object buildYear}) => 'Ricochlime  Copyright (C) 2023-${buildYear}  Adil Hanney\nБұл бағдарлама еш кепілдіксіз жеткізіледі. Ол еркін екенін ескере отырып, сіз оны кейбір шарттардың аясында еркін тарата аласыз.';
	@override String get showFpsCounter => 'FPS есептегішін көрсету';
	@override String get stylizedPageTransitions => 'Стильденген беттердің ауысуы';
	@override String get showReflectionInAimGuide => 'Мақсат нұсқаулығында рефлексияны көрсетіңіз';
	@override String get hyperlegibleFont => 'Оқуға оңай шрифт';
	@override String get biggerBullets => 'Үлкенірек оқтар';
	@override String get gameplay => 'Ойын барысы';
	@override String get accessibility => 'Қол жетімділік';
	@override String get maxFps => 'Максималды FPS';
	@override String get showUndoButton => 'Қозғалысты қайтаруға рұқсат беріңіз';
	@override String get bgmVolume => 'Фондық музыканың дыбыс деңгейі';
}

// Path: gameOverPage
class _TranslationsGameOverPageKk extends TranslationsGameOverPageEn {
	_TranslationsGameOverPageKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

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

// Path: restartGameDialog
class _TranslationsRestartGameDialogKk extends TranslationsRestartGameDialogEn {
	_TranslationsRestartGameDialogKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ойынды қайта бастау керек пе?';
	@override String get areYouSure => 'Қайта іске қосқыңыз келетініне сенімдісіз бе? Мұны қайтара алмайсыз';
	@override String get waitCancel => 'Күте тұрыңыз, бас тартыңыз!';
	@override String get yesImSure => 'Иә мен сенімдімін!';
}

// Path: tutorialPage
class _TranslationsTutorialPageKk extends TranslationsTutorialPageEn {
	_TranslationsTutorialPageKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

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
class _TranslationsShopPageKk extends TranslationsShopPageEn {
	_TranslationsShopPageKk._(TranslationsKk root) : this._root = root, super.internal(root);

	final TranslationsKk _root; // ignore: unused_field

	// Translations
	@override String get buy5000Coins => '5000 тиын сатып алыңыз';
	@override String get buy1000Coins => '1000 тиын сатып алыңыз';
	@override String get restorePurchases => 'Сатып алуларды қалпына келтіріңіз';
	@override String get premium => 'Премиум';
	@override String get bulletShapes => 'Оқ пішіндері';
	@override String get bulletColors => 'Оқ түсті';
	@override String get title => 'дүкен';
}
