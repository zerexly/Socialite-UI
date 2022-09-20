import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:foap/helper/common_import.dart';
import 'package:foap/util/constant_util.dart';
import 'package:get/get.dart';

class AgoraLiveController extends GetxController {
  Rx<TextEditingController> messageTf = TextEditingController().obs;
  RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  RxInt remoteUserId = 0.obs;

  RxList<String> infoStrings = <String>[].obs;
  late RtcEngine _engine;
  late int liveId;
  late String localLiveId;

  RxList<UserModel> joinedUsers = <UserModel>[].obs;
  UserModel? host;

  RxBool isFront = false.obs;
  RxBool reConnectingRemoteView = false.obs;
  RxBool mutedAudio = false.obs;
  RxBool mutedVideo = false.obs;
  RxBool videoPaused = false.obs;
  RxBool liveEnd = false.obs;
  RxBool isHost = false.obs;

  clear() {
    isFront.value = false;
    reConnectingRemoteView.value = false;
    mutedAudio.value = false;
    mutedVideo.value = false;
    videoPaused.value = false;
    liveEnd.value = false;
    isHost.value = false;
  }

  //Initialize All The Setup For Agora Video Call
  Future<void> initializeLive() async {
    localLiveId = randomId();
    getIt<SocketManager>().emit(SocketConstants.goLive, {
      'userId': getIt<UserProfileManager>().user!.id,
      'localCallId': localLiveId,
    });
  }

  joinAsAudience({required Live live}) async {
    liveEnd.value = false;
    // liveEnd.value = false;
    // if (live.host != null) {
    //   host = hostUser;
    // } else {
    await ApiController()
        .getOtherUser(live.host.id.toString())
        .then((response) {
      host = response.user;
    });
    // }
    liveId = live.liveId;

    remoteUserId.value = live.host.id;

    getIt<SocketManager>().emit(SocketConstants.joinLive, {
      'userId': getIt<UserProfileManager>().user!.id,
      'liveCallId': liveId,
    });
    sendTextMessage('Joined');
    joinedUsers.add(getIt<UserProfileManager>().user!);
    _joinLive(live: live);
  }

  _joinLive({
    required Live live,
  }) {
    if (AppConfigConstants.agoraApiKey.isEmpty) {
      infoStrings.add(
        AppConfigConstants.agoraApiKey,
      );
      infoStrings.add('Agora Engine is not starting');
      update();
      return;
    }

    Future.delayed(Duration.zero, () async {
      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      var configuration = VideoEncoderConfiguration();
      configuration.dimensions =
          const VideoDimensions(width: 1920, height: 1080);
      configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
      _engine.leaveChannel();
      await _engine.setVideoEncoderConfiguration(configuration);
      await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);

      live.isHosting
          ? await _engine.setClientRole(ClientRole.Broadcaster)
          : await _engine.setClientRole(ClientRole.Audience);
      await _engine.joinChannel(live.token, live.channelName, null,
          getIt<UserProfileManager>().user!.id);

      Get.to(() => LiveBroadcastScreen(
            live: live,
          ));
    });
  }

  //Initialize Agora RTC Engine
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(AppConfigConstants.agoraApiKey);
    await _engine.enableVideo();
  }

  //Switch Camera
  onToggleCamera() {
    _engine.switchCamera().then((value) {
      isFront.value = !isFront.value;
    }).catchError((err) {});
  }

  //Audio On / Off
  void onToggleMuteAudio() {
    mutedAudio.value = !mutedAudio.value;
    _engine.muteLocalAudioStream(mutedAudio.value);
  }

  //Video On / Off
  void onToggleMuteVideo() {
    mutedVideo.value = !mutedVideo.value;
    _engine.muteLocalVideoStream(mutedVideo.value);
  }

  //Agora Events Handler To Implement Ui/UX Based On Your Requirements
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        final info = 'onError:$code ${code.index}';
        infoStrings.add(info);
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        final info = 'onJoinChannel: $channel, uid: $uid';
        infoStrings.add(info);
        // joinedUsers.add(getIt<UserProfileManager>().user!);
      },
      leaveChannel: (stats) {
        infoStrings.add('onLeaveChannel');
      },
      userJoined: (uid, elapsed) {
        final info = 'userJoined: $uid';
        infoStrings.add(info);
      },
      userOffline: (uid, elapsed) async {
        if (elapsed == UserOfflineReason.Dropped) {
          Wakelock.disable();
        } else {
          final info = 'userOffline: $uid';
          infoStrings.add(info);
          // _timerKey.currentState?.cancelTimer();
        }
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        infoStrings.add(info);
      },
      connectionStateChanged: (type, reason) async {
        if (type == ConnectionStateType.Connected) {
          reConnectingRemoteView.value = false;
        } else if (type == ConnectionStateType.Reconnecting) {
          reConnectingRemoteView.value = true;
        }
      },
      remoteVideoStats: (remoteVideoStats) {
        if (remoteVideoStats.receivedBitrate == 0) {
          reConnectingRemoteView.value = true;
        } else {
          reConnectingRemoteView.value = false;
        }
      },
    ));
  }

  //Use This Method To End Call
  void onCallEnd({required bool isHost}) async {
    _engine.leaveChannel();
    _engine.destroy();
    Wakelock.disable(); // Turn off wakelock feature after call end
    clear();
    // Emit End live Event Into Socket

    if (isHost) {
      getIt<SocketManager>().emit(
          SocketConstants.endLive,
          ({
            'userId': getIt<UserProfileManager>().user!.id,
            'liveCallId': liveId
          }));
    } else {
      sendTextMessage('Left');
      getIt<SocketManager>().emit(
          SocketConstants.leaveLive,
          ({
            'userId': getIt<UserProfileManager>().user!.id,
            'liveCallId': liveId
          }));
    }
    joinedUsers.clear();
    messages.clear();
    Get.back();
  }

  messageChanges() {
    // getIt<SocketManager>().emit(SocketConstants.typing, {'room': chatRoomId});
    // messageTf.refresh();
    // update();
  }

  sendTextMessage(String messageText) {
    // if (messageTf.value.text.removeAllWhitespace.trim().isNotEmpty) {
    String localMessageId = randomId();

    var message = {
      'userId': getIt<UserProfileManager>().user!.id,
      'liveCallId': liveId,
      'messageType': messageTypeId(MessageContentType.text),
      'message': messageText,
      'localMessageId': localMessageId,
      'picture': getIt<UserProfileManager>().user!.picture,
      'username': getIt<UserProfileManager>().user!.userName,
      'created_at': (DateTime.now().millisecondsSinceEpoch / 1000).round()
    };

    //save message to socket server
    getIt<SocketManager>().emit(SocketConstants.sendMessageInLive, message);

    ChatMessageModel localMessageModel = ChatMessageModel();
    localMessageModel.localMessageId = localMessageId;
    localMessageModel.roomId = liveId;
    localMessageModel.messageTime = LocalizationString.justNow;
    localMessageModel.userName = LocalizationString.you;
    // localMessageModel.userPicture = getIt<UserProfileManager>().user!.picture;
    localMessageModel.senderId = getIt<UserProfileManager>().user!.id;
    localMessageModel.messageType = messageTypeId(MessageContentType.text);
    localMessageModel.messageContent = messageText;

    localMessageModel.createdAt =
        (DateTime.now().millisecondsSinceEpoch / 1000).round();

    messages.add(localMessageModel);
    messageTf.value.text = '';
    update();
    // }
  }

  //*************** updates from socket *******************//

  onNewUserJoined(UserModel user) {
    joinedUsers.add(user);
    update();
  }

  onUserLeave(int userId) {
    joinedUsers.removeWhere((element) => element.id == userId);
    update();
  }

  onLiveEnd(int liveId) {
    _engine.leaveChannel();
    _engine.destroy();
    Wakelock.disable();

    joinedUsers.clear();
    messages.clear();
    update();
    if (this.liveId == liveId) {
      // Get.back();

      liveEnd.value = true;
    }
  }

  onNewMessageReceived(ChatMessageModel message) {
    messages.add(message);
    update();
  }

  liveCreatedConfirmation(dynamic data) {
    if (data['localCallId'] == localLiveId) {
      liveId = data['liveCallId'];
    }
    String agoraToken = data['token'];
    String channelName = data['channelName'];

    Live live = Live(
        channelName: channelName,
        isHosting: true,
        host: getIt<UserProfileManager>().user!,
        token: agoraToken,
        liveId: liveId);

    _joinLive(live: live);

    update();
  }
}
