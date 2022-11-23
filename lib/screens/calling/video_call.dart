import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class VideoCallingScreen extends StatefulWidget {
  final Call call;

  const VideoCallingScreen({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  State<VideoCallingScreen> createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  final AgoraCallController agoraCallController = Get.find();
  final GlobalKey<TimerViewState> _timerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Wakelock.enable(); // Turn on wakelock feature till call is running
  }

  @override
  void dispose() {
    // _engine.leaveChannel();
    // _engine.destroy();
    Wakelock.disable(); // Turn off wakelock feature after call end
    super.dispose();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return PIPView(
      builder: (context, isFloating) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: widget.call.isOutGoing
              ? outgoingCallView(isFloating)
              : incomingCallView(isFloating),
        );
      },
      floatingHeight: 150,
      floatingWidth: 100,
    );
  }

  Widget outgoingCallView(bool isFloating) {
    return GetBuilder<AgoraCallController>(
        init: agoraCallController,
        builder: (ctx) {
          return agoraCallController.remoteJoined.value == false
              ? Stack(
                  children: [
                    Center(
                      child: _renderLocalPreview(),
                    ),
                    _connectedCallBottomPortionWidget(),
                    Center(child: opponentInfoView(isFloating))
                  ],
                )
              : connectedCallView(isFloating);
        });
  }

  Widget connectedCallView(bool isFloating) {
    return Stack(
      children: [
        Obx(() => Center(
              child: agoraCallController.switchMainView.value
                  ? _renderLocalPreview()
                  : _renderRemoteVideo(isFloating),
            )),
        // _timerView(),
        _cameraView(isFloating),
        isFloating == false ? _connectedCallBottomPortionWidget() : Container(),
        isFloating == false ? topBar(context) : Container(),
      ],
    );
  }

  Widget incomingCallView(bool isFloating) {
    return GetBuilder<AgoraCallController>(
        init: agoraCallController,
        builder: (ctx) {
          return agoraCallController.remoteJoined.value == false
              ? Stack(
                  children: [
                    Center(
                      child: _renderLocalPreview(),
                    ),
                    _incomingCallBottomPortionWidget(),
                    Center(child: opponentInfoView(isFloating))
                  ],
                )
              : connectedCallView(isFloating);
        });
  }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 70,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              color: Colors.white,
              size: 25,
            ).p8.ripple(() {
              // Get.back();
              PIPView.of(context)!.presentBelow(const DashboardScreen());
            }),
            const Spacer(),
            _timerView(),
            const Spacer(),
            const SizedBox(
              width: 25,
            )
          ]),
        ).hP16,
      ],
    );
  }

  // Generate local preview
  Widget _renderLocalPreview() {
    // if (_joined) {
    return const rtc_local_view.SurfaceView();
    // } else {
    //   return Padding(
    //     padding: const EdgeInsets.all(15),
    //     child: Text(
    //       LocalizationString.waitForJoiningLabel,
    //       textAlign: TextAlign.center,
    //       style: Theme.of(context).textTheme.bodyLarge.themeColor,
    //     ),
    //   );
    // }
  }

  // Generate remote preview
  Widget _renderRemoteVideo(bool isFloating) {
    if (agoraCallController.remoteJoined.value == true) {
      return Stack(
        children: [
          agoraCallController.reConnectingRemoteView.value
              ? Container(
                  color: Theme.of(context).errorColor,
                  child: Center(
                      child: Text(
                    LocalizationString.reConnecting,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white70),
                  )))
              : agoraCallController.videoPaused.value
                  ? Container(
                      color: Theme.of(context).primaryColor,
                      child: Center(
                          child: Text(
                        LocalizationString.videoPaused,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white70),
                      )))
                  : rtc_remote_view.SurfaceView(
                      uid: agoraCallController.remoteUserId.value,
                      channelId: widget.call.channelName,
                      // channel id need to check
                    ),
        ],
      );
    } else {
      return opponentInfoView(isFloating);
    }
  }

  Widget opponentInfoView(bool isFloating) {
    return isFloating
        ? UserAvatarView(
            user: widget.call.opponent,
            size: double.infinity,
            onTapHandler: () {},
          )
        : Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              UserAvatarView(
                user: widget.call.opponent,
                size: 80,
                onTapHandler: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.call.opponent.userName,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w900)
                    .copyWith(color: Colors.white70),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.call.isOutGoing
                    ? LocalizationString.ringing
                    : LocalizationString.incomingCall,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600)
                    .copyWith(color: Colors.white70),
              )
            ],
          );
  }

  //Timer Ui
  Widget _timerView() => TimerView(
        key: _timerKey,
      );

  //Local Camera View
  Widget _cameraView(bool isFloating) => Container(
        padding: const EdgeInsets.symmetric(vertical: 150, horizontal: 20),
        alignment: Alignment.bottomRight,
        child: FractionallySizedBox(
          child: Container(
            width: 110,
            height: 140,
            alignment: Alignment.topRight,
            color: Colors.black,
            child: GestureDetector(
              onTap: () {
                agoraCallController.toggleMainView();
              },
              child: Center(
                child: agoraCallController.switchMainView.value
                    ? _renderRemoteVideo(isFloating)
                    : _renderLocalPreview(),
              ),
            ),
          ).round(10),
        ),
      );

  // Ui & UX For Bottom Portion (Switch Camera,Video On/Off,Mic On/Off)
  Widget _connectedCallBottomPortionWidget() => Container(
        margin: const EdgeInsets.only(bottom: 80, left: 35, right: 25),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Obx(() => Container(
                  color: agoraCallController.isFront.value
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.lighten(),
                  height: 50,
                  width: 50,
                  child: const ThemeIconWidget(
                    ThemeIcon.cameraSwitch,
                    size: 30,
                    color: Colors.white,
                  ),
                )).circular.ripple(() {
              agoraCallController.onToggleCamera();
            }),
            Obx(() => Container(
                  color: agoraCallController.mutedVideo.value
                      ? Theme.of(context).primaryColor.withOpacity(0.5)
                      : Theme.of(context).primaryColor,
                  height: 50,
                  width: 50,
                  child: ThemeIconWidget(
                    agoraCallController.mutedVideo.value
                        ? ThemeIcon.videoCameraOff
                        : ThemeIcon.videoCamera,
                    size: 30,
                    color: Colors.white,
                  ),
                )).circular.ripple(() {
              agoraCallController.onToggleMuteVideo();
            }),
            Obx(() => Container(
                  color: agoraCallController.mutedAudio.value
                      ? Theme.of(context).primaryColor.withOpacity(0.5)
                      : Theme.of(context).primaryColor,
                  height: 50,
                  width: 50,
                  child: ThemeIconWidget(
                    agoraCallController.mutedAudio.value
                        ? ThemeIcon.micOff
                        : ThemeIcon.mic,
                    size: 30,
                    color: Colors.white,
                  ),
                )).circular.ripple(() {
              agoraCallController.onToggleMuteAudio();
            }),
            Container(
              color: Theme.of(context).errorColor,
              height: 50,
              width: 50,
              child: const ThemeIconWidget(
                ThemeIcon.callEnd,
                size: 30,
                color: Colors.white,
              ),
            ).circular.ripple(() {
              agoraCallController.onCallEnd(widget.call);
            }),
          ],
        ),
      );

  Widget _incomingCallBottomPortionWidget() => Container(
        margin: const EdgeInsets.only(bottom: 80, left: 35, right: 25),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Theme.of(context).errorColor,
              height: 50,
              width: 50,
              child: const ThemeIconWidget(
                ThemeIcon.close,
                size: 30,
                color: Colors.white,
              ),
            ).circular.ripple(() {
              agoraCallController.declineCall(call:widget.call);
            }),
            Container(
              color: Theme.of(context).primaryColor,
              height: 50,
              width: 50,
              child: const ThemeIconWidget(
                ThemeIcon.checkMark,
                size: 30,
                color: Colors.white,
              ),
            ).circular.ripple(() {
              agoraCallController.acceptCall(call: widget.call);
            }),
          ],
        ),
      );
}
