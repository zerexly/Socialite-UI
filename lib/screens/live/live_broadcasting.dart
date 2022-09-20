import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/live/live_joined_users.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class LiveBroadcastScreen extends StatefulWidget {
  final Live live;

  const LiveBroadcastScreen({Key? key, required this.live}) : super(key: key);

  @override
  State<LiveBroadcastScreen> createState() => _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends State<LiveBroadcastScreen> {
  final AgoraLiveController agoraLiveController = Get.find();

  // final GlobalKey<TimerViewState> _timerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Wakelock.enable(); // Turn on wakelock feature till call is running
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => agoraLiveController.liveEnd.value == false
              ? Stack(
                  children: [
                    Center(
                      child: widget.live.isHosting == true
                          ? _renderLocalPreview()
                          : _renderRemoteVideo(),
                    ),
                    topBar(context),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        children: [messagesListView(), messageComposerView()],
                      ),
                    ),
                    widget.live.isHosting
                        ? _bottomPortionWidget(context)
                        : Container()
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        const ThemeIconWidget(
                          ThemeIcon.close,
                          size: 25,
                          color: Colors.white,
                        ).ripple(() {
                          Get.back();
                        }),
                        const Spacer()
                      ],
                    ),
                    opponentInfo(),
                  ],
                ).hP16,
        ));
  }

  Widget opponentInfo() {
    return Column(
      children: [
        const SizedBox(
          height: 150,
        ),
        UserAvatarView(
          user: agoraLiveController.host!,
          size: 100,
          onTapHandler: () {},
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          agoraLiveController.host!.userName,
          style: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Colors.white70)
              .copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          LocalizationString.liveEnd,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w600)
              .copyWith(color: Colors.white70),
        )
      ],
    );
  }

  Widget messageComposerView() {
    return Container(
      color: Theme.of(context).backgroundColor.withOpacity(0.9),
      height: 70,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: Obx(() => TextField(
                        controller: agoraLiveController.messageTf.value,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white70),
                        maxLines: 50,
                        onChanged: (text) {
                          agoraLiveController.messageChanges();
                        },
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                            hintText: LocalizationString.pleaseEnterMessage),
                      )),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                LocalizationString.send,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).primaryColor)
                    .copyWith(fontWeight: FontWeight.w900),
              ).ripple(() {
                sendMessage();
              }),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ).hP16,
    );
  }

  Widget topBar(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 70,
          child: Row(children: [
            const ThemeIconWidget(
              ThemeIcon.downArrow,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              getIt<UserProfileManager>().user!.userName,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w900)
                  .copyWith(color: Colors.white70),
            ),
            const Spacer(),
            widget.live.isHosting == false
                ? const ThemeIconWidget(
                    ThemeIcon.close,
                    size: 30,
                    color: Colors.white,
                  ).circular.ripple(() {
                    agoraLiveController.onCallEnd(isHost: false);
                  })
                : Container(),
          ]).ripple(() {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return const LiveJoinedUsers();
                });
          }),
        ).hP16,
      ],
    );
  }

  // Generate local preview
  Widget _renderLocalPreview() {
    return Image.asset(
      'assets/dummy.jpg',
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
    // return const rtc_local_view.SurfaceView();
  }

  // Generate remote preview
  Widget _renderRemoteVideo() {
    return Stack(
      children: [
        agoraLiveController.reConnectingRemoteView.value
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
            : agoraLiveController.videoPaused.value
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
                    uid: agoraLiveController.remoteUserId.value,
                    channelId: widget.live.channelName,
                    // channel id need to check
                  ),
      ],
    );
  }

  // Ui & UX For Bottom Portion (Switch Camera,Video On/Off,Mic On/Off)
  Widget _bottomPortionWidget(BuildContext context) => Positioned(
        right: 20,
        bottom: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const ThemeIconWidget(
              ThemeIcon.cameraSwitch,
              size: 30,
              color: Colors.white,
            ).circular.ripple(() {
              agoraLiveController.onToggleCamera();
            }),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ThemeIconWidget(
                  agoraLiveController.mutedVideo.value
                      ? ThemeIcon.videoCameraOff
                      : ThemeIcon.videoCamera,
                  size: 30,
                  color: Colors.white,
                )).circular.ripple(() {
              agoraLiveController.onToggleMuteVideo();
            }),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ThemeIconWidget(
                  agoraLiveController.mutedAudio.value
                      ? ThemeIcon.micOff
                      : ThemeIcon.mic,
                  size: 30,
                  color: Colors.white,
                )).circular.ripple(() {
              agoraLiveController.onToggleMuteAudio();
            }),
            const SizedBox(
              height: 20,
            ),
            const ThemeIconWidget(
              ThemeIcon.close,
              size: 30,
              color: Colors.white,
            ).circular.ripple(() {
              agoraLiveController.onCallEnd(isHost: true);
            }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );

  Widget messagesListView() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Theme.of(context).backgroundColor.withOpacity(0.7),
            Theme.of(context).backgroundColor.withOpacity(0.9)
          ],
        ),
      ),
      child: GetBuilder<AgoraLiveController>(
          init: agoraLiveController,
          builder: (ctx) {
            return ListView.separated(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 50, left: 16, right: 70),
                itemCount: agoraLiveController.messages.length,
                itemBuilder: (ctx, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AvatarView(
                          size: 25,
                          url: agoraLiveController.messages[index].userPicture,
                          name: agoraLiveController.messages[index].userName),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agoraLiveController.messages[index].userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w900)
                                  .copyWith(color: Colors.white70),
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            Text(
                              agoraLiveController
                                  .messages[index].messageContent,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 10,
                  );
                });
          }),
    );
  }

  sendMessage() {
    if (agoraLiveController.messageTf.value.text.removeAllWhitespace
        .trim()
        .isNotEmpty) {
      agoraLiveController
          .sendTextMessage(agoraLiveController.messageTf.value.text);
    }
  }
}
