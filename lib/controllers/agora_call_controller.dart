import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:foap/helper/common_import.dart';
import 'package:foap/util/constant_util.dart';
import 'package:get/get.dart';

class AgoraCallController extends GetxController {
  RxInt remoteUserId = 0.obs;

  RtcEngine? _engine;

  RxBool isFront = false.obs;
  RxBool reConnectingRemoteView = false.obs;
  RxBool videoPaused = false.obs;

  RxBool mutedAudio = false.obs;
  RxBool mutedVideo = false.obs;
  RxBool switchMainView = false.obs;
  RxBool remoteJoined = false.obs;

  // int callId = 0;

  late String localCallId;
  UserModel? opponent;

  //Initialize All The Setup For Agora Video Call

  setIncomingCallId(int id) {
    // callId = id;
  }

  clear() {
    isFront.value = false;
    reConnectingRemoteView.value = false;
    videoPaused.value = false;

    mutedAudio.value = false;
    mutedVideo.value = false;
    switchMainView.value = false;
    remoteJoined.value = false;
  }

  makeCallRequest({required Call call}) {
    opponent = call.opponent;
    localCallId = randomId();

    getIt<SocketManager>().emit(
        SocketConstants.onCallRequest,
        ({
          CallArgParams.senderId: getIt<UserProfileManager>().user!.id,
          CallArgParams.receiverId: call.opponent.id,
          CallArgParams.callType: call.callType,
          CallArgParams.localCallId: localCallId,
          // CallArgParams.channelName: channelName
        }));
  }

  Future<void> initializeCalling({
    required Call call,
  }) async {
    if (AppConfigConstants.agoraApiKey.isEmpty) {
      // print('Agora Engine is not starting');
      update();
      return;
    }
    Future.delayed(Duration.zero, () async {
      await _initAgoraRtcEngine(
          callType:
              call.callType == 1 ? AgoraCallType.audio : AgoraCallType.video);
      _addAgoraEventHandlers();
      var configuration = VideoEncoderConfiguration();
      configuration.dimensions =
          const VideoDimensions(width: 1920, height: 1080);
      configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
      await _engine!.setVideoEncoderConfiguration(configuration);
      await _engine!.leaveChannel();

      await _engine!.joinChannel(call.token, call.channelName, null,
          getIt<UserProfileManager>().user!.id);

      if (call.callType == 1) {
        Get.to(() => AudioCallingScreen(call: call));
      } else {
        Get.to(() => VideoCallingScreen(call: call));
      }
      update();
    });
  }

  //Initialize Agora RTC Engine
  Future<void> _initAgoraRtcEngine({required AgoraCallType callType}) async {
    _engine = await RtcEngine.create(AppConfigConstants.agoraApiKey);
    if (callType == AgoraCallType.video) {
      await _engine!.enableVideo();
    }
  }

  //Switch Camera
  onToggleCamera() {
    _engine!.switchCamera().then((value) {
      isFront.value = !isFront.value;
    }).catchError((err) {});
  }

  void toggleMainView() {
    switchMainView.value = !switchMainView.value;
    update();
  }

  //Audio On / Off
  void onToggleMuteAudio() {
    mutedAudio.value = !mutedAudio.value;
    _engine!.muteLocalAudioStream(mutedAudio.value);
  }

  //Video On / Off
  void onToggleMuteVideo() {
    mutedVideo.value = !mutedVideo.value;
    _engine!.muteLocalVideoStream(mutedVideo.value);
  }

  //Agora Events Handler To Implement Ui/UX Based On Your Requirements
  void _addAgoraEventHandlers() {
    _engine!.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        // final info = 'onError:$code ${code.index}';
        // print(info);
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        // final info = 'onJoinChannel: $channel, uid: $uid';
        // print(info);
      },
      leaveChannel: (stats) {
        // print('onLeaveChannel');
      },
      userJoined: (uid, elapsed) {
        // final info = 'userJoined: $uid';
        remoteJoined.value = true;
        remoteUserId.value = uid;
        update();
      },
      userOffline: (uid, elapsed) async {
        if (elapsed == UserOfflineReason.Dropped) {
          Wakelock.disable();
        } else {
          // final info = 'userOffline: $uid';
          remoteUserId.value = 0;
          update();
          // _timerKey.currentState?.cancelTimer();
        }
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        // final info = 'firstRemoteVideo: $uid ${width}x $height';
      },
      connectionStateChanged: (type, reason) async {
        // print('connectionStateChanged');
        if (type == ConnectionStateType.Connected) {
          reConnectingRemoteView.value = false;
        } else if (type == ConnectionStateType.Reconnecting) {
          reConnectingRemoteView.value = true;
        }
      },
      remoteVideoStats: (remoteVideoStats) {
        if (remoteVideoStats.receivedBitrate == 0) {
          videoPaused.value = true;
        } else {
          videoPaused.value = false;
        }
      },
    ));
  }

  // call

  callStatusUpdateReceived(Map<String, dynamic> updatedData) {
    int status = updatedData['status'];

    if (status == 5) {
      if (remoteJoined.value == true) {
        _engine?.leaveChannel();
        _engine?.destroy();

        clear();
      }

      // callId = 0;
      Call call = Call(
          uuid: updatedData['uuid'],
          channelName: '',
          isOutGoing: false,
          opponent: UserModel(),
          token: '',
          callType: 0,
          callId: updatedData['id']);

      getIt<VoipController>().endCall(call);
      remoteJoined.value = false;
      Wakelock.disable();
      Get.back();
    } else if (status == 2) {
      Get.back();
    }
  }

  outgoingCallConfirmationReceived(Map<String, dynamic> updatedData) {
    String uuid = updatedData['uuid'];
    int id = updatedData['id'];
    String localCallId = updatedData['localCallId'];
    var agoraToken = updatedData['token'];
    var channelName = updatedData['channelName'];
    int callType = updatedData['callType'];

    Call call = Call(
        uuid: uuid,
        channelName: channelName!,
        isOutGoing: true,
        opponent: opponent!,
        token: agoraToken!,
        callType: callType,
        callId: id);

    if (this.localCallId == localCallId) {
      // callId = id;
      initializeCalling(call: call);
      getIt<VoipController>().outGoingCall(call);
    }
  }

  incomingCallReceived(Map<String, dynamic> updatedData) {
    // int id = updatedData['id'];
    int callType = updatedData['callType'];
    String userImage = updatedData['userImage'];
    String username = updatedData['username'];
    int callerId = updatedData['callerId'];
    // String channelName = updatedData['channelName'];
    // String agoraToken = updatedData['token'];

    // callId = id;

    UserModel opponent = UserModel();
    opponent.id = callerId;
    opponent.userName = username;
    opponent.picture = userImage;

    if (callType == 1) {
      // audio call
      // Get.to(() =>
      //     AudioCallingScreen(
      //         opponent: opponent,
      //         channelName: channelName,
      //         token: agoraToken,
      //         isOutGoing: false //widget.isForOutGoing,
      //     ));
    } else {
      // video call
      // Call call = Call(
      //     callId: id,
      //     channelName: channelName,
      //     isOutGoing: false,
      //     opponent: opponent,
      //     callType: callType,
      //     token: agoraToken);
      // Get.to(() => VideoCallingScreen(
      //       call: call,
      //     ));
    }
  }

  void acceptCall({required Call call}) async {
    getIt<SocketManager>().emit(SocketConstants.onAcceptCall, {
      'uuid': call.uuid,
      'userId': getIt<UserProfileManager>().user!.id,
      'status': 4,
      // 'channelName': call.channelName
    });

    //Todo: this need to be checked
    remoteUserId.value = call.opponent.id;
    remoteJoined.value = true;
    initializeCalling(
      call: call,
    );
  }

  //Use This Method To End Call
  void endCall(Call call) async {
    _engine?.leaveChannel();
    _engine?.destroy();
    clear();

    Wakelock.disable(); // Turn off wakelock feature after call end

    // callId = 0;
    remoteJoined.value = false;
    Get.back();
  }

  void onCallEnd(Call call) async {
    if (remoteJoined.value == true) {
      if (Platform.isAndroid) {
        endCall(call);
        Get.back();
      }
      getIt<SocketManager>().emit(SocketConstants.onCompleteCall, {
        'uuid': call.uuid,
        'userId': getIt<UserProfileManager>().user!.id,
        'status': 5,
        // 'channelName': call.channelName
      });
    } else {
      if (Platform.isAndroid) {
        endCall(call);
        Get.back();
      }
      getIt<SocketManager>().emit(SocketConstants.onRejectCall, {
        'uuid': call.uuid,
        'userId': getIt<UserProfileManager>().user!.id,
        'status': 2
      });
    }
    getIt<VoipController>().endCall(call);
  }

  void declineCall({required Call call}) async {
    getIt<SocketManager>().emit(SocketConstants.onRejectCall, {
      'uuid': call.uuid,
      'userId': getIt<UserProfileManager>().user!.id,
      'status': 2
    });
    getIt<VoipController>().endCall(call);

    // callId = 0;
    remoteJoined.value = false;
    Get.back();
  }

  void timeOutCall(Call call) async {
    getIt<SocketManager>().emit(SocketConstants.onNotAnswered, {
      'uuid': call.uuid,
      'userId': getIt<UserProfileManager>().user!.id,
      'status': 3
    });
    getIt<VoipController>().endCall(call);
    // callId = 0;
    remoteJoined.value = false;
    Get.back();
  }
}
