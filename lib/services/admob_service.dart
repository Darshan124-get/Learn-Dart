import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  // Test Ad Unit IDs - Replace with your actual Ad Unit IDs
  static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  
  // Production Ad Unit IDs (replace with your actual IDs)
  // static const String _bannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  bool get isBannerAdReady => _isBannerAdReady;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  BannerAd createBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
          _isBannerAdReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          _isBannerAdReady = false;
          ad.dispose();
        },
        onAdOpened: (ad) {
          print('Banner ad opened');
        },
        onAdClosed: (ad) {
          print('Banner ad closed');
        },
      ),
    );

    _bannerAd!.load();
    return _bannerAd!;
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdReady = false;
  }

  void dispose() {
    disposeBannerAd();
  }
}
