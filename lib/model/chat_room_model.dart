import 'package:foap/helper/common_import.dart';

class ChatRoomModel {
  int id = 0;
  int status = 0;
  int createdAt = 0;
  int createdBy = 0;
  List<UserModel> users = [];
  ChatMessageModel lastMessage;
  bool isTyping = false;
  bool isOnline = false;
  int unreadMessages = 0;

  ChatRoomModel(
      {required this.id,
      required this.status,
      required this.createdAt,
      required this.createdBy,
      required this.users,
      required this.isOnline,
      required this.lastMessage});

  factory ChatRoomModel.fromJson(dynamic json) => ChatRoomModel(
      id: json['id'],
      status: json['status'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      isOnline: json['is_chat_user_online'] == 1,
      users: (json['chatRoomUser'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e["user"]))
          .toList(),
      lastMessage: ChatMessageModel.fromJson(json['lastMessage']));

  UserModel get opponent {
    return users
        .where((element) => element.id != getIt<UserProfileManager>().user!.id)
        .first;
  }
}
