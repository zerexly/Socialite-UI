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
  String? agoraApiKey;
  String? googleMapApiKey;
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

  int minWithdrawLimit;
  int minCoinsWithdrawLimit;
  double coinsValue;

  String? pid;

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
    required this.agoraApiKey,
    required this.googleMapApiKey,
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
    agoraApiKey: json["agora_api_key"],
    googleMapApiKey: json["google_map_api_key"],
    interstitialAdUnitIdForAndroid: json["interstitial_ad_unit_id_for_android"],
    interstitialAdUnitIdForiOS: json["interstitial_ad_unit_id_for_IOS"],
    rewardInterstitlAdUnitIdForAndroid: json["reward_Interstitl_ad_unit_id_for_android"],
    rewardInterstitialAdUnitIdForiOS: json["reward_interstitial_ad_unit_id_for_IOS"],
    bannerAdUnitIdForAndroid: json["banner_ad_unit_id_for_android"],
    bannerAdUnitIdForiOS: json["banner_ad_unit_id_for_IOS"],
    fbInterstitialAdUnitIdForAndroid: json["fb_interstitial_ad_unit_id_for_android"],
    fbInterstitialAdUnitIdForiOS: json["fb_interstitial_ad_unit_id_for_IOS"],
    fbRewardInterstitialAdUnitIdForAndroid: json["fb_reward_interstitial_ad_unit_id_for_android"],
    fbRewardInterstitialAdUnitIdForiOS: json["fb_reward_interstitial_ad_unit_id_for_IOS"],
    networkToUse: json["network_to_use"],

  );
}

