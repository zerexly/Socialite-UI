import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ReelVideoPlayer extends StatefulWidget {
  final PostModel reel;

  const ReelVideoPlayer({
    Key? key,
    required this.reel,
  }) : super(key: key);

  @override
  State<ReelVideoPlayer> createState() => _ReelVideoPlayerState();
}

class _ReelVideoPlayerState extends State<ReelVideoPlayer> {
  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  late bool playVideo;
  final ReelsController _reelsController = Get.find();

  @override
  void initState() {
    super.initState();
    // playVideo = widget.play;
    prepareVideo(url: widget.reel.gallery.first.filePath);
  }

  @override
  void didUpdateWidget(covariant ReelVideoPlayer oldWidget) {
    playVideo = _reelsController.currentViewingReel.value!.id == widget.reel.id;

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
        FutureBuilder(
          future: initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                key: PageStorageKey(widget.reel.gallery.first.filePath),
                child: Chewie(
                  key: PageStorageKey(widget.reel.gallery.first.filePath),
                  controller: ChewieController(
                    allowFullScreen: false,
                    videoPlayerController: videoPlayerController!,
                    aspectRatio: Get.width / (Get.height - 90),
                    showOptions: false,
                    showControls: false,
                    autoInitialize: true,
                    looping: false,
                    autoPlay: false,

                    // allowMuting: true,
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        Positioned(
            bottom: 25,
            left: 16,
            right: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    UserAvatarView(size: 25, user: widget.reel.user,hideOnlineIndicator: true,),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.reel.user.userName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.reel.title.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        widget.reel.title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                SizedBox(
                    width: Get.width * 0.5,
                    height: 25,
                    child: Row(
                      children: [
                        const ThemeIconWidget(
                          ThemeIcon.music,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          // width: Get.width * 0.5,
                          child: Text(
                            widget.reel.audio == null
                                ? LocalizationString.originalAudio
                                : widget.reel.audio!.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ).ripple(() {
                      if (widget.reel.audio != null) {
                        Get.to(() => ReelAudioDetail(
                              audio: widget.reel.audio!,
                            ));
                      }
                    }))
              ],
            )),
        Positioned(
            bottom: 25,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Obx(() => InkWell(
                        onTap: () {
                          _reelsController.likeUnlikeReel(
                              post: widget.reel, context: context);
                          // widget.likeTapHandler();
                        },
                        child: ThemeIconWidget(
                          _reelsController.likedReels.contains(widget.reel) ||
                              widget.reel.isLike
                              ? ThemeIcon.favFilled
                              : ThemeIcon.fav,
                          color: _reelsController.likedReels
                              .contains(widget.reel) ||
                              widget.reel.isLike
                              ? Theme.of(context).errorColor
                              : Theme.of(context).iconTheme.color,
                        ))),
                    const SizedBox(
                      height: 5,
                    ),
                    Obx(() {
                      int totalLikes = 0;
                      if (_reelsController.likedReels.contains(widget.reel)) {
                        PostModel post = _reelsController.likedReels
                            .where((e) => e.id == widget.reel.id)
                            .first;
                        totalLikes = post.totalLike;
                      } else {
                        totalLikes = widget.reel.totalLike;
                      }
                      return Text('${widget.reel.totalLike}',
                          style: Theme.of(context).textTheme.bodyMedium);
                    }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    const ThemeIconWidget(
                      ThemeIcon.message,
                      size: 25,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.reel.totalComment.formatNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ).ripple(() {
                  openComments();
                }),
                const SizedBox(
                  height: 20,
                ),
                // const ThemeIconWidget(
                //   ThemeIcon.send,
                //   size: 20,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                if (widget.reel.audio != null)
                  CachedNetworkImage(
                      height: 25,
                      width: 25,
                      imageUrl: widget.reel.audio!.thumbnail)
                      .borderWithRadius(context: context, value: 1, radius: 5)
                      .ripple(() {
                    if (widget.reel.audio != null) {
                      Get.to(() => ReelAudioDetail(audio: widget.reel.audio!));
                    }
                  })
              ],
            ))
      ],
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
    videoPlayerController!.play().then((value) => {
          // videoPlayerController!.addListener(checkVideoProgress)
        });
  }

  openComments() {
    Get.bottomSheet(CommentsScreen(
      isPopup: true,
      model: widget.reel,
    ));
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
