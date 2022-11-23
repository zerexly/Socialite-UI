import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class LiveTVStreaming extends StatefulWidget {
  final TvModel tvModel;

  const LiveTVStreaming({Key? key, required this.tvModel}) : super(key: key);

  @override
  State<LiveTVStreaming> createState() => _LiveTVStreamingState();
}

class _LiveTVStreamingState extends State<LiveTVStreaming> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        AutoOrientation.portraitAutoMode();
      } else {
        AutoOrientation.landscapeAutoMode();
      }
    });
  }

  @override
  void dispose() {
    AutoOrientation.portraitAutoMode();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        AutoOrientation.portraitAutoMode();
      } else {
        AutoOrientation.landscapeAutoMode();
      }
      return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
        return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
              children: [
                SocialifiedLiveTvVideoPlayer(
                  tvModel: widget.tvModel,
                  play: false,
                  orientation: orientation,
                  showMinimumHeight: isKeyboardVisible,
                ),
                appBar(orientation)
              ],
            ));
      });
    });
  }

  Widget appBar(Orientation orientation) {
    return Positioned(
      child: SizedBox(
        height: orientation == Orientation.portrait ? 150.0 : 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 20,
              color: Colors.white,
            ).ripple(() {
              Get.back();
            }),
            Text(
              LocalizationString.liveTv,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ).hP16,
      ),
    );
  }
}
