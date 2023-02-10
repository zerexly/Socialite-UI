import 'dart:convert';
import 'dart:developer';
import 'package:foap/helper/common_import.dart';
import 'package:http/http.dart' as http;
import 'package:foap/apiHandler/api_param_model.dart';
import 'package:http_parser/http_parser.dart';

import '../controllers/dating_controller.dart';
import '../model/live_tv_model.dart';
import '../model/preference_model.dart';

class ApiController {
  final JsonDecoder _decoder = const JsonDecoder();

  Future<ApiResponseModel> login(String email, String password) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.login;
    dynamic param = await ApiParamModel().getLoginParam(email, password);

    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.login);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> socialLogin(
      String name, String socialType, String socialId, String email) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.socialLogin;
    dynamic param = await ApiParamModel()
        .getSocialLoginParam(name, socialType, socialId, email);

    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.socialLogin);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> registerUser(
      String name, String email, String password) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.register;
    dynamic param = await ApiParamModel().getSignUpParam(name, email, password);

    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.register);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deleteAccountApi() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.deleteAccount;

    return await http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer $authKey"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.deleteAccount);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateTokens() async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updatedDeviceToken;

    dynamic param = await ApiParamModel().getUpdateTokenParam();
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.login);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> checkUsername(String username) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.checkUserName;
    dynamic param = ApiParamModel().getCheckUsernameParam(username);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.checkUserName);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> forgotPassword(String emailOrPhone) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.forgotPassword;

    dynamic param = ApiParamModel().getForgotPwdParam(emailOrPhone, '', '');

    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.forgotPassword);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> resetPassword(String password, String token) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.resetPassword;
    dynamic param = ApiParamModel().getResetPwdParam(token, password);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.resetPassword);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> resendOTP(String token) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.resendOTP;

    dynamic param = ApiParamModel().getResendOTPParam(token);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.resendOTP);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> verifyOTP(
      bool isRegistration, String otp, String token) async {
    var url = NetworkConstantsUtil.baseUrl +
        (isRegistration == true
            ? NetworkConstantsUtil.verifyRegistrationOTP
            : NetworkConstantsUtil.verifyFwdPWDOTP);

    dynamic param = ApiParamModel().getVerifyOTPParam(token, otp);
    return http
        .post(Uri.parse(url), body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.verifyFwdPWDOTP);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> verifyChangePhoneOTP(
      String otp, String token) async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.verifyChangePhoneOTP;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    dynamic param = ApiParamModel().getVerifyChangePhoneOTPParam(token, otp);
    return http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.verifyChangePhoneOTP);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPolls() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getPolls;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getPolls);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> postPollAnswer(
      int? pollId, int? pollQuestionId, int? questionOptionId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.postPoll;
    dynamic param = await ApiParamModel()
        .getPollAnswerParam(pollId, pollQuestionId, questionOptionId);

    return await http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.postPoll);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPosts(
      {int? userId,
      int? isPopular,
      int? isFollowing,
      int? clubId,
      int? isSold,
      int? isReel,
      int? audioId,
      int? isMine,
      int? isRecent,
      String? title,
      String? hashtag,
      int page = 0}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.searchPost;
    if (userId != null) {
      url = '$url&user_id=$userId';
    }
    if (isPopular != null) {
      url = '$url&is_popular_post=$isPopular';
    }
    if (title != null) {
      url = '$url&title=$title';
    }
    if (isRecent != null) {
      url = '$url&is_recent=$isRecent';
    }
    if (isFollowing != null) {
      url = '$url&is_following_user_post=$isFollowing';
    }
    if (isMine != null) {
      url = '$url&is_my_post=$isMine';
    }
    if (isSold != null) {
      url = '$url&is_winning_post=$isSold';
    }
    if (hashtag != null) {
      url = '$url&hashtag=$hashtag';
    }
    if (clubId != null) {
      url = '$url&club_id=$clubId';
    }
    if (isReel != null) {
      url = '$url&is_reel=$isReel';
    }
    if (audioId != null) {
      url = '$url&audio_id=$audioId';
    }
    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.searchPost);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPostDetail(int id) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.postDetail;
    url = url.replaceAll('{id}', id.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.postDetail);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getMyMentions(
      {required int userId, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.mentionedPosts}$userId&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.mentionedPosts);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> postStory({
    required List<Map<String, String>> gallery,
  }) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri =
        Uri.parse(NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.addStory);

    var parameters = {
      "stories": gallery,
    };

    return http
        .post(postUri,
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(parameters))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.addStory);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getMyStories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.myStories;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.myStories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> createHighlight({
    required String name,
    required String image,
    required String stories,
  }) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri = Uri.parse(
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.addHighlight);

    var parameters = {
      "name": name,
      "image": image,
      "story_ids": stories,
    };

    return http
        .post(postUri,
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(parameters))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.addHighlight);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deleteStoryFromHighlights({
    required int id,
  }) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri = Uri.parse(NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.removeStoryFromHighlight);

    var parameters = {
      "id": id.toString(),
    };

    return http
        .post(postUri,
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(parameters))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.addHighlight);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deleteStory({
    required int id,
  }) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri = Uri.parse(NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.deleteStory +
        id.toString());

    return http.delete(
      postUri,
      headers: {
        "Authorization": "Bearer ${authKey!}",
        'Content-Type': 'application/json',
      },
    ).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.deleteStory);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> addStoryToHighlights({
    required int collectionId,
    required int postId,
  }) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri = Uri.parse(NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.addStoryToHighlight);

    var parameters = {
      "collection_id": collectionId.toString(),
      "post_id": postId.toString(),
    };

    return http
        .post(postUri,
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(parameters))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.addHighlight);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getHighlights({required int userId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.highlights +
        userId.toString();

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.highlights);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> likeUnlike(bool like, int postId) async {
    var url = NetworkConstantsUtil.baseUrl +
        (like
            ? NetworkConstantsUtil.likePost
            : NetworkConstantsUtil.unlikePost);
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "post_id": postId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body,
          like
              ? NetworkConstantsUtil.likePost
              : NetworkConstantsUtil.unlikePost);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getComments(int postId) async {
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.getComments}?expand=user&post_id=$postId';
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getComments);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getSuggestedUsers({required int page}) async {
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.getSuggestedUsers}&page=$page';

    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getSuggestedUsers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> postComments(int postId, String comment) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.addComment;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "post_id": postId.toString(),
      'comment': comment
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.addComment);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> reportPost(int postId) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.reportPost;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "post_id": postId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.reportPost);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deletePost(int postId) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.deletePost;
    url = url.replaceAll('{{id}}', postId.toString());
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.delete(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.deletePost);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getOtherUser(String userId) async {
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.otherUser}';
    String? authKey = await SharedPrefs().getAuthorizationKey();
    url = url.replaceFirst('{{id}}', userId.toString());

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.otherUser);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getMyProfile() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getMyProfile;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getMyProfile);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateUserName(String userName) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateUserProfile;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "username": userName,
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.updateUserProfile);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateBiometricSetting(int setting) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateUserProfile;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "is_biometric_login": setting.toString(),
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.updateUserProfile);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> changePassword(
      String oldPassword, String newPassword) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updatePassword;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "old_password": oldPassword,
      "password": newPassword
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.updatePassword);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> changePhone(String countryCode, String phone) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updatePhone;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "country_code": countryCode,
      "phone": phone
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.updatePhone);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateUserProfile(UserModel user) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateUserProfile;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      // "name": user.name,
      // "bio": user.bio,
      // "country_code": 'user.countryCode',
      // "phone": user.phone,
      "country": user.country,
      "city": user.city,
      // "sex": user.gender,
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.updateUserProfile);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateUserLocation(LatLng location) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateLocation;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    var data = {
      'latitude': location.latitude!.toString(),
      'longitude': location.longitude!.toString(),
      'location': ''
    };

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: data)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.updateLocation);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> stopSharingUserLocation() async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateLocation;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    var data = {'latitude': '', 'longitude': '', 'location': ''};

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: data)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.updateLocation);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateProfileImage(Uint8List imageFileData) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri = Uri.parse(
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateProfileImage);
    var request = http.MultipartRequest("POST", postUri);
    request.headers.addAll({"Authorization": "Bearer ${authKey!}"});

    request.files.add(http.MultipartFile.fromBytes('imageFile', imageFileData,
        filename: '${DateTime.now().toIso8601String()}.jpg',
        contentType: MediaType('image', 'jpg')));

    return request.send().then((response) async {
      final respStr = await response.stream.bytesToString();
      final ApiResponseModel parsedResponse =
          await getResponse(respStr, NetworkConstantsUtil.updateProfileImage);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> followUnFollowUser(
      bool isFollowing, int userId) async {
    var url = NetworkConstantsUtil.baseUrl +
        (isFollowing
            ? NetworkConstantsUtil.followUser
            : NetworkConstantsUtil.unfollowUser);
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "user_id": userId.toString(),
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body,
          isFollowing
              ? NetworkConstantsUtil.followUser
              : NetworkConstantsUtil.unfollowUser);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getStories() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.stories;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.stories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getCurrentActiveStories() async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.myCurrentActiveStories;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.myCurrentActiveStories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> followMultiple(String userIds) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.followMultipleUser;

    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "user_ids": userIds,
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.followMultipleUser);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> reportUser(int userId) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.reportUser;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "report_to_user_id": userId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.reportUser);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> blockUser(int userId) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.blockUser;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "blocked_user_id": userId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.blockUser);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> unBlockUser(int userId) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.unBlockUser;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "blocked_user_id": userId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.unBlockUser);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getBlockedUsersList({required int page}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.blockedUsers}&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.blockedUsers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> addPost(
      {required int postType,
      required String title,
      required List<Map<String, String>> gallery,
      String? hashTag,
      String? mentions,
      int? competitionId,
      int? clubId,
      int? audioId,
      double? audioStartTime,
      double? audioEndTime,
      bool? addToPost}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var postUri = Uri.parse(NetworkConstantsUtil.baseUrl +
        (competitionId == null
            ? NetworkConstantsUtil.addPost
            : NetworkConstantsUtil.addCompetitionPost));

    var parameters = {
      "type": postType.toString(),
      "title": title,
      "hashtag": hashTag,
      "mentionUser": mentions,
      "gallary": gallery,
      'competition_id': competitionId,
      'club_id': clubId,
      'post_content_type': 2,
      'audio_id': audioId,
      'audio_start_time': audioStartTime,
      'audio_end_time': audioEndTime,
      'is_add_to_post': addToPost == true ? 1 : 0
    };

    log('parameters $parameters');

    return http
        .post(postUri,
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(parameters))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body,
          competitionId == null
              ? NetworkConstantsUtil.addPost
              : NetworkConstantsUtil.addCompetitionPost);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> uploadPostMedia(String file) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.uploadPostImage;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    String? authKey = await SharedPrefs().getAuthorizationKey();
    request.headers.addAll({"Authorization": "Bearer ${authKey!}"});
    request.files.add(await http.MultipartFile.fromPath('filenameFile', file));
    var res = await request.send();
    var responseData = await res.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    final ApiResponseModel parsedResponse =
        await getResponse(responseString, NetworkConstantsUtil.uploadPostImage);

    return parsedResponse;
  }

  Future<ApiResponseModel> uploadFile(
      {required String file, required UploadMediaType type}) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.uploadFileImage;
    var request = http.MultipartRequest('POST', Uri.parse(url));
    String? authKey = await SharedPrefs().getAuthorizationKey();
    request.headers.addAll({"Authorization": "Bearer ${authKey!}"});
    request.fields.addAll({'type': uploadMediaTypeId(type).toString()});
    request.files.add(await http.MultipartFile.fromPath('mediaFile', file));
    var res = await request.send();
    var responseData = await res.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    final ApiResponseModel parsedResponse =
        await getResponse(responseString, NetworkConstantsUtil.uploadFileImage);

    return parsedResponse;
  }

  Future<ApiResponseModel> getCompetitions() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getCompetitions;

    // print(url);
    // print("Bearer ${authKey!}");

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getCompetitions);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getCompetitionsDetail(int id) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.getCompetitionDetail;

    url = url.replaceFirst('{{id}}', id.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getCompetitionDetail);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> joinCompetition(int competitionId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.joinCompetition;

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "competition_id": competitionId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.joinCompetition);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPopularUsers() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.searchUsers;
    var params = {
      "name": "",
      "is_popular_user": "1",
      "is_following_user": "0",
      "is_follower_user": "0"
    };

    return await http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: params)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getArrayResponse(
          response.body, NetworkConstantsUtil.searchUsers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getAllPackages() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getPackages;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getPackages);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> subscribePackage(
      String packageId, String transactionId, String amount) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.subscribePackage;

    return await http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      "package_id": packageId,
      "transaction_id": transactionId,
      "amount": amount
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.subscribePackage);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updatePaymentDetails(String paypalId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updatePaymentDetail;
    var params = {"paypal_id": paypalId};

    return await http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: params)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.updatePaymentDetail);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getWithdrawHistory() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.withdrawHistory;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.withdrawHistory);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> performWithdrawalRequest() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.withdrawalRequest;

    return await http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.withdrawalRequest);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> redeemCoinsRequest(int coins) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.redeemCoins;

    var params = {"redeem_coin": coins.toString()};

    return await http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: params)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.redeemCoins);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> rewardCoins() async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.rewardedAdCoins;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.rewardedAdCoins);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getFollowerUsers({int? userId, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.followers}${userId ?? getIt<UserProfileManager>().user!.id}&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.followers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getFollowingUsers(
      {int? userId, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.following}${userId ?? getIt<UserProfileManager>().user!.id}&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.following);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getNotifications() async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getNotifications;

    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getNotifications);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getSettings() async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getSettings;

    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getSettings);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> findFriends(
      {required int isExactMatch,
      required String searchText,
      SearchFrom? searchFrom,
      int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.findFriends;

    //searchFrom  ----- 1=username,2=email,3=phone

    String searchFromValue = searchFrom == null
        ? ''
        : searchFrom == SearchFrom.username
            ? '1'
            : searchFrom == SearchFrom.email
                ? '2'
                : '3';
    url =
        '${url}searchText=$searchText&searchFrom=$searchFromValue&isExactMatch=$isExactMatch&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getArrayResponse(
          response.body, NetworkConstantsUtil.findFriends);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> sendSupportRequest(
      String name, String email, String phone, String message) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();

    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.submitRequest;
    dynamic param =
        ApiParamModel().getSupportRequestParam(name, email, phone, message);
    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.submitRequest);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateNotificationSettings({
    required String likesNotificationStatus,
    required String commentNotificationStatus,
  }) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();

    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.notificationSettings;
    dynamic param = ApiParamModel().getNotificationSettingsParam(
        likesNotificationStatus, commentNotificationStatus);
    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.notificationSettings);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getSupportMessages() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.supportRequests;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.supportRequests);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> searchHashtag(
      {required String hashtag, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.searchHashtag}$hashtag&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.searchUsers);
      return parsedResponse;
    });
  }

  //****************************** Chat **************************//

  Future<ApiResponseModel> createChatRoom(int opponentId) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.createChatRoom;
    dynamic param = await ApiParamModel().createChatRoomParam(opponentId);
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.createChatRoom);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> createGroupChatRoom(
      String title, String? image, String? description) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.createChatRoom;
    dynamic param = await ApiParamModel().createGroupChatRoomParam(
        groupName: title, image: image, groupDescription: description);
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.createChatRoom);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateGroupChatRoom(int groupId, String title,
      String? image, String? description, String? groupAccess) async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.updateGroupChatRoom +
        groupId.toString();
    dynamic param = await ApiParamModel().updateGroupChatRoomParam(
        groupName: title,
        image: image,
        groupDescription: description,
        groupAccess: groupAccess);
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.createChatRoom);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deleteChatRoom(int roomId) async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.deleteChatRoom +
        roomId.toString();
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.createChatRoom);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deleteChatRoomMessages(int roomId) async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.deleteChatRoomMessages +
        roomId.toString();
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}",
    }, body: {
      'room_id': roomId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.deleteChatRoomMessages);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getChatRooms() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getChatRooms;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getChatRooms);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getChatRoomDetail(int roomId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getChatRoomDetail;
    url = url.replaceAll('{room_id}', roomId.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getChatRoomDetail);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getChatHistory(
      {required int roomId, required int lastMessageId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.chatHistory;
    url = url
        .replaceAll('{{room_id}}', roomId.toString())
        .replaceAll('{{last_message_id}}', lastMessageId.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.chatHistory);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getCallHistory({required int page}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.callHistory}&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.callHistory);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getRandomOnlineUsers() async {
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.randomOnlineUser}';
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.randomOnlineUser);
      return parsedResponse;
    });
  }

  //****************************** Live Tvs **************************//

  Future<ApiResponseModel> getTVCategories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getTVCategories;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getTVCategories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTVShows({int? liveTvId, String? name}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getTVShows;

    if (liveTvId != null) {
      url = '$url&tv_channel_id=$liveTvId';
    }
    if (name != null) {
      url = '$url&name=$name';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getTVShows);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTVShowById({int? showId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getTVShowById;

    if (showId != null) {
      url = '$url&id=$showId';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getTVShowById);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTVShowEpisodes(
      {int? showId, String? name}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getTVShowEpisodes;

    if (showId != null) {
      url = '$url&tv_show_id=$showId';
    }
    if (name != null) {
      url = '$url&name=$name';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getTVShowEpisodes);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTvCategories(int id) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.postDetail;
    url = url.replaceAll('{id}', id.toString());
    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.postDetail);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTvs(
      {int? categoryId, String? name, bool? isLive}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.liveTvs;

    if (categoryId != null) {
      url = '$url&category_id=$categoryId';
    }
    if (name != null) {
      url = '$url&name=$name';
    }
    if (isLive != null) {
      url = '$url&is_live=${isLive == true ? 1 : 0}';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.liveTvs);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTVChannelById({required int tvId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.getTVChannel
            .replaceAll('{{channel_id}}', tvId.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getTVChannel);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> likeUnlikeTv(bool like, int tvId) async {
    var url = NetworkConstantsUtil.baseUrl +
        (like ? NetworkConstantsUtil.favTv : NetworkConstantsUtil.unfavTv);
    String? authKey = await SharedPrefs().getAuthorizationKey();

    print(url);
    return http.post(Uri.parse(url),
        headers: {"Authorization": "Bearer ${authKey!}"},
        body: {"id": tvId.toString()}).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body,
          like
              ? NetworkConstantsUtil.likePost
              : NetworkConstantsUtil.unlikePost);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getFavLiveTvs() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.favTvList;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.favTvList);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getSubscribedLiveTvs() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.subscribedTvList;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.subscribedTvList);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getTvBanners() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.tvBanners;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.tvBanners);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> subscribeTv({
    required TvModel tvModel,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.subscribeLiveTv;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      'id': tvModel.id.toString(),
      'transaction_id': ''
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.subscribeLiveTv);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> stopWatchingTv({
    required TvModel tvModel,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.stopWatchingTv;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      'id': tvModel.id.toString(),
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.stopWatchingTv);
      return parsedResponse;
    });
  }

  //****************************** Podcast **************************//

  Future<ApiResponseModel> getPodcastBanners() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.podcastBanners;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.podcastBanners);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPodcastCategories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.getPodcastCategories;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getPodcastCategories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPodcastList(
      {int? categoryId, String? name}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getHosts;

    if (categoryId != null) {
      url = '$url&category_id=$categoryId';
    }
    if (name != null) {
      url = '$url&name=$name';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getHosts);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPodcastShows(
      {int? podcastId, String? name}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getPodcastShows;

    if (podcastId != null) {
      url = '$url&podcast_channel_id=$podcastId';
    }
    if (name != null) {
      url = '$url&name=$name';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getPodcastShows);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPodcastShowsEpisode(
      {int? podcastShowId, String? name}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.getPodcastShowsEpisode;

    if (podcastShowId != null) {
      url = '$url&podcast_show_id=$podcastShowId';
    }
    if (name != null) {
      url = '$url&name=$name';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getPodcastShowsEpisode);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPodcastShowById({int? showId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getHostShowById;

    if (showId != null) {
      url = '$url&id=$showId';
    }
    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getPodcastHostDetail);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getInterests() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.interests;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.interests);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getPodcastHostById({required int hostId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.getPodcastHostDetail
            .replaceAll('{{host_id}}', hostId.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getPodcastHostDetail);
      return parsedResponse;
    });
  }

  //****************************** Clubs **************************//

  Future<ApiResponseModel> getClubCategories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getClubCategories;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getClubCategories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> createClub(
      {required int categoryId,
      required int privacyMode,
      required int isOnRequestType,
      required int enableChatRoom,
      required String name,
      required String image,
      required String description}) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.createClub;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    dynamic param = await ApiParamModel().createClubParam(
        categoryId: categoryId,
        privacyMode: privacyMode,
        isOnRequestType: isOnRequestType,
        enableChatRoom: enableChatRoom,
        name: name,
        image: image,
        description: description);

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.createClub);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateClub(
      {required int categoryId,
      required int clubId,
      required int privacyMode,
      required String name,
      required String image,
      required String description}) async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.updateClub +
        clubId.toString();
    String? authKey = await SharedPrefs().getAuthorizationKey();

    dynamic param = await ApiParamModel().updateClubParam(
        categoryId: categoryId,
        privacyMode: privacyMode,
        name: name,
        image: image,
        description: description);

    return http
        .put(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.updateClub);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> deleteClub(int clubId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.deleteClub +
        clubId.toString();

    return await http.delete(Uri.parse(url), headers: {
      "Authorization": "Bearer $authKey"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.deleteClub);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> sendClubInvite({
    required int clubId,
    required String userIds,
    required String message,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.sendClubInvite;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    dynamic param = await ApiParamModel().sendClubInvite(
      clubId: clubId,
      userIds: userIds,
      message: message,
    );

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.sendClubInvite);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getClubInvitations({int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.clubJoinInvites;
    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.clubJoinInvites);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> acceptDeclineClubInvitation(
      {required int invitationId, required int replyStatus}) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.replyOnInvitation;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      'id': invitationId.toString(),
      'status': replyStatus.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.replyOnInvitation);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> sendClubJoinRequest({
    required int clubId,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.sendClubJoinRequest;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    dynamic param = await ApiParamModel().sendClubJoinRequest(
      clubId: clubId,
      message: '',
    );

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.sendClubJoinRequest);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getClubJoinRequests(
      {required int clubId, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.clubJoinRequestList;
    url = url.replaceAll('{{club_id}}', clubId.toString());
    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.clubJoinRequestList);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> acceptDeclineClubJoinRequest(
      {required int requestId, required int replyStatus}) async {
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.clubJoinRequestReply;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      'id': requestId.toString(),
      'status': replyStatus.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.clubJoinRequestReply);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getClubs(
      {String? name,
      int? categoryId,
      int? userId,
      int? isJoined,
      int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();

    print('authKey $authKey');
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.searchClubs;
    if (userId != null) {
      url = '$url&user_id=$userId';
    }
    if (categoryId != null) {
      url = '$url&category_id=$categoryId';
    }
    if (name != null && name.isNotEmpty) {
      url = '$url&name=$name';
    }
    if (isJoined != null) {
      url = '$url&my_joined_club=$isJoined';
    }
    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.searchClubs);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getClubMembers({int? clubId, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.clubMembers +
        clubId.toString();
    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.clubMembers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> joinClub({
    required int clubId,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.joinClub;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url),
        headers: {"Authorization": "Bearer ${authKey!}"},
        body: {'id': clubId.toString()}).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.joinClub);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> leaveClub({
    required int clubId,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.leaveClub;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url),
        headers: {"Authorization": "Bearer ${authKey!}"},
        body: {'id': clubId.toString()}).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.leaveClub);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> removeMemberFromClub({
    required int clubId,
    required int userId,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.removeUserFromClub;
    String? authKey = await SharedPrefs().getAuthorizationKey();
    dynamic param =
        await ApiParamModel().removeFromClub(userId: userId, clubId: clubId);

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.removeUserFromClub);
      return parsedResponse;
    });
  }

  // ************************ Event ****************************** //

  Future<ApiResponseModel> getEventCategories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.eventsCategories;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.eventsCategories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getEvents(
      {String? name,
      int? categoryId,
      int? status,
      int? isJoined,
      int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.searchEvents;
    if (categoryId != null) {
      url = '$url&category_id=$categoryId';
    }
    if (status != null) {
      url = '$url&current_status=$status';
    }
    if (name != null && name.isNotEmpty) {
      url = '$url&name=$name';
    }

    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.searchEvents);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getEventDetail({required int eventId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.eventDetails;
    url = url.replaceAll('{{id}}', eventId.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.eventDetails);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getEventMembers({int? eventId, int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        NetworkConstantsUtil.eventMembers +
        eventId.toString();
    url = '$url&page=$page';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.clubMembers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getEventCoupons({required int eventId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.eventCoupons;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.eventCoupons);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> buyTicket({
    required EventTicketOrderRequest orderRequest,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.buyTicket;
    String? authKey = await SharedPrefs().getAuthorizationKey();
    dynamic param = orderRequest.toJson();

    return http
        .post(Uri.parse(url),
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(param))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.buyTicket);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getEventBookings(
      {String? name,
      required int currentStatus,
      int? status,
      int? isJoined,
      int page = 1}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.eventBookings;
    url = '$url&current_status=$currentStatus';

    if (name != null && name.isNotEmpty) {
      url = '$url&name=$name';
    }
    url =
        '$url&expand=payment,event,event.eventOrganisor,giftedToUser,giftedByUser';
    url = '$url&page=$page';

    // print("Bearer ${authKey!}");
    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.eventBookings);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> joinEvent({
    required int eventId,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.joinEvent;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url),
        headers: {"Authorization": "Bearer ${authKey!}"},
        body: {'id': eventId.toString()}).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.joinEvent);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> leaveEvent({
    required int eventId,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.leaveEvent;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url),
        headers: {"Authorization": "Bearer ${authKey!}"},
        body: {'id': eventId.toString()}).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.leaveClub);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> giftEventTicket({
    required int ticketId,
    required int toUserId,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.giftTicket;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      'id': ticketId.toString(),
      'gifted_to': toUserId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.giftTicket);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> createEventBooking({
    required int clubId,
  }) async {
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.eventBookings;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url),
        headers: {"Authorization": "Bearer ${authKey!}"},
        body: {'id': clubId.toString()}).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.eventBookings);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> cancelEventBooking({
    required int bookingId,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.cancelEventBooking;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.post(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }, body: {
      'id': bookingId.toString()
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.cancelEventBooking);
      return parsedResponse;
    });
  }

  // *********************** Live ******************************* //

  Future<ApiResponseModel> getCurrentLiveUsers() async {
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.currentLiveUsers}${getIt<UserProfileManager>().user!.id}';
    String? authKey = await SharedPrefs().getAuthorizationKey();

    // print(url);
    // print("Bearer ${authKey!}");

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.currentLiveUsers);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getRandomLiveUsers() async {
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.randomLives}';
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.randomLives);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getLiveHistory() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.liveHistory;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.liveHistory);
      return parsedResponse;
    });
  }

  // *********************** Gifts ******************************* //

  Future<ApiResponseModel> receivedGifts(
      {required int sendOnType,
      required int? postId,
      required int? liveId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.giftsReceived;
    url = url.replaceAll('{{send_on_type}}', sendOnType.toString());
    url = url.replaceAll(
        '{{live_call_id}}', liveId == null ? '' : liveId.toString());
    url =
        url.replaceAll('{{post_id}}', postId == null ? '' : postId.toString());

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.giftsReceived);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getGiftCategories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.giftsCategories;

    // print(url);
    // print("Bearer ${authKey!}");

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.giftsCategories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getGiftsByCategory(int categoryId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.giftsByCategory}$categoryId';

    // print(url);
    // print("Bearer ${authKey!}");

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.giftsByCategory);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getMostUsedGifts() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.mostUsedGifts}';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.mostUsedGifts);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> sendGift(
      {required GiftModel gift,
      required int? liveId,
      required int? postId,
      required int userId}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.sendGift}';

    dynamic param = await ApiParamModel().sendGiftParam(
        giftId: gift.id,
        receiverId: userId,
        liveId: liveId,
        postId: postId,
        source: liveId != null
            ? 1
            : postId != null
                ? 3
                : 2);

    return await http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.sendGift);
      return parsedResponse;
    });
  }

  //**************** profile verification ***************//

  Future<ApiResponseModel> sendProfileVerificationRequest(
      {required String userMessage,
      required String documentType,
      required List<Map<String, String>> images}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.requestVerification}';

    dynamic param = await ApiParamModel().sendVerificationRequestParam(
        userMessage: userMessage, images: images, documentType: documentType);

    return await http.post(Uri.parse(url), body: jsonEncode(param), headers: {
      "Authorization": "Bearer ${authKey!}",
      'Content-Type': 'application/json',
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.requestVerification);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> cancelProfileVerificationRequest(
      {required int id, required String userMessage}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.cancelVerification}';

    dynamic param = await ApiParamModel().cancelVerificationRequestParam(
      userMessage: userMessage,
      id: id,
    );

    return await http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.cancelVerification);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getVerificationRequestHistory() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.requestVerificationHistory}';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.requestVerificationHistory);
      return parsedResponse;
    });
  }

  ////// Created by Richa
  Future<ApiResponseModel> getFAQ() async {
    var url = '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.getFAQs}';
    String? authKey = await SharedPrefs().getAuthorizationKey();

    return http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getFAQs);
      return parsedResponse;
    });
  }

  //*********************** Stripe payment ************************//
  Future<ApiResponseModel> fetchPaymentIntentClientSecret(
      {required double amount}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.createPaymentIntent}';

    dynamic param = await ApiParamModel().paymentIntentParam(
      amount: amount,
    );

    return await http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.createPaymentIntent);
      return parsedResponse;
    });
  }

//*********************** Paypal payment ************************//
  Future<ApiResponseModel> fetchPaypalClientToken() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        '${NetworkConstantsUtil.baseUrl}${NetworkConstantsUtil.getPaypalClientToken}';

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getPaypalClientToken);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> sendPaypalPayment({
    required double amount,
    required String nonce,
    required String deviceData,
  }) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.submitPaypalPayment;
    String? authKey = await SharedPrefs().getAuthorizationKey();

    dynamic param = await ApiParamModel().submitPaypalPaymentParam(
        amount: amount, nonce: nonce, deviceData: deviceData);

    return http
        .post(Uri.parse(url),
            headers: {
              "Authorization": "Bearer ${authKey!}",
              'Content-Type': 'application/json',
            },
            body: jsonEncode(param))
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.submitPaypalPayment);
      return parsedResponse;
    });
  }

  /// **************** Reel *****************/
  Future<ApiResponseModel> getReelCategories() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.reelAudioCategories;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.reelAudioCategories);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getAudios({int? categoryId, String? title}) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.audios;
    if (categoryId != null) {
      url = '$url&category_id=$categoryId';
    }
    if (title != null) {
      url = '$url&name=$title';
    }

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.audios);
      return parsedResponse;
    });
  }

  //*********************** Dating ************************//
  Future<ApiResponseModel> addUserPreference(AddPreferenceModel selectedPreferences) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.addUserPreference;
    dynamic param = ApiParamModel().addUserPreferenceParam(selectedPreferences);

    return await http.post(Uri.parse(url), body: param, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.addUserPreference);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getUserPreferenceApi() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getUserPreference;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getUserPreference);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> updateDatingProfile(AddDatingDataModel dataModel) async {
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.updateUserProfile;
    String? authKey = await SharedPrefs().getAuthorizationKey();
    dynamic param = ApiParamModel().updateDatingProfileParam(dataModel);

    return http
        .post(Uri.parse(url),
            headers: {"Authorization": "Bearer ${authKey!}"}, body: param)
        .then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.updateUserProfile);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getDatingProfilesApi() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getDatingProfiles;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.getDatingProfiles);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> likeUnlikeDatingProfile(
      DatingActions action, String profileId) async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl +
        (action == DatingActions.liked
            ? NetworkConstantsUtil.profileLike
            : action == DatingActions.rejected
                ? NetworkConstantsUtil.profileSkip
                : NetworkConstantsUtil.undoProfileLike);

    return await http.post(Uri.parse(url), body: {
      'profile_user_id': profileId
    }, headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.addUserPreference);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getMatchedProfilesApi() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.matchedProfiles;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.matchedProfiles);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getLikeProfilesApi() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url =
        NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.likeProfiles;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse = await getResponse(
          response.body, NetworkConstantsUtil.likeProfiles);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getLanguages() async {
    String? authKey = await SharedPrefs().getAuthorizationKey();
    var url = NetworkConstantsUtil.baseUrl + NetworkConstantsUtil.getLanguages;

    return await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer ${authKey!}"
    }).then((http.Response response) async {
      final ApiResponseModel parsedResponse =
          await getResponse(response.body, NetworkConstantsUtil.getLanguages);
      return parsedResponse;
    });
  }

  Future<ApiResponseModel> getResponse(String res, String url) async {
    try {
      dynamic data = _decoder.convert(res);
      if (data['status'] == 401 && data['data'] == null) {
        return ApiResponseModel.fromJson(
            {"message": data['message'], "isInvalidLogin": true}, url);
      } else {
        return ApiResponseModel.fromJson(data, url);
      }
    } catch (e) {
      return ApiResponseModel.fromJson({"message": e.toString()}, url);
    }
  }

  Future<ApiResponseModel> getArrayResponse(String res, String url) async {
    try {
      dynamic data = _decoder.convert(res);

      if (data['status'] == 401 && data['data'] == null) {
        // SharedPrefs().clearPreferences();
        // NavigationService.instance
        //     .navigateToReplacementWithScale(ScaleRoute(page: TutorialScreen()));
        return ApiResponseModel.fromJson(
            {"message": data['message'], "isInvalidLogin": true}, url);
      } else {
        return ApiResponseModel.fromUsersJson(data);
      }
    } catch (e) {
      return ApiResponseModel.fromJson({"message": e.toString()}, url);
    }
  }
}
