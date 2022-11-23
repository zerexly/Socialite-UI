class AppConfigConstants {
  // Name of app
  static String appName = 'Socialified';
  static String currentVersion = '1.5';

  static int maximumVideoDurationAllowed = 120; // it must be in seconds

  static int freeLiveTvDurationToView = 120; // it must be in seconds

  static String latestAppDownloadLink =
      'https://codecanyon.net/item/timeline-chat-calling-live-social-media-photo-video-sharing-app-iosandroidadmin-panel/39825646';

  static String appTagline = 'Share your day activity with friends';

  // disclaimer url for competitions
  static String disclaimerUrl =
      'https://docs.google.com/document/d/1JAuY_yJ0ldmmGR63aLAZMwGMFR8NLSeF7dWO1wPSrGs/edit?usp=sharing';

  // Privacy policy url
  static String privacyPolicyUrl =
      'https://docs.google.com/document/d/1JAuY_yJ0ldmmGR63aLAZMwGMFR8NLSeF7dWO1wPSrGs/edit?usp=sharing';

  // Terms of user url
  static String termsOfServiceUrl =
      'https://docs.google.com/document/d/1JAuY_yJ0ldmmGR63aLAZMwGMFR8NLSeF7dWO1wPSrGs/edit?usp=sharing';

  // Giphy api key for gif and stickers in chat
  static const giphyApiKey = 'Bp2tAtugaAvjWhBsk8IH0Oc7BeE9Ug22';

  // agora api call for audio video calling and live
  static const agoraApiKey = '52aa6d82f3f14aa3bd36b7a0fb6648f4';

  // google map api key for sharing location in chat
  static const googleMapApiKey = 'AIzaSyBOSn0omCgR27SLAZcXxFgWFOFl4k4jnj0';

  // Rest api base url
  static const restApiBaseUrl =
      'https://fwdtechnology.co/socialified/api/web/v1/';

  // Socket api url
  static const socketApiBaseUrl = "http://fwdtechnology.co:4000/";

  // is demo app
  static const bool isDemoApp = true;
}

class AdsNetwork {
  //1 for facebook, 2 for google admob
  static const networkToUse = 2;
}

class AdmobConstants {
  static const interstitialAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/5135589807';
  static const interstitialAdUnitIdForiOS =
      'ca-app-pub-3940256099942544/5135589807';

  static const rewardInterstitlAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/5354046379';
  static const rewardInterstitialAdUnitIdForiOS =
      'ca-app-pub-3940256099942544/5354046379';

  static const bannerAdUnitIdForAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const bannerAdUnitIdForiOS = 'ca-app-pub-3940256099942544/6300978111';
}

class FacebookAudienceNetworkConstants {
  static const interstitialAdUnitIdForAndroid =
      '378a317f-e1dd-4d7d-a8f5-c5886ae407a';
  static const interstitialAdUnitIdForiOS =
      '378a317f-e1dd-4d7d-a8f5-c5886ae407a';

  static const rewardInterstitialAdUnitIdForAndroid =
      '378a317f-e1dd-4d7d-a8f5-c5886ae407a';
  static const rewardInterstitialAdUnitIdForiOS =
      '378a317f-e1dd-4d7d-a8f5-c5886ae407a';
}

class Assets {
  static const dummyProfilePictureUrl =
      'https://images.unsplash.com/photo-1516817206129-e2fcbc3169cc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=987&q=80';
}
