import 'package:foap/util/time_convertor.dart';

import 'user_model.dart';

class CommentModel {
  int id = 0;
  String comment = "";

  int userId = 0;
  String userName = '';
  String? userPicture;
  String commentTime = '';

  CommentModel();

  factory CommentModel.fromJson(dynamic json) {
    CommentModel model = CommentModel();
    model.id = json['id'];
    model.comment = json['comment'];
    model.userId = json['user_id'];
    dynamic user = json['user'];
    if (user != null) {
      model.userName = user['username'];
      model.userPicture = user['picture'];
    }

    DateTime createDate =
        DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toUtc();
    model.commentTime = TimeAgo.timeAgoSinceDate(createDate);
    return model;
  }

  factory CommentModel.fromNewMessage(String comment, UserModel user) {
    CommentModel model = CommentModel();
    model.comment = comment;

    model.userId = user.id;
    model.userName = user.userName ;
    model.userPicture = user.picture;

    return model;
  }
}
