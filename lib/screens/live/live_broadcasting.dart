import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'dart:ui';

class LiveBroadcastScreen extends StatefulWidget {
  final Live live;

  const LiveBroadcastScreen({Key? key, required this.live}) : super(key: key);

  @override
  State<LiveBroadcastScreen> createState() => _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends State<LiveBroadcastScreen> {
  final AgoraLiveController _agoraLiveController = Get.find();
  final GiftController _giftController = Get.find();
  final SubscriptionPackageController packageController = Get.find();

  @override
  void initState() {
    super.initState();
    packageController.initiate(context);
    _giftController.loadMostUsedGifts();
    Wakelock.enable(); // Turn on wakelock feature till call is running
  }

  @override
  void dispose() {
    // _agoraLiveController.clear();
    super.dispose();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Obx(
                    () =>
                _agoraLiveController.liveEnd.value == false
                    ? onLiveWidget()
                    : liveEndWidget(),
              ),
            ),
            Obx(() {
              return _agoraLiveController.sendingGift.value == null
                  ? Container()
                  : Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Pulse(
                    duration: const Duration(milliseconds: 500),
                    child: Center(
                      child: Image.network(
                        _agoraLiveController.sendingGift.value!.logo,
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ));
            })
          ],
        ));
  }

  Widget askLiveEndConfirmation() {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Theme
          .of(context)
          .backgroundColor
          .withOpacity(0.8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Column(
          children: [
            const SizedBox(
              height: 400,
            ),
            Text(
              LocalizationString.endLiveCallConfirmation,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.width * 0.4,
                  child: FilledButtonType1(
                    text: LocalizationString.yes,
                    onPress: () {
                      _agoraLiveController.onCallEnd(isHost: true);
                      _agoraLiveController.loadGiftsReceived();
                    },
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.4,
                  child: FilledButtonType1(
                    enabledBackgroundColor: Colors.red,
                    text: LocalizationString.no,
                    enabledTextStyle: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                    onPress: () {
                      _agoraLiveController.dontEndLiveCall();
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ).hP16,
      ),
    );
  }

  Widget onLiveWidget() {
    return Stack(
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
            children: [
              !widget.live.isHosting
                  ? Stack(
                children: [
                  messagesListView(),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: defaultCoinsView()),
                ],
              )
                  : messagesListView(),
              messageComposerView()
            ],
          ),
        ),
        widget.live.isHosting ? _actionWidgetForHostUser(context) : Container(),
        _agoraLiveController.askLiveEndConformation.value == true
            ? Positioned(
            left: 0, right: 0, bottom: 0, child: askLiveEndConfirmation())
            : Container()
      ],
    );
  }

  Widget liveEndWidget() {
    return widget.live.isHosting
        ? liveEndWidgetForHosts()
        : liveEndWidgetForViewers();
  }

  Widget liveEndWidgetForViewers() {
    return Column(
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
              if (widget.live.isHosting) {
                _agoraLiveController.closeLive();
              } else {
                Get.back();
              }
            }),
            const Spacer()
          ],
        ),
        hostUserInfo(),
      ],
    ).hP16;
  }

  Widget liveEndWidgetForHosts() {
    return Column(
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
              if (widget.live.isHosting) {
                _agoraLiveController.closeLive();
              } else {
                Get.back();
              }
            }),
            const Spacer()
          ],
        ).hP16,
        const SizedBox(
          height: 20,
        ),
        Text(LocalizationString.liveEnd,
            style: Theme
                .of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w600)),
        Container(
          height: 5,
          width: 100,
          color: Theme
              .of(context)
              .primaryColor,
        )
            .round(10)
            .tP8,
        const SizedBox(
          height: 40,
        ),
        liveStatisticsInfo().hP16,
        const SizedBox(
          height: 50,
        ),
        Expanded(child: giftersView())
      ],
    );
  }

  Widget liveStatisticsInfo() {
    return Container(
      width: Get.width / 1.4,
      color: Theme
          .of(context)
          .cardColor
          .withOpacity(0.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (Get.width / 1.4) / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${_agoraLiveController.allJoinedUsers.length}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).bP8,
                    Text(
                      LocalizationString.users,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              SizedBox(
                width: (Get.width / 1.4) / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _agoraLiveController.liveTime,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).bP8,
                    Text(
                      LocalizationString.duration,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (Get.width / 1.4) / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${_agoraLiveController.giftsReceived.length}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).bP8,
                    Text(
                      LocalizationString.gifts,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: (Get.width / 1.4) / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _agoraLiveController.totalCoinsEarned.toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).bP8,
                    Text(
                      LocalizationString.coinsEarned,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ).p16,
    ).round(20);
  }

  Widget hostUserInfo() {
    return Column(
      children: [
        const SizedBox(
          height: 150,
        ),
        UserAvatarView(
          user: widget.live.isHosting
              ? getIt<UserProfileManager>().user!
              : _agoraLiveController.host!,
          hideLiveIndicator: _agoraLiveController.liveEnd.value == true,
          size: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.live.isHosting
              ? getIt<UserProfileManager>().user!.userName
              : _agoraLiveController.host!.userName,
          style: Theme
              .of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white70)
              .copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(LocalizationString.liveEnd,
            style: Theme
                .of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget messageComposerView() {
    return Container(
      // color: Theme.of(context).backgroundColor.withOpacity(0.9),
      color: Colors.black,

      height: 70,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  color: Theme
                      .of(context)
                      .cardColor,
                  child: Obx(() =>
                      TextField(
                        controller: _agoraLiveController.messageTf.value,
                        textAlign: TextAlign.start,
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Colors.white),
                        maxLines: 50,
                        onChanged: (text) {
                          _agoraLiveController.messageChanges();
                        },
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5),
                            labelStyle: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            hintStyle: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                            hintText: LocalizationString.pleaseEnterMessage),
                      )),
                ).round(10),
              ),
              const SizedBox(
                width: 20,
              ),
              const ThemeIconWidget(ThemeIcon.send, size: 20).ripple(() {
                sendMessage();
              }),
              if (widget.live.isHosting == false)
                const SizedBox(
                  width: 20,
                ),
              if (widget.live.isHosting == false)
                Container(
                  height: 40,
                  width: 40,
                  color: Theme
                      .of(context)
                      .primaryColor,
                  child: const ThemeIconWidget(
                    ThemeIcon.diamond,
                    color: Colors.yellow,
                    size: 25,
                  ),
                ).circular.ripple(() {
                  showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      enableDrag: true,
                      isDismissible: true,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                            heightFactor: 0.8,
                            child:
                            GiftsPageView(giftSelectedCompletion: (gift) {
                              Get.back();
                              _agoraLiveController.sendGift(gift, context);
                            }));
                      });
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
              LocalizationString.joinedUsers,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w900)
                  .copyWith(color: Colors.white70),
            ),
            const Spacer(),
            widget.live.isHosting == false
                ? const ThemeIconWidget(
              ThemeIcon.close,
              size: 25,
              color: Colors.white,
            ).circular.ripple(() {
              _agoraLiveController.onCallEnd(isHost: false);
            })
                : Image.asset(
              'assets/live.png',
              height: 30,
            ),
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
    return Obx(() =>
    _agoraLiveController.mutedVideo.value
        ? Container(
        color: Theme
            .of(context)
            .errorColor,
        child: Center(
            child: Text(
              LocalizationString.videoPaused,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.white70),
            )))
        : const rtc_local_view.SurfaceView());
  }

  // Generate remote preview
  Widget _renderRemoteVideo() {
    return Stack(
      children: [
        _agoraLiveController.reConnectingRemoteView.value
            ? Container(
            color: Theme
                .of(context)
                .errorColor,
            child: Center(
                child: Text(
                  LocalizationString.reConnecting,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white70),
                )))
            : _agoraLiveController.videoPaused.value
            ? Container(
            color: Theme
                .of(context)
                .primaryColor,
            child: Center(
                child: Text(
                  LocalizationString.videoPaused,
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.white70),
                )))
            : rtc_remote_view.SurfaceView(
          uid: _agoraLiveController.remoteUserId.value,
          channelId: widget.live.channelName,
          // channel id need to check
        ),
      ],
    );
  }

  // Ui & UX For Bottom Portion (Switch Camera,Video On/Off,Mic On/Off)
  Widget _actionWidgetForHostUser(BuildContext context) =>
      Positioned(
        right: 0,
        bottom: (widget.live.isHosting) ? 100 : 120,
        child: SizedBox(
          width: 60,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(() =>
              _agoraLiveController.giftsReceived.isEmpty
                  ? Container()
                  : Container(
                color: Theme
                    .of(context)
                    .primaryColor,
                child: Column(
                  children: [
                    const ThemeIconWidget(
                      ThemeIcon.diamond,
                      size: 20,
                      color: Colors.white,
                    ).circular.ripple(() {
                      _agoraLiveController.onToggleCamera();
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _agoraLiveController.totalCoinsEarned.formatNumber
                          .toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                ).p8,
              ).round(15)),
              const SizedBox(
                height: 20,
              ),
              const ThemeIconWidget(
                ThemeIcon.cameraSwitch,
                size: 30,
                color: Colors.white,
              ).circular.ripple(() {
                _agoraLiveController.onToggleCamera();
              }),
              const SizedBox(
                height: 20,
              ),
              Obx(() =>
                  ThemeIconWidget(
                    _agoraLiveController.mutedVideo.value
                        ? ThemeIcon.videoCameraOff
                        : ThemeIcon.videoCamera,
                    size: 30,
                    color: Colors.white,
                  )).circular.ripple(() {
                _agoraLiveController.onToggleMuteVideo();
              }),
              const SizedBox(
                height: 20,
              ),
              Obx(() =>
                  ThemeIconWidget(
                    _agoraLiveController.mutedAudio.value
                        ? ThemeIcon.micOff
                        : ThemeIcon.mic,
                    size: 30,
                    color: Colors.white,
                  )).circular.ripple(() {
                _agoraLiveController.onToggleMuteAudio();
              }),
              const SizedBox(
                height: 20,
              ),
              const ThemeIconWidget(
                ThemeIcon.close,
                size: 30,
                color: Colors.white,
              ).circular.ripple(() {
                _agoraLiveController.askConfirmationForEndCall();
              }),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      );

  Widget messagesListView() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height / 2.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.9)
          ],
        ),
      ),
      child: GetBuilder<AgoraLiveController>(
          init: _agoraLiveController,
          builder: (ctx) {
            return ListView.separated(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 50, left: 16, right: 70),
                itemCount: _agoraLiveController.messages.length,
                itemBuilder: (ctx, index) {
                  ChatMessageModel message =
                  _agoraLiveController.messages[index];
                  if (message.messageContentType == MessageContentType.gift) {
                    return giftMessageTile(message);
                  }
                  return textMessageTile(message);
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(
                    height: 10,
                  );
                });
          }),
    );
  }

  Widget textMessageTile(ChatMessageModel message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarView(size: 25, url: message.userPicture, name: message.userName),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.userName,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700)
                    .copyWith(color: Colors.white70),
              ),
              Text(
                message.messageContent,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white70),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget giftMessageTile(ChatMessageModel message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarView(size: 25, url: message.userPicture, name: message.userName),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.userName,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w700)
                    .copyWith(color: Colors.white70),
              ),
              Row(
                children: [
                  Text(
                    LocalizationString.sentAGift,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CachedNetworkImage(
                    imageUrl: message.giftContent.image,
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    message.giftContent.coins.toString(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget defaultCoinsView() {
    return SizedBox(
      height: 60,
      child: Obx(() =>
          ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _giftController.topGifts.length,
              itemBuilder: (ctx, index) {
                return giftBox(_giftController.topGifts[index]).ripple(() {
                  _agoraLiveController.sendGift(
                      _giftController.topGifts[index], context);
                });
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  width: 15,
                );
              })),
    );
  }

  Widget giftBox(GiftModel gift) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          gift.logo,
          height: 30,
          width: 30,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThemeIconWidget(
              ThemeIcon.diamond,
              size: 18,
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              gift.coins.toString(),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,
            ),
          ],
        )
      ],
    ).round(10);
  }

  Widget giftersView() {
    return Column(
      children: [
        Text(
          LocalizationString.giftsReceived,
          style: Theme
              .of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        Container(
          height: 5,
          width: 180,
          color: Theme
              .of(context)
              .primaryColor,
        )
            .round(10)
            .tP8,
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Container(
            color: Theme
                .of(context)
                .cardColor
                .darken(0.08),
            child: ListView.separated(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 25, bottom: 100),
                itemCount: _agoraLiveController.giftsReceived.length,
                itemBuilder: (ctx, index) {
                  return GifterUserTile(
                    gift: _agoraLiveController.giftsReceived[index],
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox(height: 15);
                }),
          ).topRounded(50),
        ),
      ],
    );
  }

  sendMessage() {
    if (_agoraLiveController.messageTf.value.text.removeAllWhitespace
        .trim()
        .isNotEmpty) {
      _agoraLiveController
          .sendTextMessage(_agoraLiveController.messageTf.value.text);
    }
  }
}
