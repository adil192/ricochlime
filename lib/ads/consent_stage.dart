/// Every app launch, we progress to the next consent stage.
/// 
/// This is to avoid spamming the user with consent dialogs.
enum ConsentStage {
  /// The user needs to enter their birth year.
  askForBirthYear,
  /// The user has entered their birth year,
  /// but we may need to ask for consent to show personalized ads.
  askForPersonalizedAds,
  ;

  ConsentStage get next {
    switch (this) {
      case ConsentStage.askForBirthYear:
        return ConsentStage.askForPersonalizedAds;
      case ConsentStage.askForPersonalizedAds:
        return ConsentStage.askForPersonalizedAds;
    }
  }
}
