class AppConfigConstants {
  // Name of app
  static String appName = 'Socialified';
  static String currentVersion = '1.7';
  static const liveAppLink = 'https://www.google.com/';

  static String appTagline = 'Share your day activity with friends';
  static const googleMapApiKey = 'AIzaSyA4vcqErGvq5NRbvhvq8JKSp0VFpNBBPjE';

  // static const agoraApiKey = '52aa6d82f3f14aa3bd36b7a0fb6648f4';

  static const razorpayKey = 'rzp_test_jDl2SjSKYlghAD';

// static const restApiBaseUrl =
  //     'https://fwdtechnology.co/socialified/api/web/v1/';
  // static const restApiBaseUrl =
  //     'https://fwdtechnology.co/media_selling/api/web/v1/';
  static const restApiBaseUrl =
      'https://development.fwdtechnology.co/media_selling/api/web/v1/';

  // static const restApiBaseUrl =
  //     'https://fwdtechnology.co/media_selling/api/web/v1/';
  // Socket api url
  static const socketApiBaseUrl = 'http://fwdtechnology.co:3000/';

  // Socket api url
  static const encryptionKey = 'bbC2H19lkVbQDfakxcrtNMQdd0FloLyw';

  // chat version
  static const int enableEncryption = 1;

  // chat version
  static const int chatVersion = 1;

  // is demo app
  static const bool isDemoApp = true;

  // parameters for delete chat
  static const secondsInADay = 86400;
  static const secondsInThreeDays = 259200;
  static const secondsInSevenDays = 604800;
}

class DatingProfileConstants {
  static List<String> genders = ['Male', 'Female', 'Other'];
  static List<String> colors = ['Black', 'White', 'Brown'];
  static List<String> religions = [
    'Christians',
    'Muslims',
    'Hindus',
    'Buddhists',
    'Sikhs',
    'Jainism',
    'Judaism'
  ];
  static List<String> maritalStatus = ['Single', 'Married', 'Divorced'];
  static List<String> drinkHabits = ['Regular', 'Planning to quit', 'Socially'];
}
