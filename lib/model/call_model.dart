import 'package:foap/helper/common_import.dart';

class Call {
  final String uuid;

  final String channelName;
  final bool isOutGoing;
  final UserModel opponent;
  final String token;
  final int callId;
  final int callType;

  Call(
      {required this.uuid,
      required this.channelName,
      required this.isOutGoing,
      required this.opponent,
      required this.token,
      required this.callType,
      required this.callId});
}

class Live {
  final String channelName;
  final bool isHosting;
  final UserModel host;
  final String token;
  final int liveId;

  Live(
      {required this.channelName,
      required this.isHosting,
      required this.host,
      required this.token,
      required this.liveId});
}
