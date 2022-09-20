import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class CallData {
  String uuid;
  int id;
  String callerName;
  int callerId;
  String callerImage;
  String channelName;
  String token;
  int type;

  CallData({
    required this.uuid,
    required this.id,
    required this.callerName,
    required this.callerId,
    required this.callerImage,
    required this.channelName,
    required this.token,
    required this.type,
  });

  factory CallData.fromJson(Map<String, dynamic> json) => CallData(
        uuid: json["id"],
        callerName: json["nameCaller"],
        type: json["type"],
        id: json["extra"]["id"],
        callerId: json["extra"]["callerId"],
        callerImage: json["extra"]["callerImage"],
        channelName: json["extra"]["channelName"],
        token: json["extra"]["token"],
      );
}

class VoipController {
  final AgoraCallController agoraCallController = Get.find();

  endCall(Call call) {
    var params = <String, dynamic>{'id': call.uuid};
    FlutterCallkitIncoming.endCall(params);
  }

  listenerSetup() {
    FlutterCallkitIncoming.onEvent.listen((event) {
      switch (event!.name) {
        case CallEvent.ACTION_CALL_INCOMING:
          getIt<SocketManager>().connect();
          break;
        case CallEvent.ACTION_CALL_START:
          break;
        case CallEvent.ACTION_CALL_ACCEPT:
          CallData callData = CallData.fromJson(event.body);

          UserModel opponent = UserModel();
          opponent.id = callData.callerId;
          opponent.userName = callData.callerName;
          opponent.picture = callData.callerImage;

          Call call = Call(
              uuid: callData.uuid,
              callId: callData.id,
              channelName: callData.channelName,
              isOutGoing: false,
              token: callData.token,
              callType: callData.type == 0 ? 1 : 2,
              opponent: opponent);
          agoraCallController.acceptCall(call: call);
          break;
        case CallEvent.ACTION_CALL_DECLINE:
          Call call = Call(
              uuid: event.body['id'],
              channelName: '',
              isOutGoing: false,
              opponent: UserModel(),
              token: '',
              callType: 0,
              callId: 0);
          //endCall(call);
          agoraCallController.declineCall(call: call);
          break;
        case CallEvent.ACTION_CALL_ENDED:
          // print('call ended == ${event.body}');
          // CallData callData = CallData.fromJson(event.body);
          Call call = Call(
              uuid: event.body['id'],
              channelName: '',
              isOutGoing: false,
              opponent: UserModel(),
              token: '',
              callType: 0,
              callId: 0);
          var params = <String, dynamic>{'id': event.body['id']};
          FlutterCallkitIncoming.endCall(params);
          agoraCallController.endCall(call);
          break;
        case CallEvent.ACTION_CALL_TIMEOUT:
          CallData callData = CallData.fromJson(event.body);
          if (callData.callerId != getIt<UserProfileManager>().user?.id &&
              getIt<UserProfileManager>().user?.id != null) {
            Call call = Call(
                uuid: callData.uuid,
                channelName: callData.channelName,
                isOutGoing: false,
                opponent: UserModel(),
                token: callData.token,
                callType: callData.type == 0 ? 1 : 2,
                callId: callData.id);
            var params = <String, dynamic>{'id': event.body['id']};
            FlutterCallkitIncoming.endCall(params);
            agoraCallController.declineCall(call: call);
          }

          break;
        case CallEvent.ACTION_CALL_CALLBACK:

          break;
        case CallEvent.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case CallEvent.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
    });
  }

  outGoingCall(Call call) async {
    var params = <String, dynamic>{
      'id': call.uuid,
      'nameCaller': call.opponent.userName,
      'handle': call.channelName,
      'type': call.callType == 1 ? 0 : 1,
      'extra': <String, dynamic>{
        'id': call.callId,
        'callerId': getIt<UserProfileManager>().user!.id,
        'callerImage': getIt<UserProfileManager>().user!.picture,
        'channelName': call.channelName,
        'token': call.token
      },
      'ios': <String, dynamic>{'handleType': 'generic'}
    };
    await FlutterCallkitIncoming.startCall(params);
  }

  missCall(Call call) async {
    var params = <String, dynamic>{
      'id': call.uuid,
      'nameCaller': call.opponent.userName,
      'handle': call.channelName,
      'type': call.callType == 1 ? 0 : 1,
      'extra': <String, dynamic>{
        'id': call.callId,
        'callerId': getIt<UserProfileManager>().user!.id,
        'callerImage': getIt<UserProfileManager>().user!.picture,
        'channelName': call.channelName,
        'token': call.token
      },
      'ios': <String, dynamic>{'handleType': 'generic'}
    };
    await FlutterCallkitIncoming.showMissCallNotification(params);
  }

  endAllCalls() async {
    await FlutterCallkitIncoming.endAllCalls();
  }
}
