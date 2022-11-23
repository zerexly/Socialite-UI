import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class VoiceRecord extends StatefulWidget {
  final Function(Media) recordingCallback;

  const VoiceRecord({Key? key, required this.recordingCallback})
      : super(key: key);

  @override
  State<VoiceRecord> createState() => _VoiceRecordState();
}

class _VoiceRecordState extends State<VoiceRecord> {
  late final RecorderController recorderController;

  bool isRecorded = false;

  String? recordingPath;

  @override
  void initState() {
    recorderController = RecorderController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startRecording();
    });
    super.initState();
  }

  startRecording() async {
    await recorderController.record();
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          height: 200,
          color: Theme.of(context).backgroundColor,
          child: AudioWaveforms(
            size: const Size(double.infinity, 200.0),
            recorderController: recorderController,
          ),
        ).round(20).p16,
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: ThemeIconWidget(
                    isRecorded == true ? ThemeIcon.send : ThemeIcon.stop,
                    color: Theme.of(context).iconTheme.color,
                    size: 25,
                  ),
                ),
              ).circular.ripple(() {
                setState(() {
                  if (isRecorded == true) {
                    sendRecording();
                  } else {
                    stopRecording();
                    isRecorded = true;
                  }
                });
              }),
              const SizedBox(
                width: 50,
              ),
              Container(
                height: 50,
                width: 50,
                color: Theme.of(context).backgroundColor,
                child: Center(
                  child: ThemeIconWidget(
                    ThemeIcon.close,
                    color: Theme.of(context).iconTheme.color,
                    size: 25,
                  ),
                ),
              ).circular.ripple(() {
                Get.back();
              })
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  stopRecording() async {
    recordingPath = await recorderController.stop();
    recordingPath = recordingPath?.replaceAll('file://', '');
  }

  sendRecording() {
    File file = File(recordingPath!);
    Uint8List data = file.readAsBytesSync();

    if (recordingPath != null) {
      Media media = Media(
        file: File(recordingPath!),
        fileSize: data.length,
        id: randomId(),
        creationTime: DateTime.now(),
        mediaType: GalleryMediaType.audio,
      );
      widget.recordingCallback(media);
    }
    Get.back();
  }
}
