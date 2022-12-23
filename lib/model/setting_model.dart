class SettingModel {
  String? siteName;
  String? email;
  String? phone;
  String? inAppPurchaseId;
  int? isUploadImage;
  int? isUploadVideo;
  int? uploadMaxFile;
  String? facebook;
  String? youtube;
  String? twitter;
  String? linkedin;
  String? pinterest;
  String? instagram;
  String? siteUrl;
  int watchVideoRewardCoins;
  String? latestVersion;
  String? maximumVideoDurationAllowed;
  String? freeLiveTvDurationToView;
  String? latestAppDownloadLink;
  String? disclaimerUrl;
  String? privacyPolicyUrl;
  String? termsOfServiceUrl;
  String? giphyApiKey;

  // String? agoraApiKey;
  // String? googleMapApiKey;
  String? interstitialAdUnitIdForAndroid;
  String? interstitialAdUnitIdForiOS;
  String? rewardInterstitlAdUnitIdForAndroid;
  String? rewardInterstitialAdUnitIdForiOS;
  String? bannerAdUnitIdForAndroid;
  String? bannerAdUnitIdForiOS;
  String? fbInterstitialAdUnitIdForAndroid;
  String? fbInterstitialAdUnitIdForiOS;
  String? fbRewardInterstitialAdUnitIdForAndroid;
  String? fbRewardInterstitialAdUnitIdForiOS;
  String? networkToUse;
  String? stripePublishableKey;

  int minWithdrawLimit;
  int minCoinsWithdrawLimit;
  double coinsValue;
  double serviceFee;

  String? pid;

  bool enableImagePost;
  bool enableVideoPost;
  bool enableStories;
  bool enableHighlights;
  bool enableChat;
  bool enableLocationSharingInChat;
  bool enablePhotoSharingInChat;
  bool enableVideoSharingInChat;
  bool enableAudioSharingInChat;
  bool enableFileSharingInChat;
  bool enableGifSharingInChat;
  bool enableDrawingSharingInChat;
  bool enableClubSharingInChat;
  bool enableProfileSharingInChat;
  bool enableReplyInChat;
  bool enableForwardingInChat;
  bool enableStarMessage;
  bool enableAudioCalling;
  bool enableVideoCalling;
  bool enableLive;
  bool enableClubs;
  bool enableCompetitions;
  bool enableEvents;
  bool enableStrangerChat;
  bool enableProfileVerification;
  bool enableDarkLightModeSwitch;
  bool enableWatchTv;
  bool enablePodcasts;

  // nee to add
  bool enableReel;

  SettingModel({
    required this.email,
    required this.phone,
    required this.facebook,
    required this.youtube,
    required this.twitter,
    required this.linkedin,
    required this.pinterest,
    required this.instagram,
    required this.watchVideoRewardCoins,
    required this.latestVersion,
    required this.minWithdrawLimit,
    required this.minCoinsWithdrawLimit,
    required this.coinsValue,
    this.pid,
    required this.siteName,
    required this.inAppPurchaseId,
    required this.isUploadImage,
    required this.isUploadVideo,
    required this.uploadMaxFile,
    required this.siteUrl,
    required this.maximumVideoDurationAllowed,
    required this.freeLiveTvDurationToView,
    required this.latestAppDownloadLink,
    required this.disclaimerUrl,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.giphyApiKey,
    // required this.agoraApiKey,
    // required this.googleMapApiKey,
    required this.interstitialAdUnitIdForAndroid,
    required this.interstitialAdUnitIdForiOS,
    required this.rewardInterstitlAdUnitIdForAndroid,
    required this.rewardInterstitialAdUnitIdForiOS,
    required this.bannerAdUnitIdForAndroid,
    required this.bannerAdUnitIdForiOS,
    required this.fbInterstitialAdUnitIdForAndroid,
    required this.fbInterstitialAdUnitIdForiOS,
    required this.fbRewardInterstitialAdUnitIdForAndroid,
    required this.fbRewardInterstitialAdUnitIdForiOS,
    required this.networkToUse,
    required this.serviceFee,
    required this.stripePublishableKey,
    required this.enableImagePost,
    required this.enableVideoPost,
    required this.enableStories,
    required this.enableHighlights,
    required this.enableChat,
    required this.enableLocationSharingInChat,
    required this.enablePhotoSharingInChat,
    required this.enableVideoSharingInChat,
    required this.enableAudioSharingInChat,
    required this.enableFileSharingInChat,
    required this.enableGifSharingInChat,
    required this.enableDrawingSharingInChat,
    required this.enableClubSharingInChat,
    required this.enableProfileSharingInChat,
    required this.enableReplyInChat,
    required this.enableForwardingInChat,
    required this.enableStarMessage,
    required this.enableAudioCalling,
    required this.enableVideoCalling,
    required this.enableLive,
    required this.enableClubs,
    required this.enableCompetitions,
    required this.enableEvents,
    required this.enableStrangerChat,
    required this.enableProfileVerification,
    required this.enableDarkLightModeSwitch,
    required this.enableWatchTv,
    required this.enablePodcasts,
    required this.enableReel,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        email: json["email"],
        phone: json["phone"],
        facebook: json["facebook"],
        youtube: json["youtube"],
        twitter: json["twitter"],
        linkedin: json["linkedin"],
        pinterest: json["pinterest"],
        instagram: json["instagram"],
        latestVersion: json["release_version"],
        watchVideoRewardCoins: json["each_view_coin"] ?? 0,
        minWithdrawLimit: json["min_widhdraw_price"] ?? 0,
        minCoinsWithdrawLimit: json["min_coin_redeem"] ?? 0,
        coinsValue: double.parse(json["per_coin_value"].toString()),
        pid: json["user_p_id"],

        siteName: json["site_name"],
        inAppPurchaseId: json["in_app_purchase_id"],
        isUploadImage: json["is_upload_image"],
        isUploadVideo: json["is_upload_video"],
        uploadMaxFile: json["upload_max_file"],
        siteUrl: json["site_url"],
        maximumVideoDurationAllowed: json["maximum_video_duration_allowed"],
        freeLiveTvDurationToView: json["free_live_tv_duration_to_view"],
        latestAppDownloadLink: json["latest_app_download_link"],
        disclaimerUrl: json["disclaimer_url"],
        privacyPolicyUrl: json["privacy_policy_url"],
        termsOfServiceUrl: json["terms_of_service_url"],
        giphyApiKey: json["giphy_api_key"],
        // agoraApiKey: json["agora_api_key"],
        // googleMapApiKey: json["google_map_api_key"],
        interstitialAdUnitIdForAndroid:
            json["interstitial_ad_unit_id_for_android"],
        interstitialAdUnitIdForiOS: json["interstitial_ad_unit_id_for_IOS"],
        rewardInterstitlAdUnitIdForAndroid:
            json["reward_Interstitl_ad_unit_id_for_android"],
        rewardInterstitialAdUnitIdForiOS:
            json["reward_interstitial_ad_unit_id_for_IOS"],
        bannerAdUnitIdForAndroid: json["banner_ad_unit_id_for_android"],
        bannerAdUnitIdForiOS: json["banner_ad_unit_id_for_IOS"],
        fbInterstitialAdUnitIdForAndroid:
            json["fb_interstitial_ad_unit_id_for_android"],
        fbInterstitialAdUnitIdForiOS:
            json["fb_interstitial_ad_unit_id_for_IOS"],
        fbRewardInterstitialAdUnitIdForAndroid:
            json["fb_reward_interstitial_ad_unit_id_for_android"],
        fbRewardInterstitialAdUnitIdForiOS:
            json["fb_reward_interstitial_ad_unit_id_for_IOS"],
        networkToUse: json["network_to_use"],
        serviceFee: json["serviceFee"] ?? 5,
        stripePublishableKey: json["stripe_publishable_key"],

        enableChat: json["enableChat"] == 1,
        enableAudioCalling: json["enableAudioCalling"] == 1,
        enableAudioSharingInChat: json["enableAudioSharingInChat"] == 1,
        enableClubs: json["enableClubs"] == 1,
        enableClubSharingInChat: json["enableClubSharingInChat"] == 1,
        enableCompetitions: json["enableCompetitions"] == 1,
        enableDarkLightModeSwitch: json["enableDarkLightModeSwitch"] == 1,
        enableDrawingSharingInChat: json["enableDrawingSharingInChat"] == 1,
        enableEvents: json["enableEvents"] == 1,
        enableStrangerChat: json["enableStrangerChat"] == 1,
        enableFileSharingInChat: json["enableFileSharingInChat"] == 1,
        enableForwardingInChat: json["enableForwardingInChat"] == 1,
        enableGifSharingInChat: json["enableGifSharingInChat"] == 1,
        enableHighlights: json["enableHighlights"] == 1,
        enableImagePost: json["enableImagePost"] == 1,
        enableLive: json["enableLive"] == 1,
        enableLocationSharingInChat: json["enableLocationSharingInChat"] == 1,
        enablePhotoSharingInChat: json["enablePhotoSharingInChat"] == 1,
        enablePodcasts: json["enablePodcasts"] == 1,
        enableProfileSharingInChat: json["enableProfileSharingInChat"] == 1,
        enableProfileVerification: json["enableProfileVerification"] == 1,
        enableReplyInChat: json["enableReplyInChat"] == 1,
        enableStarMessage: json["enableStarMessage"] == 1,
        enableStories: json["enableStories"] == 1,
        enableVideoCalling: json["enableVideoCalling"] == 1,
        enableVideoPost: json["enableVideoPost"] == 1,
        enableVideoSharingInChat: json["enableVideoSharingInChat"] == 1,
        enableWatchTv: json["enableWatchTv"] == 1,
        enableReel: json["enableReel"] != 1,
      );
}
