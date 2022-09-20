import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_config_constants.dart';

class AdHelper {

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.interstitialAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.interstitialAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}

//ignore: must_be_immutable
class RewardedInterstitialAds extends StatelessWidget {
  final VoidCallback onRewarded;

  RewardedInterstitialAds({Key? key, required this.onRewarded}) : super(key: key);
  RewardedInterstitialAd? _rewardedInterstitialAd;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void loadInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _rewardedInterstitialAd = ad;
            showRewardedAds();
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('RewardedInterstitialAd failed to load: $error');
          },
        ));
  }

  showRewardedAds(){
    _rewardedInterstitialAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
      onRewarded();
    });
  }
}
