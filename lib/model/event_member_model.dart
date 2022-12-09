import 'package:foap/helper/common_import.dart';

class EventMemberModel {
  int id = 0;
  int eventId = 0;
  int userId = 0;
  int isAdmin = 0;
  UserModel? user;

  EventMemberModel();

  factory EventMemberModel.fromJson(dynamic json) {
    EventMemberModel model = EventMemberModel();
    model.id = json['id'];
    model.eventId = json['club_id'];
    model.userId = json['user_id'];
    model.isAdmin = json['is_admin'];
    model.user = UserModel.fromJson(json['user']);

    return model;
  }
}
