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
    return SizedBox(
      // duration: const Duration(milliseconds: 500),
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [
          FutureBuilder(
            future: initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  key: PageStorageKey(widget.reel.gallery.first.filePath),
                  child: Chewie(
                    key: PageStorageKey(widget.reel.gallery.first.filePath),
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
                      UserAvatarView(size: 25, user: widget.reel.user),
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
                            child: Marquee(
                              text:
                                  'There once was a boy who told this story about a boy: "',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ))
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
                      ThemeIconWidget(
                        widget.reel.isLike
                            ? ThemeIcon.favFilled
                            : ThemeIcon.fav,
                        size: 25,
                        color: widget.reel.isLike
                            ? Theme.of(context).errorColor
                            : Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.reel.totalLike.formatNumber,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const ThemeIconWidget(
                    ThemeIcon.send,
                    size: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CachedNetworkImage(
                          height: 25,
                          width: 25,
                          imageUrl: widget.reel.gallery.first.thumbnail())
                      .borderWithRadius(context: context, value: 1, radius: 5)
                ],
              ))
        ],
      ),
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
