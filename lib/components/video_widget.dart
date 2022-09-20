import 'dart:math';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

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
  final VideoPostTileController videoPostTileController = Get.find();

  @override
  void initState() {
    super.initState();
    videoPostTileController.prepareVideo(
        url: widget.url, isLocalFile: widget.isLocalFile);
  } // This closing tag was missing

  @override
  void didUpdateWidget(covariant VideoPostTile oldWidget) {
    videoPostTileController.prepareVideo(
        url: widget.url, isLocalFile: widget.isLocalFile);

    if (widget.play == true) {
      videoPostTileController.play();
    } else {
      videoPostTileController.pause();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    videoPostTileController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPostTileController>(
        init: videoPostTileController,
        builder: (ctx) {
          return SizedBox(
            height: min(
                (MediaQuery.of(context).size.width - 32) /
                    videoPostTileController
                        .videoPlayerController.value.aspectRatio,
                MediaQuery.of(context).size.height * 0.5),
            child: FutureBuilder(
              future: videoPostTileController.initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Container(
                        key: PageStorageKey(widget.url),
                        child: Chewie(
                          key: PageStorageKey(widget.url),
                          controller: ChewieController(
                            videoPlayerController:
                                videoPostTileController.videoPlayerController,
                            aspectRatio: videoPostTileController
                                .videoPlayerController.value.aspectRatio,
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
                      videoPostTileController.videoPlayed.contains(widget.url)
                          ? Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              top: 0,
                              child: Container(
                                height: min(
                                    (MediaQuery.of(context).size.width - 32) /
                                        videoPostTileController
                                            .videoPlayerController.value.aspectRatio,
                                    MediaQuery.of(context).size.height * 0.5),
                                color: Colors.black38,
                                child: const ThemeIconWidget(
                                  ThemeIcon.play,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ).ripple(() {
                                videoPostTileController.play();
                              }))
                          : Container()
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        });
  }
}
