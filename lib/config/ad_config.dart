class AdConfig {
  // AdMob App ID (already set in AndroidManifest.xml)
  static const String appId = 'ca-app-pub-5165221633271822~7740108112';

  // Banner Ad Unit IDs
  static const String bannerAdUnitId = 'ca-app-pub-5165221633271822/2244524260';
  static const String bannerAdUnitId2 = 'ca-app-pub-5165221633271822/2244524260';

  // Test Ad Unit IDs (for development/testing)
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerAdUnitId2 = 'ca-app-pub-3940256099942544/9214589741';

  // Set to true for production, false for testing
  static const bool isProduction = true; // Now using production ads

  // Get the appropriate ad unit ID based on environment
  static String getBannerAdUnitId() {
    return isProduction ? bannerAdUnitId : testBannerAdUnitId;
  }

  static String getBannerAdUnitId2() {
    return isProduction ? bannerAdUnitId2 : testBannerAdUnitId2;
  }
}
