class InstagramConstant {
  static InstagramConstant? _instance;
  static InstagramConstant get instance {
    _instance ??= InstagramConstant._init();
    return _instance!;
  }

  InstagramConstant._init();

  static const String clientID = '1166260627246371';
  static const String appSecret = '7f618021866d0bb38b55554e2b8124b2';
  static const String redirectUri = 'https://www.phozio.com/auth';
  static const String scope = 'user_profile';
  static const String responseType = 'code';
  final String url =
      'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';
}