import 'package:timeago/timeago.dart' as timeago;

class NotificationModel {
  int id;
  int type;
  int userId;
  int referenceId;
  String title;
  String message;

  DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,

    required this.userId,
    required this.referenceId,
    required this.date,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"] ,
    title: json["title"] ,
    message: json["message"] ,
    userId: json["user_id"] ,
    referenceId: json["reference_id"] ,
    date: DateTime.fromMillisecondsSinceEpoch(json['created_at'] * 1000).toUtc() ,
    type: json["type"] ,
  );

  String notificationTime(){
    return timeago.format(date);
  }
}
