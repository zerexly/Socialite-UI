//Initialize Socket Connection
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:foap/helper/common_import.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class CachedRequest {
  String event;
  Map<String, dynamic> data;

  CachedRequest({required this.event, required this.data});
}

class SocketManager {
  io.Socket? _socketInstance;
  BuildContext? buildContext;
  String? channelName;
  String? channelToken;
  ResCallAcceptModel? resCallAcceptModel;
  List<CachedRequest> cachedRequests = [];

  final ChatController chatController = Get.find();
  final ChatDetailController chatDetailController = Get.find();
  final AgoraCallController agoraCallController = Get.find();
  final AgoraLiveController agoraLiveController = Get.find();
  final HomeController homeController = Get.find();

  StreamSubscription<FGBGType>? subscription;

  disconnect() {
    _socketInstance = null;
    _socketInstance?.disconnect();
  }

//Initialize Socket Connection
  dynamic connect() {
    // buildContext = context;
    if (_socketInstance != null) return;
    _socketInstance = io.io(
      ApiConstants.socketUrl,
      <String, dynamic>{
        ApiConstants.transportsHeader: [
          ApiConstants.webSocketOption,
          ApiConstants.pollingOption
        ],
      },
    );
    getIt<VoipController>().listenerSetup();

    _socketInstance?.connect();
    socketGlobalListeners();

    subscription = FGBGEvents.stream.listen((event) {
      if (event == FGBGType.foreground) {
        _socketInstance?.connect();
      } else {
        _socketInstance?.disconnect();
      }
      // FGBGType.foreground or FGBGType.background
    });
  }

//Socket Global Listener Events
  dynamic socketGlobalListeners() {
    _socketInstance?.on(SocketConstants.eventConnect, onConnect);
    _socketInstance?.on(SocketConstants.eventDisconnect, onDisconnect);
    _socketInstance?.on(SocketConstants.onSocketError, onConnectError);
    _socketInstance?.on(SocketConstants.eventConnectTimeout, onConnectError);

    // call end points handlers
    _socketInstance?.on(SocketConstants.incomingCall, handleOnCallReceived);

    _socketInstance?.on(
        SocketConstants.onCallRequestConfirm, handleOnCallConfirmation);
    _socketInstance?.on(
        SocketConstants.onCallStatusUpdated, handleOnCallStatusUpdate);

    // chat end point handlers
    _socketInstance?.on(SocketConstants.sendMessage, onReceiveMessage);
    _socketInstance?.on(
        SocketConstants.updateMessageStatus, updateMessageStatus);
    _socketInstance?.on(SocketConstants.deleteMessage, onDeleteMessage);

    _socketInstance?.on(SocketConstants.typing, onReceiveTyping);
    _socketInstance?.on(
        SocketConstants.offlineStatusEvent, onOfflineStatusEvent);
    _socketInstance?.on(SocketConstants.onlineStatusEvent, onOnlineStatusEvent);

    // live end point handlers
    _socketInstance?.on(SocketConstants.joinLive, liveJoinedByUser);
    _socketInstance?.on(SocketConstants.sendMessageInLive, onOnlineStatusEvent);
    _socketInstance?.on(
        SocketConstants.liveCreatedConfirmation, liveCreatedConfirmation);
    _socketInstance?.on(SocketConstants.leaveLive, onUserLeaveLive);
    _socketInstance?.on(SocketConstants.endLive, onLiveEnd);
    _socketInstance?.on(SocketConstants.sendMessageInLive, newMessageInLive);
  }

//To Emit Event Into Socket
  bool emit(String event, Map<String, dynamic> data) {
    if (_socketInstance!.connected == true) {
      _socketInstance?.emit(event, jsonDecode(json.encode(data)));
    } else {
      // print('socked is not connected');
      cachedRequests.add(CachedRequest(event: event, data: data));
    }
    return _socketInstance!.connected;
  }

//Get This Event After Successful Connection To Socket
  dynamic onConnect(_) {
    // print("===> connected socket....................");
    emit(SocketConstants.login, {
      'userId': getIt<UserProfileManager>().user!.id,
      'username': getIt<UserProfileManager>().user!.userName
    });

    for (CachedRequest request in cachedRequests) {
      // print('sending cached event ${request.event}');
      emit(request.event, request.data);
    }
    cachedRequests.clear();
  }

//Get This Event After Connection Lost To Socket Due To Network Or Any Other Reason
  dynamic onDisconnect(_) {
    // print("===> Disconnected socket....................");
  }

//Get This Event After Connection Error To Socket With Error
  dynamic onConnectError(error) {
    // print("===> ConnectError socket.................... $error");
  }

  //Get This Event When your call is created
  void handleOnCallConfirmation(dynamic response) {
    // print('handleOnCallConfirmation $response');
    agoraCallController.outgoingCallConfirmationReceived(response);

    // if (response != null) {
    //   final data = ResCallRequestModel.fromJson(response);
    //   Get.to(() => PickUpScreen(
    //       resCallRequestModel: data,
    //       resCallAcceptModel: ResCallAcceptModel(),
    //       isForOutGoing: false));
    // }
  }

//Get This Event When you Received Call From Other User
  void handleOnCallReceived(dynamic response) {
    // voipController.incomingCall();
    // agoraCallController.incomingCallReceived(response);

    // if (response != null) {
    //   final data = ResCallRequestModel.fromJson(response);
    //   Get.to(() => PickUpScreen(
    //       resCallRequestModel: data,
    //       resCallAcceptModel: ResCallAcceptModel(),
    //       isForOutGoing: false));
    // }
  }

//Get This Event When Other User Accepts/decline/completed Your Call
  void handleOnCallStatusUpdate(dynamic response) async {
    agoraCallController.callStatusUpdateReceived(response);
    // if (response != null) {
    //   final data = ResCallAcceptModel.fromJson(response);
    //   resCallAcceptModel = data;
    //   channelName = data.channel;
    //   channelToken = data.token;
    //
    //   Get.to(() => VideoCallingScreen(
    //         channelName: data.channel!,
    //         token: data.token!,
    //         resCallAcceptModel: data,
    //         resCallRequestModel: ResCallRequestModel(),
    //         isForOutGoing: true,
    //       ));
    // }
  }

//******************* Chat ****************************//

  void onReceiveMessage(dynamic response) {
    ChatMessageModel message = ChatMessageModel.fromJson(response);
    chatController.newMessageReceived(message);
    chatDetailController.newMessageReceived(message);
  }

  void onDeleteMessage(dynamic response) {
    print('delete message notification ${response}');

    int deleteScope = response['deleteScope'] as int;
    int roomId = response['room'] as int;
    int messageId = response['id'] as int;

    if (deleteScope == 2) {
      chatDetailController.messagedDeleted(
          messageId: messageId, roomId: roomId);
    }
  }

  void onReceiveTyping(dynamic response) {
    var userName = response['username'];

    chatController.userTypingStatusChanged(userName: userName, status: true);
    chatDetailController.userTypingStatusChanged(
        userName: userName, status: true);

    // ChatMessageModel message = ChatMessageModel.fromJson(response);
    // chatController.newMessageReceived(message);
    // chatDetailController.newMessageReceived(message);
  }

  void updateMessageStatus(dynamic response) {
    chatDetailController.messageUpdateReceived(response);
  }

  void onOfflineStatusEvent(dynamic response) {
    var userId = response['userId'];

    chatController.userAvailabilityStatusChange(
        userId: userId, isOnline: false);
    chatDetailController.userAvailabilityStatusChange(
        userId: userId, isOnline: false);
  }

  void onOnlineStatusEvent(dynamic response) {
    var userId = response['userId'];
    chatController.userAvailabilityStatusChange(userId: userId, isOnline: true);
    chatDetailController.userAvailabilityStatusChange(
        userId: userId, isOnline: true);
  }

  // live

  void liveJoinedByUser(dynamic response) {
    int userId = response['userId'];
    ApiController().getOtherUser(userId.toString()).then((response) {
      agoraLiveController.onNewUserJoined(response.user!);
    });
  }

  void newMessageInLive(dynamic response) {
    ChatMessageModel message = ChatMessageModel.fromJson(response);
    agoraLiveController.onNewMessageReceived(message);
  }

  void liveCreatedConfirmation(dynamic response) {
    agoraLiveController.liveCreatedConfirmation(response);
  }

  void onUserLeaveLive(dynamic response) {
    agoraLiveController.onUserLeave(response['userId']);
  }

  void onLiveEnd(dynamic response) {
    homeController.liveUsersUpdated();
    agoraLiveController.onLiveEnd(response['liveCallId']);
  }
}
