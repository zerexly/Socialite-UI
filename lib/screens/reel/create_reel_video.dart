import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/reel/select_music.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({Key? key}) : super(key: key);

  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen> {
  CameraController? controller;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    // _initCamera();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    controller = CameraController(front, ResolutionPreset.max);
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
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          // CameraPreview(controller!),
          Positioned(
            left: 16,
            right: 16,
            top: 70,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                            color: Theme.of(context).primaryColor,
                            child: const ThemeIconWidget(ThemeIcon.close).p4)
                        .circular
                        .ripple(() {
                      Get.back();
                    }),
                    Container(
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'Select music',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ).p8)
                        .circular
                        .ripple(() {
                      Get.bottomSheet(
                        SelectMusic(selectedAudioCallback: (audio) {
                          print('Audio selected = ${audio.url}');
                        }),
                        isScrollControlled: true,
                        ignoreSafeArea: true,
                      );
                    }),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await controller!.stopVideoRecording();
      setState(() => _isRecording = false);
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => VideoPage(filePath: file.path),
      // );
      // Navigator.push(context, route);
    } else {
      await controller!.prepareForVideoRecording();
      await controller!.startVideoRecording();
      // setState(() => _isRecording = true);
    }
  }
}
