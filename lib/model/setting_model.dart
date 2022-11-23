class SettingModel {
  String? email;
  String? phone;
  String? facebook;
  String? youtube;
  String? twitter;
  String? linkedin;
  String? pinterest;
  String? instagram;
  int watchVideoRewardCoins;
  String? latestVersion;

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
      );
}
