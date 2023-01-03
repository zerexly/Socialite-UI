import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class AudioCallingScreen extends StatefulWidget {
  final Call call;

  const AudioCallingScreen({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  State<AudioCallingScreen> createState() => _AudioCallingScreenState();
}

class _AudioCallingScreenState extends State<AudioCallingScreen> {
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

  Widget connectedCallView(bool isFloating) {
    return Stack(
      children: [
        Center(child: _renderRemoteView(isFloating)),
        isFloating == false ? _bottomPortionWidget() : Container(),
        isFloating == false ? topBar() : Container(),
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
                    Center(child: _renderRemoteView(isFloating)),
                    _incomingCallBottomPortionWidget(),
                  ],
                )
              : connectedCallView(isFloating);
        });
  }

  Widget outgoingCallView(bool isFloating) {
    return GetBuilder<AgoraCallController>(
        init: agoraCallController,
        builder: (ctx) {
          return agoraCallController.remoteJoined.value == false
              ? Stack(
                  children: [
                    Center(child: _renderRemoteView(isFloating)),
                    _bottomPortionWidget(),
                  ],
                )
              : connectedCallView(isFloating);
        });
  }

  Widget topBar() {
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

  // Generate remote preview
  Widget _renderRemoteView(bool isFloating) {
    if (agoraCallController.remoteJoined.value == false) {
      return Stack(
        children: [
          agoraCallController.reConnectingRemoteView.value == true
              ? Container(
                  color: Theme.of(context).errorColor,
                  child: Center(
                      child: Text(
                    LocalizationString.reConnecting,
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(color: Colors.white),
                  )))
              : const SizedBox(),
          Center(child: opponentInfo(isFloating)),
        ],
      );
    } else {
      return opponentInfo(isFloating);
    }
  }

  Widget opponentInfo(bool isFloating) {
    return isFloating
        ? UserAvatarView(
            user: widget.call.opponent,
            size: double.infinity,
            onTapHandler: () {},
          )
        : Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              UserAvatarView(
                user: widget.call.opponent,
                size: 100,
                onTapHandler: () {},
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.call.opponent.userName,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                LocalizationString.ringing,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white70, fontWeight: FontWeight.w600),
              )
            ],
          );
  }

  //Timer Ui
  Widget _timerView() => Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: Opacity(
          opacity: 1,
          child: Row(
            children: [
              // SvgPicture.asset(FileConstants.icTimer, width: 12, height: 12),
              const SizedBox(width: 15),
              TimerView(
                key: _timerKey,
              )
            ],
          ),
        ),
      );

  // Ui & UX For Bottom Portion (Switch Camera,Video On/Off,Mic On/Off)
  Widget _bottomPortionWidget() => Container(
        margin: const EdgeInsets.only(bottom: 80, left: 35, right: 25),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
              agoraCallController.declineCall(call: widget.call);
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
