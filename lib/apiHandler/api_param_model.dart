import 'package:foap/helper/common_import.dart';

import '../model/preference_model.dart';

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

  dynamic createGroupChatRoomParam(
      {required String groupName, String? groupDescription, String? image}) {
    return {
      "type": '2',
      'receiver_id': '',
      'title': groupName,
      'image': image ?? '',
      'description': groupDescription ?? ''
    };
  }

  dynamic updateGroupChatRoomParam(
      {String? groupName,
      String? groupDescription,
      String? image,
      String? groupAccess}) {
    Map<String, String> data = {};

    if (groupName != null) {
      data['title'] = groupName;
    }
    if (groupDescription != null) {
      data['description'] = groupDescription;
    }
    if (image != null) {
      data['image'] = image;
    }
    if (groupAccess != null) {
      data['chat_access_group'] = groupAccess;
    }
    return data;
  }

  dynamic createClubParam(
      {required int categoryId,
      required int privacyMode,
      required int isOnRequestType,
      required int enableChatRoom,
      required String name,
      required String image,
      required String description}) {
    return {
      "category_id": categoryId.toString(),
      'privacy_type': privacyMode.toString(),
      'is_request_based': isOnRequestType.toString(),
      'is_chat_room': enableChatRoom.toString(),
      'name': name,
      'image': image,
      'description': description
    };
  }

  dynamic updateClubParam(
      {required int categoryId,
      required int privacyMode,
      required String name,
      required String image,
      required String description}) {
    return {
      "category_id": categoryId.toString(),
      'privacy_type': privacyMode.toString(),
      'name': name,
      'image': image,
      'description': description
    };
  }

  dynamic sendClubInvite({
    required int clubId,
    required String userIds,
    required String message,
  }) {
    return {
      "club_id": clubId.toString(),
      'user_ids': userIds,
      'message': message,
    };
  }

  dynamic sendClubJoinRequest({
    required int clubId,
    required String message,
  }) {
    return {
      "club_id": clubId.toString(),
      'message': message,
    };
  }

  dynamic removeFromClub({
    required int userId,
    required int clubId,
  }) {
    return {
      "club_user_id": userId.toString(),
      'id': clubId.toString(),
    };
  }

  dynamic sendGiftParam(
      {required int giftId,
      required int receiverId,
      required int source,
      required int? liveId,
      required int? postId}) {
    //send_on_type : live call =1, profile=2, post=3
    return {
      "gift_id": giftId.toString(),
      'reciever_id': receiverId.toString(),
      'send_on_type': source.toString(),
      'live_call_id': liveId == null ? '' : liveId.toString(),
      'post_id': postId == null ? '' : postId.toString()
    };
  }

  dynamic getPollAnswerParam(
      int? pollId, int? pollQuestionId, int? questionOptionId) async {
    return {
      "poll_id": pollId.toString(),
      "poll_question_id": pollQuestionId.toString(),
      "question_option_id": questionOptionId.toString(),
    };
  }

  dynamic sendVerificationRequestParam({
    required String userMessage,
    required String documentType,
    required List<Map<String, String>> images,
  }) {
    return {
      "user_message": userMessage,
      'document': images,
      'document_type': documentType,
    };
  }

  dynamic cancelVerificationRequestParam({
    required int id,
    required String userMessage,
  }) {
    return {
      'user_message': userMessage,
      'id': id.toString(),
    };
  }

  dynamic paymentIntentParam({
    required double amount,
  }) {
    return {
      'amount': amount.toString(),
      'currency': 'USD',
    };
  }

  dynamic submitPaypalPaymentParam({
    required double amount,
    required String nonce,
    required String deviceData,
  }) {
    return {
      'amount': amount.toString(),
      'payment_method_nonce': nonce,
      'device_data': deviceData,
    };
  }

  dynamic addUserPreferenceParam() {
    AddPreferenceModel? preferenceModel =
        getIt<AddPreferenceManager>().preferenceModel;

    dynamic param = {
      'profile_category_type': '2',
      "work_experience_from": "2",
      "work_experience_to": "4",
    };
    if (preferenceModel?.languages != null) {
      param['language'] = preferenceModel?.languages;
    }
    if (preferenceModel?.religion != null) {
      param['religion'] = preferenceModel?.religion;
    }
    if (preferenceModel?.status != null) {
      param['marital_status'] = preferenceModel?.status.toString();
    }
    if (preferenceModel?.smoke != null) {
      param['smoke_id'] = preferenceModel?.smoke.toString();
    }
    if (preferenceModel?.drink != null) {
      param['drinking_habit'] = preferenceModel?.drink.toString();
    }
    if (preferenceModel?.interests != null) {
      param['interest'] = preferenceModel?.interests;
    }
    if (preferenceModel?.gender != null) {
      param['gander'] = preferenceModel?.gender.toString();
    }
    if (preferenceModel?.selectedColor != null) {
      param['color'] = preferenceModel?.selectedColor;
    }
    if (preferenceModel?.ageFrom != null) {
      param['age_from'] = preferenceModel?.ageFrom.toString();
    }
    if (preferenceModel?.ageTo != null) {
      param['age_to'] = preferenceModel?.ageTo.toString();
    }
    return param;
  }

  dynamic updateDatingProfileParam() {
    AddPreferenceModel? preferenceModel =
        getIt<AddPreferenceManager>().preferenceModel;
    dynamic param = {
      'profile_category_type': '2',
      "work_experience_month": "9",
    };
    if (preferenceModel?.languages != null) {
      param['language_id'] = preferenceModel?.languages;
    }
    if (preferenceModel?.religion != null) {
      param['religion'] = preferenceModel?.religion;
    }
    if (preferenceModel?.status != null) {
      param['marital_status'] = preferenceModel?.status.toString();
    }
    if (preferenceModel?.smoke != null) {
      param['smoke_id'] = preferenceModel?.smoke.toString();
    }
    if (preferenceModel?.drink != null) {
      param['drinking_habit'] = preferenceModel?.drink.toString();
    }
    if (preferenceModel?.interests != null) {
      param['interest_id'] = preferenceModel?.interests;
    }
    if (preferenceModel?.gender != null) {
      param['sex'] = preferenceModel?.gender.toString();
    }
    if (preferenceModel?.selectedColor != null) {
      param['color'] = preferenceModel?.selectedColor;
    }
    if (preferenceModel?.dob != null) {
      param['dob'] = preferenceModel?.dob;
    }
    if (preferenceModel?.height != null) {
      param['height'] = preferenceModel?.height.toString();
    }
    if (preferenceModel?.qualification != null) {
      param['qualification'] = preferenceModel?.qualification;
    }
    if (preferenceModel?.occupation != null) {
      param['occupation'] = preferenceModel?.occupation;
    }
    if (preferenceModel?.experience != null) {
      param['work_experience_year'] = preferenceModel?.experience;
    }
    return param;
    // "username":"username2",
    // "email":"user42@gmail.com",
    // "bio":"dio info",
    // "description":"hello msyfsjf",
    // "is_biometric_login":"1",

    // "country":"india",
    // "city":"mohali",
    // "state":"Punjab",
    // "state_id":"23",
    // "city_id":"2"
  }
}
