import 'dart:developer';

import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ApiResponseModel {
  bool success = true;
  String message = "";
  bool isInvalidLogin = true;
  String? authKey;
  String? postedMediaFileName;
  String? postedMediaCompletePath;
  String? token;

  UserModel? user;
  CompetitionModel? competition;
  int highlightId = 0;

  List<CompetitionModel> competitions = [];
  List<PostModel> posts = [];
  List<StoryModel> stories = [];
  List<StoryMediaModel> myActiveStories = [];
  List<StoryMediaModel> myStories = [];
  List<CommentModel> comments = [];
  List<PackageModel> packages = [];
  List<CountryModel> countries = [];
  List<PaymentModel> payments = [];
  List<UserModel> topUsers = [];
  List<UserModel> topWinners = [];
  List<UserModel> users = [];
  List<UserModel> blockedUsers = [];
  List<CallHistoryModel> callHistory = [];
  List<UserModel> liveUsers = [];

  List<NotificationModel> notifications = [];
  List<SupportRequestModel> supportMessages = [];
  List<Hashtag> hashtags = [];
  List<HighlightsModel> highlights = [];
  APIMetaData? metaData;
  SettingModel? settings;
  PostModel? post;

  int roomId = 0;
  List<ChatRoomModel> chatRooms = [];

  ApiResponseModel();

  factory ApiResponseModel.fromJson(dynamic json, String url) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['data'];
    model.isInvalidLogin = json['isInvalidLogin'] == null ? false : true;

    log(json.toString());
    // log(url);

    if (model.success) {
      model.message = json['message'];
      if (data != null && data.length > 0) {
        if (data['user'] != null) {
          if (url == NetworkConstantsUtil.getMyProfile ||
              url == NetworkConstantsUtil.otherUser) {
            model.user = UserModel.fromJson(data['user']);
          }
          if (data['auth_key'] != null) {
            model.authKey = data['auth_key'];
            //AppConfigConstants.userId = model.user!.id;
          }
        } else if (data['competition'] != null) {
          if (url == NetworkConstantsUtil.getCompetitions) {
            var items = data['competition']['items'];

            if (items != null && items.length > 0) {
              model.competitions = List<CompetitionModel>.from(
                  items.map((x) => CompetitionModel.fromJson(x)));
              model.metaData =
                  APIMetaData.fromJson(data['competition']['_meta']);
            }
          } else if (data['competition'] != null) {
            model.competition = CompetitionModel.fromJson(data['competition']);
          }
        } else if (data['results'] != null) {
          var items = data['results'];
          if (items != null && items.length > 0) {
            model.hashtags =
                List<Hashtag>.from(items.map((x) => Hashtag.fromJson(x)));
          }
        } else if (data['notification'] != null) {
          var items = data['notification']['items'];
          if (items != null && items.length > 0) {
            model.notifications = List<NotificationModel>.from(
                items.map((x) => NotificationModel.fromJson(x)));
          }
          model.metaData = APIMetaData.fromJson(data['notification']['_meta']);
        } else if (data['highlight'] != null) {
          var items = data['highlight'];
          if (items != null && items.length > 0) {
            model.highlights = List<HighlightsModel>.from(
                items.map((x) => HighlightsModel.fromJson(x)));
          }
        } else if (data['supportRequest'] != null) {
          var items = data['supportRequest']['items'];
          if (items != null && items.length > 0) {
            model.supportMessages = List<SupportRequestModel>.from(
                items.map((x) => SupportRequestModel.fromJson(x)));
          }
        } else if (data['follower'] != null) {
          if (url == NetworkConstantsUtil.followers) {
            var items = (data['follower']['items'] as List<dynamic>)
                .map((e) => e['followerUserDetail'])
                .toList();
            if (items.isNotEmpty) {
              model.users =
                  List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            }
          }
        } else if (data['following'] != null) {
          if (url == NetworkConstantsUtil.following) {
            var items = (data['following']['items'] as List<dynamic>)
                .where((element) => element['followingUserDetail'] != null)
                .map((e) => e['followingUserDetail'])
                .toList();
            if (items.isNotEmpty) {
              model.users =
                  List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            }
          } else {
            var items = (data['following'] as List<dynamic>)
                .map((e) => e['followingUserDetail'])
                .toList();
            if (items.isNotEmpty) {
              model.liveUsers =
                  List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            }
          }
        } else if (data['topUser'] != null || data['topWinner'] != null) {
          var topUsers = data['topUser'];
          var topWinners = data['topWinner'];

          if (topUsers != null && topUsers.length > 0) {
            model.topUsers = List<UserModel>.from(
                topUsers.map((x) => UserModel.fromJson(x)));
          }

          if (topWinners != null && topWinners.length > 0) {
            model.topWinners = List<UserModel>.from(
                topWinners.map((x) => UserModel.fromJson(x)));
          }
        } else if (data['blockedUser'] != null) {
          var blockedUser = data['blockedUser'];

          if (blockedUser != null && blockedUser.length > 0) {
            var items = (data['blockedUser'] as List<dynamic>)
                .where((element) => element['blockedUserDetail'] != null)
                .map((e) => e['blockedUserDetail'])
                .toList();

            model.blockedUsers =
                List<UserModel>.from(items.map((x) => UserModel.fromJson(x)));
            // model.metaData = APIMetaData.fromJson(data['blockedUser']['_meta']);
          }
        } else if (data['token'] != null) {
          model.token = data['token'] as String;
        } else if (data['verify_token'] != null) {
          model.token = data['verify_token'] as String;
        } else if (data['filename'] != null) {
          model.postedMediaFileName = data['filename'] as String;
        } else if (data['files'] != null) {
          var items = data['files'] as List<dynamic>;

          model.postedMediaFileName = items.first['file'];
          model.postedMediaCompletePath = items.first['fileUrl'];
        } else if (data['story'] != null) {
          if (url == NetworkConstantsUtil.myStories) {
            model.myStories = [];
            var items = data['story']['items'];
            if (items != null && items.length > 0) {
              model.myStories = List<StoryMediaModel>.from(
                  items.map((x) => StoryMediaModel.fromJson(x)));
            }
          } else if (url == NetworkConstantsUtil.myCurrentActiveStories) {
            model.myActiveStories = [];
            var items = data['story']['items'];
            if (items != null && items.length > 0) {
              model.myActiveStories = List<StoryMediaModel>.from(
                  items.map((x) => StoryMediaModel.fromJson(x)));
            }
          } else if (url == NetworkConstantsUtil.stories) {
            model.stories = [];
            var items = data['story'];
            if (items != null && items.length > 0) {
              model.stories = List<StoryModel>.from(
                  items.map((x) => StoryModel.fromJson(x)));
            }
          }
        } else if (data['post'] != null) {
          if (url == NetworkConstantsUtil.postDetail) {
            var post = data['post'];

            if (post != null) {
              model.post = PostModel.fromJson(post);
            }
          } else {
            model.posts = [];
            var items = data['post']['items'];
            if (items != null && items.length > 0) {
              model.posts =
                  List<PostModel>.from(items.map((x) => PostModel.fromJson(x)))
                      .where((element) => element.gallery.isNotEmpty)
                      .toList();
            }

            model.metaData = APIMetaData.fromJson(data['post']['_meta']);
          }
        } else if (data['comment'] != null) {
          model.comments = [];
          var items = data['comment']['items'];
          if (items != null && items.length > 0) {
            model.comments = List<CommentModel>.from(
                items.map((x) => CommentModel.fromJson(x)));
          }
          model.metaData = APIMetaData.fromJson(data['comment']['_meta']);
        } else if (data['package'] != null) {
          model.packages = [];
          var packagesArr = data['package'];
          if (packagesArr != null && packagesArr.length > 0) {
            model.packages = List<PackageModel>.from(
                packagesArr.map((x) => PackageModel.fromJson(x)));
          }
        } else if (data['country'] != null && data['country'].length > 0) {
          model.countries = List<CountryModel>.from(
              data['country'].map((x) => CountryModel.fromJson(x)));
        } else if (data['payment'] != null && data['payment'].length > 0) {
          model.payments = List<PaymentModel>.from(
              data['payment'].map((x) => PaymentModel.fromJson(x)));
        } else if (data['setting'] != null) {
          var setting = data['setting'];
          model.settings = SettingModel.fromJson(setting);
        } else if (data['callHistory'] != null) {
          var callHistory = data['callHistory'];
          var items = callHistory['items'];

          model.callHistory = List<CallHistoryModel>.from(
              items.map((x) => CallHistoryModel.fromJson(x)));
          model.metaData = APIMetaData.fromJson(data['callHistory']['_meta']);
        } else if (data['room_id'] != null) {
          model.roomId = data['room_id'];
        } else if (data['room'] != null) {
          model.chatRooms = [];
          var room = data['room'] as List<dynamic>?;
          if (room != null && room.isNotEmpty) {
            room = room
                .where((element) => element['lastMessage'] != null)
                .toList();
            model.chatRooms = List<ChatRoomModel>.from(
                room.map((x) => ChatRoomModel.fromJson(x)));
          }
        }
      }
    } else {
      if (data == null) {
        Timer(const Duration(seconds: 1), () {
          Get.to(() => const LoginScreen());
        });
      } else if (data['token'] != null) {
        model.token = data['token'] as String;
      } else if (data['errors'] != null) {
        Map errors = data['errors'];
        var errorsArr = errors[errors.keys.first] ?? [];
        String error = errorsArr.first ?? LocalizationString.errorMessage;
        model.message = error;
      } else {
        Timer.periodic(const Duration(seconds: 1), (timer) {
          Get.to(() => const LoginScreen());
        });
      }
    }
    return model;
  }

  factory ApiResponseModel.fromUsersJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = json['status'] == 200;
    dynamic data = json['data'];

    if (model.success) {
      model.message = json['message'];
      if (data != null && data.length > 0) {
        if (data['user'] != null && data['user'].length > 0) {
          model.users = List<UserModel>.from(
              data['user'].map((x) => UserModel.fromJson(x)));
        }
      }
    } else {
      Map errors = data['errors'];
      var errorsArr = errors[errors.keys.first] ?? [];
      String error = errorsArr.first ?? LocalizationString.errorMessage;
      model.message = error;
    }
    return model;
  }

  factory ApiResponseModel.fromErrorJson(dynamic json) {
    ApiResponseModel model = ApiResponseModel();
    model.success = false;
    model.message = json['message'];
    return model;
  }
}
