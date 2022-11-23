import 'dart:math';
import 'package:foap/helper/common_import.dart';

bool isMute = false;

class VideoPostTile extends StatefulWidget {
  final String url;
  final bool isLocalFile;
  final bool play;

  const VideoPostTile(
      {Key? key,
      required this.url,
      required this.isLocalFile,
      required this.play})
      : super(key: key);

  @override
  State<VideoPostTile> createState() => _VideoPostTileState();
}

class _VideoPostTileState extends State<VideoPostTile> {
  // final VideoPostTileController videoPostTileController = Get.find();
  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  bool isPlayed = false;
  late bool playVideo;

  @override
  void initState() {
    super.initState();
    playVideo = widget.play;
    prepareVideo(url: widget.url, isLocalFile: widget.isLocalFile);
  } // This closing tag was missing

  @override
  void didUpdateWidget(covariant VideoPostTile oldWidget) {
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
    // print('VideoPostTileState dispose');
    clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: min(
              (MediaQuery.of(context).size.width - 32) /
                  videoPlayerController!.value.aspectRatio,
              MediaQuery.of(context).size.height * 0.5),
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
                          videoPlayerController: videoPlayerController!,
                          aspectRatio: videoPlayerController!.value.aspectRatio,
                          showControls: false,
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
        isPlayed == true || playVideo == false
            ? Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  height: min(
                      (MediaQuery.of(context).size.width - 32) /
                          videoPlayerController!.value.aspectRatio,
                      MediaQuery.of(context).size.height * 0.5),
                  color: Colors.black38,
                  child: const ThemeIconWidget(
                    ThemeIcon.play,
                    size: 50,
                    color: Colors.white,
                  ),
                ).ripple(() {
                  play();
                }))
            : Container(),
        // Positioned(
        //     right: 10,
        //     bottom: 10,
        //     child: Container(
        //       height: 25,
        //       width: 25,
        //       color: Colors.black38,
        //       child: const ThemeIconWidget(
        //         ThemeIcon.fullScreen,
        //         size: 15,
        //         color: Colors.white,
        //       ),
        //     ).circular.ripple(() {
        //       openFullScreen();
        //     })),
        Positioned(
            right: 10,
            bottom: 10,
            child: Container(
              height: 25,
              width: 25,
              color: Colors.black38,
              child: ThemeIconWidget(
                isMute ? ThemeIcon.micOff : ThemeIcon.mic,
                size: 15,
                color: Colors.white,
              ),
            ).circular.ripple(() {
              if (isMute == true) {
                unMuteAudio();
              } else {
                muteAudio();
              }
            })),
      ],
    );
  }

  prepareVideo({required String url, required bool isLocalFile}) {
    // print('prepareVideo ');

    if (videoPlayerController != null) {
      // print('prepareVideo 1');

      videoPlayerController!.pause();
    }
    // print('prepareVideo 2');

    if (isLocalFile) {
      // print('prepareVideo 3');

      videoPlayerController = VideoPlayerController.file(File(url));
    } else {
      // print('prepareVideo 4');

      videoPlayerController = VideoPlayerController.network(url);
    }

    // print('prepareVideo 5');
    initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
      // videoPlayed.remove(videoUrl);
      // update();
      setState(() {});
      // print('prepareVideo 6');

    });

    videoPlayerController!.addListener(checkVideoProgress);
    // print('prepareVideo 7');

    // });
  }

  openFullScreen() {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return FullScreenVideoPostTile(
              videoPlayerController: videoPlayerController!);
        },
        fullscreenDialog: true));
  }

  unMuteAudio() {
    videoPlayerController!.setVolume(1);
    setState(() {
      isMute = false;
    });
  }

  muteAudio() {
    videoPlayerController!.setVolume(0);
    setState(() {
      isMute = true;
    });
  }

  play() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isPlayed = false;
        playVideo = true;
      });
    });
    videoPlayerController!.play().then(
        (value) => {videoPlayerController!.addListener(checkVideoProgress)});

    if (isMute) {
      videoPlayerController!.setVolume(0);
    }
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
    videoPlayerController!.removeListener(checkVideoProgress);
  }

  void checkVideoProgress() {
    if (videoPlayerController!.value.position ==
        const Duration(seconds: 0, minutes: 0, hours: 0)) {}

    if (videoPlayerController!.value.position ==
            videoPlayerController!.value.duration &&
        videoPlayerController!.value.duration >
            const Duration(milliseconds: 1)) {
      if (!mounted) return;

      setState(() {
        videoPlayerController!.removeListener(checkVideoProgress);

        isPlayed = true;
      });
    }
  }
}

class FullScreenVideoPostTile extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const FullScreenVideoPostTile({
    Key? key,
    required this.videoPlayerController,
  }) : super(key: key);

  @override
  State<FullScreenVideoPostTile> createState() =>
      _FullScreenVideoPostTileState();
}

class _FullScreenVideoPostTileState extends State<FullScreenVideoPostTile> {
  // final VideoPostTileController videoPostTileController = Get.find();
  late Future<void> initializeVideoPlayerFuture;
  bool isPlayed = false;

  @override
  void initState() {
    super.initState();
  } // This closing tag was missing

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: double.infinity,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 20,
            ).ripple(() {
              Navigator.of(context).pop();
            }),
          ),
        ).hP16,
        Expanded(
          key: UniqueKey(),
          child: Chewie(
            key: UniqueKey(),
            controller: ChewieController(
              videoPlayerController: widget.videoPlayerController,
              aspectRatio: widget.videoPlayerController.value.aspectRatio,
              showControls: false,
              // Prepare the video to be played and display the first frame
              autoInitialize: true,
              looping: false,
              autoPlay: false,

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
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
