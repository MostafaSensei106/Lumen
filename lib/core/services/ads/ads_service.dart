abstract class AdsService {
  Future<void> initialize();
  Future<void> loadRewardedAd({required String adUnitId});
  Future<void> showRewardedAd({required Function onUserEarnedReward});
  Future<void> loadInterstitialAd({required String adUnitId});
  Future<void> showInterstitialAd();
  void dispose();
}
