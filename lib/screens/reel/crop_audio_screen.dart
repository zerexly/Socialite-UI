import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class CropAudioScreen extends StatefulWidget {
  final ReelMusicModel reelMusicModel;

  const CropAudioScreen({Key? key, required this.reelMusicModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CropAudioState();
  }
}

class _CropAudioState extends State<CropAudioScreen> {
  final CreateReelController _createReelController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createReelController.playAudioFileUntil(
          widget.reelMusicModel,
          _createReelController.audioStartTime ?? 0,
          _createReelController.audioEndTime ?? 0);
    });

    super.initState();
  }

  @override
  void dispose() {
    _createReelController.stopPlayingAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(children: [
        Row(
          children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 25,
            ).ripple(() {
              _createReelController.stopPlayingAudio();
              Get.back();
            }),
            const SizedBox(
              width: 10,
            ),
          ],
        ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Obx(
            () => SizedBox(
              height: 80,
              width: Get.width * 0.8,
              child: WaveSlider(
                positionTextColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.transparent,
                heightWaveSlider: 30,
                widthWaveSlider: Get.width * 0.8,
                sliderColor: Colors.cyan,
                duration: widget.reelMusicModel.duration.toDouble(),
                cutterDuration:
                    _createReelController.recordingLength.toDouble(),
                callbackEnd: (startDuration, endDuration) {
                  debugPrint("Start $startDuration End  $endDuration");
                  _createReelController.setAudioCropperTime(
                      startDuration, endDuration);
                  // this.startDuration = startDuration;
                  // this.endDuration = endDuration;
                  _createReelController.stopPlayingAudio();
                  _createReelController.playAudioFileUntil(
                      widget.reelMusicModel, startDuration, endDuration);
                },
                callbackStart: (double duration, double endDuration) {},
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    LocalizationString.use,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ).p8)
              .circular
              .ripple(() {
            _createReelController.trimAudio();
          }),
        )
      ]),
    );
  }
}
