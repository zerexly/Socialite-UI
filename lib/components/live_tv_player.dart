import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SocialifiedLiveTvVideoPlayer extends StatefulWidget {
  final TvModel tvModel;
  final String videoUrl;

  final bool play;
  final Orientation orientation;
  final bool showMinimumHeight;

  const SocialifiedLiveTvVideoPlayer({
    Key? key,
    required this.play,
    required this.orientation,
    required this.tvModel,
    required this.videoUrl,
    required this.showMinimumHeight,
  }) : super(key: key);

  @override
  State<SocialifiedLiveTvVideoPlayer> createState() =>
      _SocialifiedLiveTvVideoPlayerState();
}

class _SocialifiedLiveTvVideoPlayerState
    extends State<SocialifiedLiveTvVideoPlayer> {
  final TvStreamingController _liveTvStreamingController = Get.find();
  TextEditingController messageTextField = TextEditingController();
  SettingsController settingsController = Get.find();

  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  bool isFreeTimePlayed = false;
  late bool playVideo;

  @override
  void initState() {
    super.initState();
    playVideo = widget.play;
    prepareVideo(url: widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant SocialifiedLiveTvVideoPlayer oldWidget) {
    prepareVideo(url: widget.videoUrl);

    playVideo = widget.play;

    if (playVideo == true) {
      play();
    } else {
      pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 250,
      child: Stack(
        children: [
          FutureBuilder(
            future: initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Container(
                      key: PageStorageKey(widget.tvModel.tvUrl),
                      child: Chewie(
                        key: PageStorageKey(widget.tvModel.tvUrl),
                        controller: ChewieController(
                          allowFullScreen: false,
                          // fullScreenByDefault: true,
                          // isLive: true,
                          videoPlayerController: videoPlayerController!,
                          aspectRatio: videoPlayerController!.value.aspectRatio,
                          // showControls: !isFreeTimePlayed,
                          showOptions: true,
                          // Prepare the video to be played and display the first frame
                          autoInitialize: true,
                          looping: false,
                          autoPlay: false,

                          allowMuting: true,
                          // Errors can occur for example when trying to play a video
                          // from a non-existent URL
                          errorBuilder: (context, errorMessage) {
                            return Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          if (isFreeTimePlayed && widget.tvModel.isLocked)
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        LocalizationString.subscribeChannelToView,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        width: 250,
                        child: FilledButtonType1(
                          text:
                              '${LocalizationString.subscribeUsing} (${widget.tvModel.coinsNeededToUnlock} ${LocalizationString.coins})',
                          onPress: () {
                            _liveTvStreamingController
                                .subscribeTv(widget.tvModel, (status) {
                              if (status == true) {
                                setState(() {
                                  widget.tvModel.isSubscribed = 1;
                                  isFreeTimePlayed = false;

                                  AppUtil.showToast(
                                      context: context,
                                      message: LocalizationString
                                          .youAreSubscribedNow,
                                      isSuccess: true);

                                  play();
                                });
                              }
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ))
        ],
      ),
    );
  }

  prepareVideo({required String url}) {
    print('1');
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
    }

    videoPlayerController = VideoPlayerController.network(url);

    print(url);
    initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
      setState(() {});

      print('2');

      if (playVideo == true) {
        print('3');

        play();
      } else {
        print('4');

        pause();
      }
    });

    videoPlayerController!.addListener(checkVideoProgress);
  }

  void checkVideoProgress() {
    if (videoPlayerController!.value.position ==
        const Duration(seconds: 0, minutes: 0, hours: 0)) {}

    if (widget.tvModel.isLocked == true &&
        videoPlayerController!.value.position >=
            Duration(
                seconds: int.parse(settingsController
                    .setting.value!.freeLiveTvDurationToView!))) {
      if (!mounted) return;
      pause();
      isFreeTimePlayed = true;
      videoPlayerController!.removeListener(checkVideoProgress);
    }
    // if (videoPlayerController!.value.position ==
    //         videoPlayerController!.value.duration &&
    //     videoPlayerController!.value.duration >
    //         const Duration(milliseconds: 1)) {
    //   if (!mounted) return;
    //
    //   setState(() {
    //     videoPlayerController!.removeListener(checkVideoProgress);
    //
    //     isFreeTimePlayed = true;
    //   });
    // }
  }

  play() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isFreeTimePlayed = false;
        playVideo = true;
      });
    });
    print('playing');
    videoPlayerController!.play().then((value) => {
          // videoPlayerController!.addListener(checkVideoProgress)
        });

    // if (widget.liveTvId != null) {
    _liveTvStreamingController.joinTv(widget.tvModel.id);
    // }

    // if (isMute) {
    //   videoPlayerController!.setVolume(0);
    // }
  }

  pause() {
    videoPlayerController!.pause();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // isFreeTimePlayed = true;
      });
    });
  }

  clear() {
    videoPlayerController!.pause();
    videoPlayerController!.dispose();
    // videoPlayerController!.removeListener(checkVideoProgress);
  }
}

class SocialifiedVideoPlayer extends StatefulWidget {
  final String url;
  final bool play;
  final int? liveTvId;
  final Orientation orientation;

  const SocialifiedVideoPlayer({
    Key? key,
    required this.url,
    required this.play,
    required this.orientation,
    this.liveTvId,
  }) : super(key: key);

  @override
  State<SocialifiedVideoPlayer> createState() => _SocialifiedVideoPlayerState();
}

class _SocialifiedVideoPlayerState extends State<SocialifiedVideoPlayer> {
  final TvStreamingController _liveTvStreamingController = Get.find();
  TextEditingController messageTextField = TextEditingController();

  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  bool isPlayed = false;
  late bool playVideo;

  @override
  void initState() {
    super.initState();
    playVideo = widget.play;
    prepareVideo(url: widget.url);
  } // This closing tag was missing

  @override
  void didUpdateWidget(covariant SocialifiedVideoPlayer oldWidget) {
    playVideo = widget.play;

    if (playVideo == true) {
      play();
    } else {
      pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: widget.orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 2
              : MediaQuery.of(context).size.height,
          child: FutureBuilder(
            future: initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    Container(
                      key: PageStorageKey(widget.url),
                      child: Chewie(
                        key: PageStorageKey(widget.url),
                        controller: ChewieController(
                          allowFullScreen: false,
                          // fullScreenByDefault: true,
                          isLive: true,
                          videoPlayerController: videoPlayerController!,
                          aspectRatio: videoPlayerController!.value.aspectRatio,
                          showControls: true,
                          showOptions: false,
                          // Prepare the video to be played and display the first frame
                          autoInitialize: true,
                          looping: false,
                          autoPlay: false,

                          allowMuting: true,
                          // Errors can occur for example when trying to play a video
                          // from a non-existent URL
                          errorBuilder: (context, errorMessage) {
                            return Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        // const Spacer(),
        liveChatView()
      ],
    );
  }

  Widget liveChatView() {
    return widget.liveTvId != null
        ? Column(
            children: [
              const Spacer(),
              Obx(() =>
                  _liveTvStreamingController.showChatMessages.value == false
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Theme.of(context).primaryColor,
                            child: const ThemeIconWidget(
                              ThemeIcon.chat,
                              size: 25,
                            ),
                          ).circular.ripple(() {
                            _liveTvStreamingController.showMessagesView();
                          }).setPadding(bottom: 20, right: 16),
                        )
                      : Column(
                          children: [messagesListView(), messageComposerView()],
                        )),
            ],
          )
        : Container();
  }

  Widget messagesListView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        children: [
          // Container(
          //   height: 70,
          //   color: Theme.of(context).cardColor,
          //   child: Row(
          //     children: [
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Live chat',
          //             style: Theme.of(context)
          //                 .textTheme
          //                 .titleLarge!
          //                 .copyWith(fontWeight: FontWeight.w700),
          //           ),
          //           // Text('200K users',
          //           //     style: Theme.of(context).textTheme.bodySmall)
          //         ],
          //       ),
          //       const Spacer(),
          //       const ThemeIconWidget(
          //         ThemeIcon.close,
          //         size: 25,
          //       ).ripple(() {
          //         _liveTvStreamingController.hideMessagesView();
          //       }),
          //     ],
          //   ).p16,
          // ).topRounded(20),
          // const Spacer(),
          Expanded(
            child: GetBuilder<TvStreamingController>(
                init: _liveTvStreamingController,
                builder: (ctx) {
                  List<ChatMessageModel> messages = (_liveTvStreamingController
                          .messagesMap[widget.liveTvId.toString()] ??
                      []);
                  return ListView.separated(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 50, left: 16, right: 70),
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          color: Theme.of(context).cardColor.withOpacity(0.5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AvatarView(
                                  size: 25,
                                  url: messages[index].userPicture,
                                  name: messages[index].userName),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messages[index].userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(fontWeight: FontWeight.w900)
                                          .copyWith(color: Colors.white70),
                                    ),
                                    Text(
                                      messages[index].messageContent,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).p8,
                        ).round(10);
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  sendMessage(int liveTvId) {
    if (messageTextField.text.removeAllWhitespace.trim().isNotEmpty) {
      _liveTvStreamingController.sendTextMessage(
          messageTextField.text, liveTvId);
      messageTextField.text = '';
      _liveTvStreamingController.showMessagesView();
    }
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
                  color: Theme.of(context).cardColor.withOpacity(0.8),
                  child: TextField(
                    controller: messageTextField,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                    maxLines: 50,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.only(left: 10, right: 10, top: 5),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).primaryColor),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                        hintText: LocalizationString.pleaseEnterMessage),
                  ),
                ).round(10),
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
                sendMessage(widget.liveTvId!);
              }),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 40,
                width: 40,
                color: Theme.of(context).primaryColor,
                child: const ThemeIconWidget(
                  ThemeIcon.close,
                  size: 25,
                ),
              ).circular.ripple(() {
                _liveTvStreamingController.hideMessagesView();
              })
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ).hP16,
    );
  }

  prepareVideo({required String url}) {
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
    }

    videoPlayerController = VideoPlayerController.network(url);

    initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
      setState(() {});

      if (playVideo == true) {
        play();
      } else {
        pause();
      }
    });

    // videoPlayerController!.addListener(checkVideoProgress);
  }

  play() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isPlayed = false;
        playVideo = true;
      });
    });
    videoPlayerController!.play().then((value) => {
          // videoPlayerController!.addListener(checkVideoProgress)
        });

    if (widget.liveTvId != null) {
      _liveTvStreamingController.joinTv(widget.liveTvId!);
    }

    // if (isMute) {
    //   videoPlayerController!.setVolume(0);
    // }
  }

  pause() {
    videoPlayerController!.pause();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isPlayed = true;
      });
    });
  }

  clear() {
    videoPlayerController!.pause();
    videoPlayerController!.dispose();
    // videoPlayerController!.removeListener(checkVideoProgress);
  }
}
