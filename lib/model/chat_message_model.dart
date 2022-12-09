import 'dart:convert';
import 'package:foap/helper/common_import.dart';
import 'package:foap/helper/date_extension.dart';
import 'package:intl/intl.dart';

class ChatContentJson {
  int originalMessageId = 0;

  ChatContentJson();

  factory ChatContentJson.fromJson(dynamic json) {
    ChatContentJson model = ChatContentJson();
    model.originalMessageId = json['originalMessageId'] as int;
    return model;
  }
}

class FileModel {
  String path;
  int type;
  String name;
  int size;

  FileModel(
      {required this.path,
      required this.type,
      required this.name,
      required this.size});
}

class ChatMedia {
  String? image;
  String? gif;
  String? video;
  String? audio;
  Contact? contact;
  LocationModel? location;
  FileModel? file;

  ChatMedia();

  factory ChatMedia.fromJson(Map<String, dynamic> data) {
    ChatMedia model = ChatMedia();
    model.image = data["image"] as String?;
    model.gif = data["image"] as String?;
    model.video = data["video"] as String?;
    model.audio = data["audio"] as String?;
    model.location = (data["location"] as Map<String, dynamic>?) != null
        ? LocationModel.fromJson(data["location"])
        : null;
    model.file = (data["file"] as Map<String, dynamic>?) != null
        ? FileModel(
            path: data["file"]["path"],
            type: data["file"]["type"],
            name: data["file"]["name"],
            size: data["file"]["size"] ?? 0)
        : null;
    model.contact = (data["contactCard"] as String?) != null
        ? Contact.fromVCard(data["contactCard"] as String)
        : null;

    return model;
  }

  Map<String, dynamic> toJson() => {
        'image': image,
        'video': video,
        'audio': audio,
        'location': location?.toJson(),
      };
}

class ChatPost {
  int postId = 0;
  String image = "";
  String video = "";
  String title = "";
  String postOwnerName = "";
  String postOwnerImage = "";

  ChatPost();

  factory ChatPost.fromJson(dynamic json) {
    ChatPost model = ChatPost();
    model.postId = json['postId'];
    model.title = "Title";
    model.postOwnerName = "Adam";
    model.postOwnerImage =
        "https://images.unsplash.com/photo-1656528049647-c82eb8174d04?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw3fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60";
    model.image =
        "https://images.unsplash.com/photo-1656533819629-2e386fafb6d5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60";
    model.video =
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
    return model;
  }
}

class GiftContent {
  String image = "";
  int coins = 0;

  GiftContent();

  factory GiftContent.fromJson(dynamic json) {
    GiftContent model = GiftContent();
    model.image = json['giftImage'];
    model.coins = int.parse(json['coins']);

    return model;
  }
}

class ProfileMinimumContent {
  int userId = 0;
  String? userPicture;
  String userName = "";
  String location = "";

  ProfileMinimumContent();

  factory ProfileMinimumContent.fromJson(dynamic json) {
    ProfileMinimumContent model = ProfileMinimumContent();
    model.userId = json['userId'];
    model.userPicture = json['userPicture'];
    model.userName = json['userName'];
    model.location = json['location'] ?? '';

    return model;
  }
}

class ChatMessageModel {
  int id = 0;
  bool isDateSeparator = false;

  String localMessageId = "";
  int roomId = 0;
  String liveTvId = '';

  // int roomType = 0;
  String messageContent = "";
  int senderId = 0;
  int createdAt = 0;
  int? viewedAt;
  int deleteAfter = AppConfigConstants.secondsInADay;

  // String messageTime = '';
  String lastMessageSenderName = '';

  int opponentId = 0;
  String userName = '';
  String? userPicture;
  int messageType = 0;
  int status = 0;
  int isDeleted = 0;
  int isStar = 0;

  Media? media;
  Contact? contact;

  ChatMessageModel? replyMessageContent;
  ChatMessageModel? originalMessageContent;

  ChatMessageModel();

  factory ChatMessageModel.fromJson(dynamic json) {
    ChatMessageModel model = ChatMessageModel();
    model.id = json['id'] ?? 0;
    model.localMessageId = json['local_message_id'] ?? json['localMessageId'];
    model.roomId = json['room'] ?? json['room_id'] ?? json['liveCallId'] ?? 0;
    model.liveTvId = json['liveTvId'] ?? '';

    // model.roomType = json['type'] ?? 1;
    model.messageType = json['messageType'] ?? json['type'];
    model.messageContent = json['message'];
    model.senderId = json['created_by'];
    model.createdAt = json['created_at'];
    model.viewedAt = json['viewed_at'];
    model.deleteAfter =
        json['deleteAfter'] ?? getIt<UserProfileManager>().user!.chatDeleteTime;

    // model.messageTime = createDate.messageTimeForChat();
    model.isDeleted = json['isDeleted'] ?? 0;
    model.isStar = json['isStar'] ?? 0;

    model.opponentId = json['opponent_id'] ?? 0;
    model.userName = json['username'] ?? '';
    model.userPicture = json['picture'] ?? '';
    model.status = json['status'] ?? 0;
    model.isDateSeparator = false;

    return model;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'local_message_id': localMessageId,
        'room_id': roomId,
        // 'type': roomType,
        'messageType': messageType,
        'message': messageContent,
        'created_by': senderId,
        'created_at': createdAt,
        'username': userName,
        'isDeleted': isDeleted,
        'isStar': isStar,
      };

  int get originalMessageId {
    return ChatContentJson.fromJson(messageContent).originalMessageId;
  }

  ChatMedia get mediaContent {
    return ChatMedia.fromJson(json.decode(messageContent));
  }

  ChatPost get postContent {
    return ChatPost.fromJson(json.decode(messageContent));
  }

  GiftContent get giftContent {
    return GiftContent.fromJson(json.decode(messageContent));
  }

  ProfileMinimumContent get profileContent {
    return ProfileMinimumContent.fromJson(json.decode(messageContent));
  }

  String? get copyContent {
    if (messageContentType == MessageContentType.text) {
      return messageContent;
    } else if (messageContentType == MessageContentType.reply) {
      return reply.messageContent;
    } else if (messageContentType == MessageContentType.forward) {
      return originalMessage.messageContent;
    }
    return null;
  }

  MessageStatus get messageStatusType {
    if (status == 1) {
      return MessageStatus.sent;
    } else if (status == 2) {
      return MessageStatus.delivered;
    } else if (status == 3) {
      return MessageStatus.read;
    }
    return MessageStatus.sending;
  }

  bool get isReply {
    return messageContentType == MessageContentType.reply;
  }

  bool get isFwd {
    return messageContentType == MessageContentType.forward;
  }

  ChatMessageModel get reply {
    // print('reply');
    // print(replyMessageContent);

    return replyMessageContent ??
        ChatMessageModel.fromJson(
            json.decode(json.decode(messageContent)['reply']));
  }

  ChatMessageModel get originalMessage {
    var formattedString = messageContent;
    return originalMessageContent ??
        ChatMessageModel.fromJson(
            json.decode(formattedString)['originalMessage']);
  }

  MessageContentType get messageContentType {
    if (messageType == 1) {
      return MessageContentType.text;
    } else if (messageType == 2) {
      return MessageContentType.photo;
    } else if (messageType == 3) {
      return MessageContentType.video;
    } else if (messageType == 4) {
      return MessageContentType.audio;
    } else if (messageType == 5) {
      return MessageContentType.gif;
    } else if (messageType == 6) {
      return MessageContentType.sticker;
    } else if (messageType == 7) {
      return MessageContentType.contact;
    } else if (messageType == 8) {
      return MessageContentType.location;
    } else if (messageType == 9) {
      return MessageContentType.reply;
    } else if (messageType == 10) {
      return MessageContentType.forward;
    } else if (messageType == 11) {
      return MessageContentType.post;
    } else if (messageType == 12) {
      return MessageContentType.story;
    } else if (messageType == 13) {
      return MessageContentType.drawing;
    } else if (messageType == 14) {
      return MessageContentType.profile;
    } else if (messageType == 15) {
      return MessageContentType.group;
    } else if (messageType == 16) {
      return MessageContentType.file;
    } else if (messageType == 100) {
      return MessageContentType.groupAction;
    } else if (messageType == 200) {
      return MessageContentType.gift;
    }
    return MessageContentType.text;
  }

  bool get isMediaMessage {
    if (messageType == 1) {
      return false;
    } else if (messageType == 2) {
      return true;
    } else if (messageType == 3) {
      return true;
    } else if (messageType == 4) {
      return true;
    } else if (messageType == 5) {
      return false;
    } else if (messageType == 6) {
      return false;
    } else if (messageType == 7) {
      return false;
    } else if (messageType == 8) {
      return false;
    } else if (messageType == 9) {
      return reply.isMediaMessage;
    } else if (messageType == 10) {
      return originalMessage.isMediaMessage;
    } else if (messageType == 11) {
      return false;
    } else if (messageType == 12) {
      return false;
    } else if (messageType == 13) {
      return true;
    } else if (messageType == 14) {
      return false;
    } else if (messageType == 15) {
      return false;
    } else if (messageType == 16) {
      return true;
    } else if (messageType == 100) {
      return false;
    } else if (messageType == 200) {
      return false;
    }
    return false;
  }

  bool get isMineMessage {
    return senderId == getIt<UserProfileManager>().user!.id;
  }

  int get chatDay {
    DateTime createDate = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return int.parse(DateFormat('d').format(createDate));
  }

  String get date {
    DateTime createDate = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
    return DateFormat('dd-MMM-yyyy').format(createDate);
  }

  String get messageTime {
    DateTime createDate = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);

    final difference = DateTime.now().difference(createDate).inDays;

    if (createDate.isToday()) {
      return DateFormat('hh:mm a').format(createDate);
    } else if (createDate.isYesterday()) {
      return LocalizationString.yesterday;
    } else if (difference < 7) {
      return DateFormat('EEEE').format(createDate);
    }
    return DateFormat('dd-MMM-yyyy').format(createDate);
  }

  String get shortInfo {
    if (messageType == 1) {
      return messageContent;
    } else if (messageType == 2) {
      return LocalizationString.sentAPhoto;
    } else if (messageType == 3) {
      return LocalizationString.sentAVideo;
    } else if (messageType == 4) {
      return LocalizationString.sentAnAudio;
    } else if (messageType == 5) {
      return LocalizationString.sentAGif;
    } else if (messageType == 6) {
      return LocalizationString.sentASticker;
    } else if (messageType == 7) {
      return LocalizationString.sentAContact;
    } else if (messageType == 8) {
      return LocalizationString.sentALocation;
    } else if (messageType == 9) {
      return reply.shortInfo;
    } else if (messageType == 10) {
      return originalMessage.shortInfo;
    } else if (messageType == 11) {
      return LocalizationString.sentAPost;
    } else if (messageType == 12) {
      return LocalizationString.sentAStory;
    } else if (messageType == 13) {
      return LocalizationString.sentADrawing;
    } else if (messageType == 14) {
      return LocalizationString.sentAProfile;
    } else if (messageType == 100) {
      Map<String, dynamic> actionMessage = json.decode(messageContent);
      int action = actionMessage['action'] as int;

      if (action == 1) {
        String userName = actionMessage['username'] as String;

        return '$userName ${LocalizationString.addedToGroup}';
      } else if (action == 2) {
        String userName = actionMessage['username'] as String;

        return '$userName ${LocalizationString.removedFromGroup}';
      } else if (action == 3) {
        String userName = actionMessage['username'] as String;

        return '$userName ${LocalizationString.madeAdmin}';
      } else if (action == 4) {
        String userName = actionMessage['username'] as String;

        return '$userName ${LocalizationString.removedFromAdmins}';
      } else if (action == 5) {
        String userName = actionMessage['username'] as String;

        return '$userName ${LocalizationString.leftTheGroup}';
      }
    }
    return messageContent;
  }

  String get filePath {
    if (messageContentType == MessageContentType.photo) {
      return mediaContent.image!;
    }
    if (messageContentType == MessageContentType.video) {
      return mediaContent.video!;
    }
    if (messageContentType == MessageContentType.audio) {
      return mediaContent.audio!;
    }
    return mediaContent.file!.path;
  }
}
