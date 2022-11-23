import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class VideoPostTileController extends GetxController {
  late Future<void> initializeVideoPlayerFuture;
  VideoPlayerController? videoPlayerController;
  RxList<String> videoPlayed = <String>[].obs;
  late String videoUrl;

  // prepareVideo({required String url, required bool isLocalFile}) {
  //   videoUrl = url;
  //   // videoPlayed.add(videoUrl);
  //   // update();
  //
  //   // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //   //   await videoPlayerController.dispose();
  //
  //   if (videoPlayerController != null) {
  //     videoPlayerController!.pause();
  //   }
  //   if (isLocalFile) {
  //     print('play video ${url}');
  //     videoPlayerController = VideoPlayerController.file(File(url));
  //   } else {
  //     print('play video ${url}');
  //     videoPlayerController = VideoPlayerController.network(url);
  //   }
  //
  //   initializeVideoPlayerFuture = videoPlayerController!.initialize().then((_) {
  //     videoPlayed.remove(videoUrl);
  //     // update();
  //   });
  //
  //   videoPlayerController!.addListener(checkVideoProgress);
  //   // });
  // }
  //
  // play() {
  //   videoPlayed.remove(videoUrl);
  //   // update();
  //   videoPlayerController!.play();
  // }
  //
  // pause() {
  //   videoPlayerController!.pause();
  // }
  //
  // clear() {
  //   videoPlayerController!.dispose();
  //   videoPlayerController!.removeListener(checkVideoProgress);
  // }
  //
  // void checkVideoProgress() {
  //   if (videoPlayerController!.value.position ==
  //       const Duration(seconds: 0, minutes: 0, hours: 0)) {}
  //
  //   if (videoPlayerController!.value.position ==
  //       videoPlayerController!.value.duration) {
  //     if (!videoPlayed.contains(videoUrl)) {
  //       videoPlayed.add(videoUrl);
  //       // update();
  //     }
  //   }
  // }
}
