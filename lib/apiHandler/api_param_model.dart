import 'dart:io';

import 'package:foap/util/shared_prefs.dart';

class ApiParamModel {
  dynamic getLoginParam(String email, String password) async {
    String? fcmToken = await SharedPrefs().getFCMToken();
    String? voipToken = await SharedPrefs().getVoipToken();

    return {
      "email": email,
      "password": password,
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": fcmToken ?? '',
      "device_token_voip_ios": voipToken ?? ''
    };
  }

  dynamic getUpdateTokenParam() async {
    String? fcmToken = await SharedPrefs().getFCMToken();
    String? voipToken = await SharedPrefs().getVoipToken();

    return {
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": fcmToken ?? '',
      "device_token_voip_ios": voipToken ?? ''
    };
  }

  dynamic getSocialLoginParam(
      String name, String socialType, String socialId, String email) async {
    String? fcmToken = await SharedPrefs().getFCMToken();
    String? voipToken = await SharedPrefs().getVoipToken();

    return {
      "name": name,
      "username": "",
      "social_type": socialType,
      "social_id": socialId,
      "email": email,
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": fcmToken ?? '',
      "device_token_voip_ios": voipToken ?? ''
    };
  }

  dynamic getSignUpParam(String name, String email, String password) async {
    String? fcmToken = await SharedPrefs().getFCMToken();
    String? voipToken = await SharedPrefs().getVoipToken();
    return {
      "username": name,
      "name": name,
      "email": email,
      "password": password,
      "device_type": Platform.isAndroid ? '1' : '2',
      "device_token": fcmToken ?? '',
      "device_token_voip_ios": voipToken ?? ''
    };
  }

  dynamic getForgotPwdParam(
      String email, String countyCode, String phoneNumber) {
    return {
      "verification_with": '1',
      "email": email,
      "country_code": countyCode,
      "phone": phoneNumber
    };
  }

  dynamic getResetPwdParam(String token, String password) {
    return {
      "token": token,
      "password": password,
    };
  }

  dynamic getVerifyOTPParam(String token, String otp) {
    return {
      "otp": otp,
      "token": token,
    };
  }

  dynamic getVerifyChangePhoneOTPParam(String token, String otp) {
    return {
      "otp": otp,
      "verify_token": token,
    };
  }

  dynamic getCheckUsernameParam(String username) {
    return {
      "username": username,
    };
  }

  dynamic getResendOTPParam(String token) {
    return {
      "token": token,
    };
  }

  dynamic getSupportRequestParam(
      String name, String email, String phone, String message) {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "request_message": message
    };
  }

  dynamic getNotificationSettingsParam(
      String likesNotificationStatus, String commentNotificationStatus) {
    return {
      "like_push_notification_status": likesNotificationStatus,
      "comment_push_notification_status": commentNotificationStatus
    };
  }

  dynamic createChatRoomParam(int opponentId) {
    return {"receiver_id": opponentId.toString(), "type": '1'};
  }
}
