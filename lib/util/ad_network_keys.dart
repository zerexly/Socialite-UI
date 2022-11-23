import 'package:foap/helper/common_import.dart';

class FacebookAudienceNetworkKeys {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.interstitialAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.interstitialAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.rewardInterstitlAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.rewardInterstitialAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}

class AdmobKeys {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.interstitialAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.interstitialAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.rewardInterstitlAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.rewardInterstitialAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AdmobConstants.bannerAdUnitIdForAndroid;
    } else if (Platform.isIOS) {
      return AdmobConstants.bannerAdUnitIdForiOS;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
