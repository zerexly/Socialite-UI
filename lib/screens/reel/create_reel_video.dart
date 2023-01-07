import 'package:camera/camera.dart';
import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/reel/select_music.dart';
import 'package:get/get.dart';
import '../../main.dart';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({Key? key}) : super(key: key);

  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen>
    with TickerProviderStateMixin {
  CameraController? controller;

  CameraLensDirection lensDirection = CameraLensDirection.back;
  final CreateReelController _createReelController = Get.find();
  AnimationController? animationController;

  @override
  void initState() {
    _initCamera();
    _initAnimation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateReelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initCamera();
    _initAnimation();
  }

  @override
  void dispose() {
    controller!.dispose();
    _createReelController.clear();
    super.dispose();
  }

  _initAnimation() {
    animationController = AnimationController(
        vsync: this,
        duration:
            Duration(seconds: _createReelController.recordingLength.value));
    animationController!.addListener(() {
      setState(() {});
    });
    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        stopRecording();
      }
    });
  }

  _initCamera() async {
    final front =
        cameras.firstWhere((camera) => camera.lensDirection == lensDirection);

    controller = CameraController(front, ResolutionPreset.max,
        enableAudio: _createReelController.croppedAudioFile == null);
    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              controller == null
                  ? Container()
                  : CameraPreview(
                      controller!,
                    ).round(20),
              Positioned(
                left: 16,
                right: 16,
                top: 25,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                                color: Theme.of(context).primaryColor,
                                child:
                                    const ThemeIconWidget(ThemeIcon.close).p4)
                            .circular
                            .ripple(() {
                          Get.back();
                        }),
                        Container(
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  LocalizationString.selectMusic,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ).p8)
                            .circular
                            .ripple(() {
                          Get.bottomSheet(
                            SelectMusic(selectedAudioCallback: (audio) {
                              // print('Audio selected = ${audio.url}');
                              _createReelController.setCroppedAudio(audio);
                              _initCamera();
                            }),
                            isScrollControlled: true,
                            ignoreSafeArea: true,
                          );
                        }),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                left: 16,
                top: 150,
                child: Container(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller == null) {
                            return;
                          }
                          if (controller!.description.lensDirection ==
                              CameraLensDirection.back) {
                            lensDirection = CameraLensDirection.front;
                            _initCamera();
                          } else {
                            lensDirection = CameraLensDirection.back;
                            _initCamera();
                          }
                        },
                        child: Icon(
                          Icons.cameraswitch_outlined,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(() => GestureDetector(
                            onTap: () {
                              if (controller == null) {
                                return;
                              }
                              if (_createReelController.flashSetting.value) {
                                controller!.setFlashMode(FlashMode.off);
                                _createReelController.turnOffFlash();
                              } else {
                                controller!.setFlashMode(FlashMode.always);
                                _createReelController.turnOnFlash();
                              }
                            },
                            child: Icon(
                              _createReelController.flashSetting.value
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(() => GestureDetector(
                            onTap: () {
                              _createReelController.updateRecordingLength(15);
                              _initAnimation();
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _createReelController
                                              .recordingLength.value ==
                                          15
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
                              child: const Center(child: Text('15s')),
                            ),
                          )),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(() => GestureDetector(
                            onTap: () {
                              _createReelController.updateRecordingLength(30);
                              _initAnimation();
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _createReelController
                                              .recordingLength.value ==
                                          30
                                      ? Theme.of(context).primaryColor
                                      : Colors.black),
                              child: const Center(child: Text('30s')),
                            ),
                          ))
                    ],
                  ).setPadding(left: 8, right: 8, top: 12, bottom: 12),
                ).round(20),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              animationController!.forward();
              _recordVideo();
              // _recordVideo();
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: animationController!.value,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                Obx(() => Container(
                      height: 50,
                      width: 50,
                      color: Theme.of(context).primaryColor,
                      child: ThemeIconWidget(
                        _createReelController.isRecording.value
                            ? ThemeIcon.pause
                            : ThemeIcon.play,
                        size: 30,
                      ),
                    ).circular)
              ],
            ),
          ),
        ],
      ),
    );
  }

  _recordVideo() async {
    if (_createReelController.isRecording.value) {
      stopRecording();
    } else {
      startRecording();
    }
  }

  void stopRecording() async {
    final file = await controller!.stopVideoRecording();
    debugPrint('RecordedFile:: ${file.path}');
    _createReelController.stopRecording();
    if (_createReelController.croppedAudioFile != null) {
      _createReelController.stopPlayingAudio();
    }
    _createReelController.isRecording.value = false;
    _createReelController.createReel(
        _createReelController.croppedAudioFile, file);
  }

  void startRecording() async {
    await controller!.prepareForVideoRecording();
    await controller!.startVideoRecording();
    _createReelController.startRecording();
    if (_createReelController.croppedAudioFile != null) {
      _createReelController
          .playAudioFile(_createReelController.croppedAudioFile!);
    }
    // startRecordingTimer();
  }
}
