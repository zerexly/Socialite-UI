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
  List<CachedRequest> cachedRequests = [];

  final ChatHistoryController _chatController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final DashboardController _dashboardController = Get.find();
  final AgoraCallController _agoraCallController = Get.find();
  final AgoraLiveController _agoraLiveController = Get.find();
  final HomeController _homeController = Get.find();
  final TvStreamingController _liveTvStreamingController = Get.find();

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

    // if(_socketInstance!.connected == false){
    _socketInstance?.connect();
    // }

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
    _socketInstance?.on(SocketConstants.addUserInChatRoom, addedInRoom);

    _socketInstance?.on(SocketConstants.typing, onReceiveTyping);
    // _socketInstance?.on(SocketConstants.readMessage, readMessage);

    _socketInstance?.on(
        SocketConstants.offlineStatusEvent, onOfflineStatusEvent);
    _socketInstance?.on(SocketConstants.onlineStatusEvent, onOnlineStatusEvent);

    _socketInstance?.on(SocketConstants.leaveGroupChat, leaveGroupChat);
    _socketInstance?.on(SocketConstants.removeUserAdmin, removeUserAdmin);
    _socketInstance?.on(
        SocketConstants.removeUserFromGroupChat, removeUserFromGroupChat);
    _socketInstance?.on(SocketConstants.makeUserAdmin, makeUserAdmin);
    _socketInstance?.on(
        SocketConstants.updateChatAccessGroup, updateChatAccessGroup);

    // live end point handlers
    _socketInstance?.on(SocketConstants.joinLive, liveJoinedByUser);
    // _socketInstance?.on(SocketConstants.sendMessageInLive, onOnlineStatusEvent);
    _socketInstance?.on(
        SocketConstants.liveCreatedConfirmation, liveCreatedConfirmation);
    _socketInstance?.on(SocketConstants.leaveLive, onUserLeaveLive);
    _socketInstance?.on(SocketConstants.endLive, onLiveEnd);
    _socketInstance?.on(SocketConstants.sendMessageInLive, newMessageInLive);

    // live tv
    _socketInstance?.on(
        SocketConstants.sendMessageInLiveTv, onReceiveMessageInLiveTv);
  }

//To Emit Event Into Socket
  bool emit(String event, Map<String, dynamic> data) {
    print('emiting ${_socketInstance!.connected}');
    if (_socketInstance!.connected == true) {
      print(
          'event == $event ========== data = ${jsonDecode(json.encode(data))}');
      _socketInstance?.emit(event, jsonDecode(json.encode(data)));
    } else {
      // print('socked is not connected');
      cachedRequests.add(CachedRequest(event: event, data: data));
    }
    return _socketInstance!.connected;
  }

//Get This Event After Successful Connection To Socket
  dynamic onConnect(_) {
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
    _agoraCallController.outgoingCallConfirmationReceived(response);
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
    _agoraCallController.callStatusUpdateReceived(response);
  }

//******************* Chat ****************************//

  void addedInRoom(dynamic response) {
    response['action'] =
        1; // 1 for added, 2 for removed , 3 for made admin , 4 for removed from admin, 5 left , 6 removed from group
    Map<String, dynamic> chatMessage = {};
    chatMessage['id'] = 0;
    chatMessage['local_message_id'] = randomId();
    chatMessage['room'] = response['room'];
    chatMessage['messageType'] = 100;
    chatMessage['message'] = jsonEncode(response);
    chatMessage['created_by'] = response['userIdActiondBy'];
    chatMessage['created_at'] = response['created_at'];

    ChatMessageModel message = ChatMessageModel.fromJson(chatMessage);
    _chatController.newMessageReceived(message);
    _chatDetailController.newMessageReceived(message);

    // getIt<SocketManager>().emit(SocketConstants.addUserInChatRoom, {
    //   'userId': '${getIt<UserProfileManager>().user!.id}',
    //   'room': response['room'].toString()
    // });
  }

  void onReceiveMessage(dynamic response) async {
    ChatMessageModel message = ChatMessageModel.fromJson(response);

    await _chatDetailController.newMessageReceived(message);
    _chatController.newMessageReceived(message);

    int roomsWithUnreadMessageCount =
        await getIt<DBManager>().roomsWithUnreadMessages();
    _dashboardController.updateUnreadMessageCount(roomsWithUnreadMessageCount);
  }

  void onDeleteMessage(dynamic response) {
    int deleteScope = response['deleteScope'] as int;
    int roomId = response['room'] as int;
    int messageId = response['id'] as int;

    if (deleteScope == 2) {
      _chatDetailController.messagedDeleted(
          messageId: messageId, roomId: roomId);
    }
  }

  void onReceiveTyping(dynamic response) {
    var userName = response['username'];
    var roomId = response['room'];

    _chatController.userTypingStatusChanged(
        userName: userName, roomId: roomId, status: true);
    _chatDetailController.userTypingStatusChanged(
        roomId: roomId, userName: userName, status: true);
  }

  void updateMessageStatus(dynamic response) {
    _chatDetailController.messageUpdateReceived(response);
  }

  void onOfflineStatusEvent(dynamic response) {
    var userId = response['userId'];

    _chatController.userAvailabilityStatusChange(
        userId: userId, isOnline: false);
    _chatDetailController.userAvailabilityStatusChange(
        userId: userId, isOnline: false);
  }

  void onOnlineStatusEvent(dynamic response) {
    var userId = response['userId'];
    _chatController.userAvailabilityStatusChange(
        userId: userId, isOnline: true);
    _chatDetailController.userAvailabilityStatusChange(
        userId: userId, isOnline: true);
  }

  // group chat
  leaveGroupChat(dynamic response) {
    response['action'] =
        5; // 1 for added, 2 for removed , 3 for made admin ,4 remove form admins, 5 left
    Map<String, dynamic> chatMessage = {};
    chatMessage['id'] = 0;
    chatMessage['local_message_id'] = randomId();
    chatMessage['room'] = response['room'];
    chatMessage['messageType'] = 100;
    chatMessage['message'] = jsonEncode(response);
    chatMessage['created_by'] = response['userId'];
    chatMessage['created_at'] = response['created_at'];

    ChatMessageModel message = ChatMessageModel.fromJson(chatMessage);
    _chatController.newMessageReceived(message);
    _chatDetailController.newMessageReceived(message);
  }

  removeUserAdmin(dynamic response) {
    response['action'] =
        4; // 1 for added, 2 for removed , 3 for made admin ,4 left
    Map<String, dynamic> chatMessage = {};
    chatMessage['id'] = 0;
    chatMessage['local_message_id'] = randomId();
    chatMessage['room'] = response['room'];
    chatMessage['messageType'] = 100;
    chatMessage['message'] = jsonEncode(response);
    chatMessage['created_by'] = response['userIdActiondBy'];
    chatMessage['created_at'] = response['created_at'];

    ChatMessageModel message = ChatMessageModel.fromJson(chatMessage);
    _chatController.newMessageReceived(message);
    _chatDetailController.newMessageReceived(message);
  }

  removeUserFromGroupChat(dynamic response) {
    response['action'] =
        2; // 1 for added, 2 for removed , 3 for made admin ,4 left
    Map<String, dynamic> chatMessage = {};
    chatMessage['id'] = 0;
    chatMessage['local_message_id'] = randomId();
    chatMessage['room'] = response['room'];
    chatMessage['messageType'] = 100;
    chatMessage['message'] = jsonEncode(response);
    chatMessage['created_by'] = response['userIdActiondBy'];
    chatMessage['created_at'] = response['created_at'];

    ChatMessageModel message = ChatMessageModel.fromJson(chatMessage);
    _chatController.newMessageReceived(message);
    _chatDetailController.newMessageReceived(message);
  }

  makeUserAdmin(dynamic response) {
    response['action'] =
        3; // 1 for added, 2 for removed , 3 for made admin ,4 left
    Map<String, dynamic> chatMessage = {};
    chatMessage['id'] = 0;
    chatMessage['local_message_id'] = randomId();
    chatMessage['room'] = response['room'];
    chatMessage['messageType'] = 100;
    chatMessage['message'] = jsonEncode(response);
    chatMessage['created_by'] = response['userIdActiondBy'];
    chatMessage['created_at'] = response['created_at'];

    ChatMessageModel message = ChatMessageModel.fromJson(chatMessage);
    _chatController.newMessageReceived(message);
    _chatDetailController.newMessageReceived(message);
  }

  updateChatAccessGroup(dynamic response) {
    _chatDetailController.updatedChatGroupAccessStatus(
        chatRoomId: response['room'],
        chatAccessGroup: response['chatAccessGroup']);
  }

  // live

  void liveJoinedByUser(dynamic response) {
    int userId = response['userId'];
    ApiController().getOtherUser(userId.toString()).then((response) {
      _agoraLiveController.onNewUserJoined(response.user!);
    });
  }

  void newMessageInLive(dynamic response) {
    ChatMessageModel message = ChatMessageModel.fromJson(response);
    _agoraLiveController.onNewMessageReceived(message);
  }

  void liveCreatedConfirmation(dynamic response) {
    _agoraLiveController.liveCreatedConfirmation(response);
  }

  void onUserLeaveLive(dynamic response) {
    _agoraLiveController.onUserLeave(response['userId']);
  }

  void onLiveEnd(dynamic response) {
    _homeController.liveUsersUpdated();
    _agoraLiveController.onLiveEnd(response['liveCallId']);
  }

  // live tv

  void onReceiveMessageInLiveTv(dynamic response) async {
    ChatMessageModel message = ChatMessageModel.fromJson(response);

    await _liveTvStreamingController.newMessageReceived(message);
  }
}
