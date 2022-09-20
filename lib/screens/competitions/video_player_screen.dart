import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class VideoPlayerScreen extends StatefulWidget {
  final PostGallery? media;
  final ChatMessageModel? chatMessage;

  const VideoPlayerScreen({Key? key, this.media, this.chatMessage})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    String videoPath = '';
    if (widget.media != null) {
      videoPath = widget.media!.filePath;
    } else {
      videoPath = widget.chatMessage!.mediaContent.video!;
    }

    _controller = VideoPlayerController.network(videoPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 20,
            ).ripple(() {
              Get.back();
            }),
          ],
        ).hP16,
        divider(context: context).vP8,
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
      ],
    ));
  }
}
