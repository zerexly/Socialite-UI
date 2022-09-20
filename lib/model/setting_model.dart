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
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      SettingModel(
        email: json["email"] ,
        phone: json["phone"] ,
        facebook: json["facebook"] ,
        youtube: json["youtube"] ,
        twitter: json["twitter"] ,
        linkedin: json["linkedin"] ,
        pinterest: json["pinterest"] ,
        instagram: json["instagram"] ,
        watchVideoRewardCoins: json["each_view_coin"] ?? 0,
      );

}
