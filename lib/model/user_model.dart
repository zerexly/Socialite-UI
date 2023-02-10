import 'package:foap/helper/common_import.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserLiveCallDetail {
  int id = 0;
  int startTime = 0;
  int? endTime;
  int? totalTime;
  int status = 0;
  String token = '';
  String channelName = '';

  UserLiveCallDetail();

  factory UserLiveCallDetail.fromJson(dynamic json) {
    UserLiveCallDetail model = UserLiveCallDetail();
    model.id = json['id'];
    model.status = json['status'];
    model.startTime = json['start_time'];
    model.endTime = json['end_time'];
    model.totalTime = json['total_time'];
    model.token = json['token'] ?? '';
    model.channelName = json['channel_name'] ?? '';

    return model;
  }
}

class GiftSummary {
  int totalGift = 0;
  int totalCoin = 0;

  GiftSummary();

  factory GiftSummary.fromJson(dynamic json) {
    GiftSummary model = GiftSummary();
    model.totalGift = json['totalGift'];
    model.totalCoin = json['totalCoin'];
    return model;
  }
}

class UserModel {
  int id = 0;

  // String? name;
  String userName = '';

  String? email = '';
  String? picture;
  String? bio = '';
  String? phone = '';
  String? country = '';
  String? countryCode = '';
  String? city = '';
  String? gender = ''; //sex : 1=male, 2=female, 3=others

  int coins = 0;
  bool? isReported = false;
  String? paypalId;
  String balance = '';
  int? isBioMetricLoginEnabled = 0;

  int commentPushNotificationStatus = 0;
  int likePushNotificationStatus = 0;

  bool isFollowing = false;
  bool isFollower = false;
  bool isVerified = false;

  bool isOnline = false;
  int? chatLastTimeOnline = 0;
  int accountCreatedWith = 0;

  int totalPost = 0;
  int totalFollowing = 0;
  int totalFollower = 0;
  int totalWinnerPost = 0;

  String? latitude;
  String? longitude;

  UserLiveCallDetail? liveCallDetail;
  GiftSummary? giftSummary;
  List<UserSetting>? userSetting;

  // next release
  int isDatingEnabled = 0;
  int chatDeleteTime = 0;

  int profileCategoryTypeId = 0;
  String profileCategoryTypeName = 'Other';

  UserModel();

  factory UserModel.fromJson(dynamic json) {
    UserModel model = UserModel();
    model.id = json['id'];
    model.userName = json['username'].toString().toLowerCase();
    model.email = json['email'];
    model.picture = json['picture'];
    model.bio = json['bio'];
    model.isFollowing = json['isFollowing'] == 1;
    model.isFollower = json['isFollower'] == 1;

    model.latitude = json['latitude'];
    model.longitude = json['longitude'];

    model.phone = json['phone'];
    model.country = json['country'];
    model.countryCode = json['country_code'];
    model.city = json['city'];
    model.gender = json['sex'] == null ? 'Male' : json['sex'].toString();

    model.totalPost = json['totalActivePost'] ?? json['totalPost'] ?? 0;
    model.totalFollower = json['totalFollower'] ?? 0;
    model.totalFollowing = json['totalFollowing'] ?? 0;
    model.coins = json['available_coin'] ?? 0;
    model.totalWinnerPost = json['totalWinnerPost'] ?? 0;

    model.isReported = json['is_reported'] == 1;
    model.isOnline = json['is_chat_user_online'] == 1;
    model.chatLastTimeOnline = json['chat_last_time_online'];
    model.accountCreatedWith = json['account_created_with'] ?? 1;
    model.isVerified = json['is_verified'] == 1;
    model.chatDeleteTime =
        json['chat_delete_period'] ?? AppConfigConstants.secondsInADay;

    model.paypalId = json['paypal_id'];
    model.balance = (json['available_balance'] ?? '').toString();
    model.isBioMetricLoginEnabled = json['is_biometric_login'];
    model.commentPushNotificationStatus =
        json['comment_push_notification_status'] ?? 0;
    model.likePushNotificationStatus =
        json['like_push_notification_status'] ?? 0;
    model.liveCallDetail = json['userLiveDetail'] != null
        ? UserLiveCallDetail.fromJson(json['userLiveDetail'])
        : null;
    model.giftSummary = json['giftSummary'] != null
        ? GiftSummary.fromJson(json['giftSummary'])
        : null;
    model.profileCategoryTypeId = json['profile_category_type'] ?? 0;
    model.profileCategoryTypeName = json['profileCategoryName'] ?? 'Other';

    model.userSetting = json['userSetting'] != null
        ? List<UserSetting>.from(
            json['userSetting'].map((x) => UserSetting.fromJson(x)))
        : null;
    return model;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": userName,
        "email": email,
        "picture": picture,
        "bio": bio,
        "phone": phone,
        "country": country,
        "country_code": countryCode,
        "city": city,
        "sex": gender,
        "totalPost": totalPost,
        "available_coin": coins,
        "is_reported": isReported,
        "paypal_id": paypalId,
        "available_balance": balance
      };

  static UserModel placeholderUser() {
    UserModel model = UserModel();
    model.id = 1;
    model.userName = LocalizationString.loading;
    // model.name = LocalizationString.loading;
    model.email = LocalizationString.loading;
    model.picture = LocalizationString.loading;
    model.bio = LocalizationString.loading;
    model.isFollowing = false;
    model.isFollower = false;

    model.phone = LocalizationString.loading;
    model.country = LocalizationString.loading;
    model.countryCode = LocalizationString.loading;
    model.city = LocalizationString.loading;
    model.gender = 'Male';

    model.totalPost = 0;
    model.coins = 0;
    model.isReported = false;
    model.paypalId = LocalizationString.loading;
    model.balance = LocalizationString.loading;
    model.isBioMetricLoginEnabled = 0;
    model.commentPushNotificationStatus = 0;
    model.likePushNotificationStatus = 0;

    return model;
  }

  String get getInitials {
    List<String> nameParts = userName.trim().split(' ');
    if (nameParts.length > 1) {
      return nameParts[0].substring(0, 1).toUpperCase() +
          nameParts[1].substring(0, 1).toUpperCase();
    } else {
      if (nameParts[0].isEmpty) {
        return '*';
      }
      return nameParts[0].substring(0, 1).toUpperCase();
    }
  }

  String get lastSeenAtTime {
    if (chatLastTimeOnline == null) {
      return LocalizationString.offline;
    }

    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(chatLastTimeOnline! * 1000).toUtc();
    return '${LocalizationString.lastSeen}${timeago.format(dateTime)}';
  }

  bool get isMe {
    return id == getIt<UserProfileManager>().user!.id;
  }

  ChatRoomMember get toChatRoomMember {
    return ChatRoomMember(
        id: id, isAdmin: 0, roomId: 0, userDetail: this, userId: id);
  }

  RelationsRevealSetting get relationsRevealSetting {
    if (userSetting == null || (userSetting ?? []).isEmpty) {
      return RelationsRevealSetting.none;
    } else if (userSetting?.first.relationSetting == 1) {
      return RelationsRevealSetting.all;
    } else if (userSetting?.first.relationSetting == 2) {
      return RelationsRevealSetting.followers;
    }
    return RelationsRevealSetting.none;
  }

  bool get canViewRelations {
    if (relationsRevealSetting == RelationsRevealSetting.none) {
      return false;
    } else if (relationsRevealSetting == RelationsRevealSetting.followers &&
        isFollowing) {
      return true;
    } else {
      return true;
    }
  }
}

class InterestModel {
  int id = 0;
  String name = "";
  int status = 0;

  InterestModel();

  factory InterestModel.fromJson(dynamic json) {
    InterestModel model = InterestModel();
    model.id = json['id'];
    model.name = json['name'];
    model.status = json['status'];

    return model;
  }
}

class UserSetting {
  int? id;
  int? userId;
  int? relationSetting;

  UserSetting({this.id, this.userId, this.relationSetting});

  UserSetting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    relationSetting = json['relation_setting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['relation_setting'] = relationSetting;
    return data;
  }
}
