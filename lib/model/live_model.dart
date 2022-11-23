import 'package:foap/helper/common_import.dart';
import 'package:intl/intl.dart';

class LiveModel {
  int id = 0;
  int startTime = 0;
  int endTime = 0;
  int totalTime = 0;
  GiftSummary? giftSummary;

  String? startedAt;

  LiveModel();

  factory LiveModel.fromJson(dynamic json) {
    LiveModel model = LiveModel();
    model.id = json['id'];
    model.startTime = json['start_time'];
    model.endTime = json['end_time'];
    model.totalTime = json['total_time'];
    model.giftSummary = GiftSummary.fromJson(json['giftSummary']);

    model.startedAt = DateFormat('dd-MM-yyyy hh:mm a')
        .format(DateTime.fromMillisecondsSinceEpoch(json['start_time'] * 1000));

    return model;
  }
}
