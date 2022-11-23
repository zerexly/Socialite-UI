import 'package:foap/helper/common_import.dart';

class ClubModel {
  int? categoryId;
  int? id;
  int? userId;
  int? privacyType;
  String? name;
  String? desc;
  int? enableChat;
  int? chatRoomId;
  int? isJoined;
  int? createdBy;
  int? totalMembers;

  String? image;
  String? imageName;

  UserModel? createdByUser;

  ClubModel({
    this.id,
    this.categoryId,
    this.userId,
    this.privacyType,
    this.name,
    this.desc,
    this.enableChat,
    this.chatRoomId,
    this.isJoined,
    this.image,
    this.imageName,
    this.createdBy,
    this.createdByUser,
    this.totalMembers,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) => ClubModel(
        id: json["id"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        privacyType: json["privacy_type"],
        name: json["name"],
        chatRoomId: json["chat_room_id"],
        enableChat: json["is_chat_room"],
        image: json["imageUrl"],
        imageName: json["image"],
        desc: json["description"],
        isJoined: json["is_joined"],
        createdBy: json["created_by"],
        totalMembers: json["totalJoinedUser"],
        createdByUser: json["createdByUser"] == null ? null :UserModel.fromJson(json["createdByUser"]),
      );

  bool get amIAdmin {
    return createdByUser!.isMe;
  }
}
