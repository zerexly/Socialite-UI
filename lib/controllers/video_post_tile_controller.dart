import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class VideoPostTileController extends GetxController {
  late Future<void> initializeVideoPlayerFuture;
  late VideoPlayerController videoPlayerController;
  RxList<String> videoPlayed = <String>[].obs;
  late String videoUrl;

  prepareVideo({required String url, required bool isLocalFile}) {
    videoUrl = url;
    videoPlayed.add(videoUrl);
    update();
    if (isLocalFile) {
      videoPlayerController = VideoPlayerController.file(File(url));
    } else {
      videoPlayerController = VideoPlayerController.network(url);
    }

    initializeVideoPlayerFuture =
        videoPlayerController.initialize().then((_) {
          videoPlayed.remove(videoUrl);
          update();
        });

    videoPlayerController.addListener(checkVideoProgress);
  }

  play() {
    videoPlayed.remove(videoUrl);
    update();
    videoPlayerController.play();
  }

  pause() {
    videoPlayerController.pause();
  }

  clear() {
    videoPlayerController.dispose();
  }

  void checkVideoProgress() {
    // Implement your calls inside these conditions' bodies :
    if (videoPlayerController.value.position ==
        const Duration(seconds: 0, minutes: 0, hours: 0)) {}

    if (videoPlayerController.value.position ==
        videoPlayerController.value.duration) {
      if (!videoPlayed.contains(videoUrl)) {
        videoPlayed.add(videoUrl);
        update();
      }
    }
  }
}
