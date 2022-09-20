import 'package:foap/helper/common_import.dart';
import 'package:foap/util/time_convertor.dart';

class StoryModel {
  int id;

  // int isReported;
  String name;
  String userName;
  String email;
  String? image;
  List<StoryMediaModel> media;
  bool isViewed = false;

  StoryModel({
    required this.id,
    // required this.isReported,
    required this.name,
    required this.userName,
    required this.email,
    this.image,
    required this.media,
  });

  factory StoryModel.fromJson(dynamic json) {
    StoryModel model = StoryModel(
      id: json['id'],
      // isReported: json['is_reported'],
      name: json['name'],
      userName: json['username'],
      email: json['email'],
      image: json['picture'],
      media: (json['userStory'] as List<dynamic>)
          .map((e) => StoryMediaModel.fromJson(e))
          .toList(),
    );

    return model;
  }
}

class StoryMediaModel {
  int id;
  int userId;

  String? description;

  String? bgColor;
  String? video;
  String? image;
  String? imageName;
  int createdAtDate;
  String createdAt;
  int type;
  UserModel? user;

  StoryMediaModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.bgColor,
    required this.video,
    required this.image,
    required this.imageName,
    required this.createdAtDate,
    required this.createdAt,
    required this.type,
    required this.user,
  });

  factory StoryMediaModel.fromJson(dynamic json) {
    StoryMediaModel model = StoryMediaModel(
        id: json['id'],
        userId: json['user_id'],
        description: json['description'],
        bgColor: json['background_color'],
        video: json['videoUrl'],
        imageName: json['image'],
        image: json['imageUrl'],
        createdAtDate : json['created_at'] * 1000,
        createdAt: TimeAgo.timeAgoSinceDate(
            DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000)
                .toUtc()),
        type: json['type'],
        user: json['user'] == null ? null : UserModel.fromJson(json['user']));

    return model;
  }

  isVideoPost() {
    return type == 3;
  }

  // String thumbnail() {
  //   return isVideoPost() == true ? videoThumbnail! : filePath;
  // }
}

