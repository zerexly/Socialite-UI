import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart' as path;

class CreateReelController extends GetxController {
  final PlayerManager _playerManager = Get.find();

  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ReelMusicModel> audios = <ReelMusicModel>[].obs;

  ReelMusicModel? selectedAudio;
  double? audioStartTime;
  double? audioEndTime;
  File? croppedAudioFile;

  RxString searchText = ''.obs;
  int selectedSegment = 0;

  RxBool isLoadingAudios = false.obs;
  int audiosCurrentPage = 1;
  bool canLoadMoreAudios = true;
  final player = AudioPlayer(); // Create a player

  RxBool isRecording = false.obs;

  RxBool enableRecord = false.obs;
  DateTime? startDateTime;
  DateTime? endDateTime;
  RxBool flashSetting = false.obs;
  RxInt recordingLength = 15.obs;

  RxDouble currentProgressValue = (0.0).obs;
  late SimpleDownloader _downloader;

  void turnOnFlash() {
    flashSetting.value = true;
    update();
  }

  void turnOffFlash() {
    flashSetting.value = false;
    update();
  }

  searchTextChanged(String text) {
    if (searchText.value != text) {
      clear();
      searchText.value = text;

      audios.clear();
      getReelAudios();
    }
  }

  clear() {
    audios.clear();
    isLoadingAudios.value = false;
    isRecording.value = false;
    audiosCurrentPage = 1;
    canLoadMoreAudios = true;
    stopPlayingAudio();
  }

  closeSearch() {
    searchText.value = '';
    update();
  }

  segmentChanged(int index) {
    if (selectedSegment != index) {
      clear();
      selectedSegment = index;
      getReelAudios();
      update();
    }
  }

  getReelCategories() {
    isLoadingAudios.value = true;
    ApiController().getReelCategories().then((result) {
      categories.value = result.categories;
      getReelAudios();
      update();
    });
  }

  getReelAudios() {
    CategoryModel category = categories[selectedSegment];

    if (canLoadMoreAudios == true) {
      isLoadingAudios.value = true;

      ApiController()
          .getAudios(
          categoryId: category.id,
          title: searchText.value.isNotEmpty ? searchText.value : null)
          .then((response) {
        isLoadingAudios.value = false;
        audios.value = response.audios;

        audiosCurrentPage += 1;

        if (response.posts.length == response.metaData?.pageCount) {
          canLoadMoreAudios = true;
        } else {
          canLoadMoreAudios = false;
        }

        update();
      });
    }
  }

  selectReelAudio(ReelMusicModel audio) {
    selectedAudio = audio;
  }

  setCroppedAudio(File audioFile) {
    croppedAudioFile = audioFile;
  }

  setAudioCropperTime(double startTime, double endTime) {
    audioStartTime = startTime;
    audioEndTime = endTime;
  }

  playAudio(ReelMusicModel reelAudio) async {
    Audio audio = Audio(id: reelAudio.id.toString(), url: reelAudio.url);
    _playerManager.playAudio(audio);

    update();
  }

  playAudioFile(File reelAudio) async {
    _playerManager.playAudioFile(reelAudio);
    update();
  }

  playAudioFileUntil(ReelMusicModel reelAudio, double startDuration,
      double endDuration) async {
    _playerManager.playAudioFileTimeIntervalBased(
        reelAudio, startDuration, endDuration);
    update();
  }

  stopPlayingAudio() {
    debugPrint('end at:: ${_playerManager.currentPosition}');
    _playerManager.stopAudio();
    update();
  }

  void stopRecording() {
    endDateTime = DateTime.now();
    isRecording.value = false;
    stopPlayingAudio();
    update();
  }

  void startRecording() {
    isRecording.value = true;
    startDateTime = DateTime.now();
    update();
  }

  enableRecording() {
    enableRecord.value = true;
    update();
  }

  disableRecording() {
    enableRecord.value = false;
    update();
  }

  void createReel(File? selectedAudioFile, XFile videoFile) async {
    final directory = await getTemporaryDirectory();
    var finalFile = File(
        '${directory.path}/REEL_${DateTime.now().millisecondsSinceEpoch}.mp4');

    if (selectedAudioFile != null) {
      FFmpegKitConfig.enableLogCallback((log) {
        final message = log.getMessage();
        debugPrint('FFmpegLog:: ${log.getMessage()}');
      });
      var command =
          "-i ${videoFile.path} -i ${selectedAudioFile.path} -map 0:v -map 1:a -c:v copy "
          "-shortest ${finalFile.path}";
      FFmpegKit.executeAsync(
        command,
            (session) async {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            debugPrint('Reel Created at: ${finalFile.path}');
            // SUCCESS
            // AppUtil.showToast(
            //     context: Get.context!,
            //     message: 'Reel Created successfully',
            //     isSuccess: true);
            Get.to(() => PreviewReelsScreen(
              reel: finalFile,
              audioId: selectedAudio?.id,
              audioStartTime: audioStartTime,
              audioEndTime: audioEndTime,
            ));
            /* final route = MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => VideoPage(filePath: file.path),
            );
            Navigator.push(context, route);*/

          } else if (ReturnCode.isCancel(returnCode)) {
            debugPrint('Reel failed :: Cancelled');
            // CANCEL

          } else {
            debugPrint('Reel failed :: $returnCode');
            // ERROR
          }
        },
      );
    } else {
      debugPrint('Reel Created without audio:: ${videoFile.path}');
      var finalFile = File(videoFile.path);
      // AppUtil.showToast(
      //     context: Get.context!,
      //     message: 'Reel Created without Audio',
      //     isSuccess: true);
      Get.to(() => PreviewReelsScreen(
        reel: finalFile,
      ));
    }
  }

  downloadAudio(Function(bool) callback) async {
    // **** Download the audio file *******//
    DownloaderTask _task = DownloaderTask(
      url: selectedAudio!.url,
      fileName: "${selectedAudio!.id}.mp3",
      bufferSize:
      1024, // if bufferSize value not set, default value is 64 ( 64 Kb )
    );

    final pathFile = (await path.getTemporaryDirectory()).path;
    // if (!mounted) return;

    _task = _task.copyWith(
      downloadPath: pathFile,
    );

    print(pathFile);
    print(selectedAudio!.url);

    _downloader = SimpleDownloader.init(task: _task);
    _downloader.download();
    _downloader.callback.addListener(() {
      print(_downloader.callback.progress);
      if (_downloader.callback.status == DownloadStatus.completed) {
        croppedAudioFile = File("$pathFile/${selectedAudio!.id}.mp3");

        callback(true);
      } else if (_downloader.callback.status == DownloadStatus.failed ||
          _downloader.callback.status == DownloadStatus.canceled ||
          _downloader.callback.status == DownloadStatus.deleted) {
        callback(false);
      }
    });
  }

  void trimAudio() async {
    if ((audioEndTime ?? 0 - (audioStartTime ?? 0)) <
        recordingLength.toDouble()) {
      AppUtil.showToast(
          context: Get.context!,
          message: 'Audio Clip is shorter than ${recordingLength}seconds ',
          isSuccess: false);
      return;
    }

    downloadAudio((status) async {
      if (status) {
        if (croppedAudioFile != null) {
          double duration = audioEndTime! - audioStartTime!;
          stopPlayingAudio();

          final directory = await getTemporaryDirectory();
          var finalAudioFile = File(
              '${directory.path}/AUD_${DateTime.now().millisecondsSinceEpoch}.mp3');

          var audioTrimCommand =
              '-ss ${audioStartTime!} -i ${croppedAudioFile!.path} -t $duration -c copy ${finalAudioFile.path}';
          FFmpegKit.executeAsync(
            audioTrimCommand,
                (session) async {
              final returnCode = await session.getReturnCode();

              if (ReturnCode.isSuccess(returnCode)) {
                debugPrint('Audio Trimmed at: ${finalAudioFile.path}');
                // SUCCESS
                Get.back(result: finalAudioFile);
              } else if (ReturnCode.isCancel(returnCode)) {
                debugPrint('Audio Trim failed :: Cancelled');
                // CANCEL
              } else {
                debugPrint('Audio Trim failed :: $returnCode');
                // ERROR
              }
            },
          );
        }
      }
    });
  }

  void updateProgress() {
    currentProgressValue.value = currentProgressValue.value + 1;
    update();
  }

  void resetProgress() {
    currentProgressValue.value = 0.0;
    update();
  }

  void updateRecordingLength(int recordingTime) {
    recordingLength.value = recordingTime;
    update();
  }
}
