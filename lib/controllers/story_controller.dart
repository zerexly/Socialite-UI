import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class AppStoryController extends GetxController {
  RxList<Media> mediaList = <Media>[].obs;
  RxBool allowMultipleSelection = false.obs;
  RxInt numberOfItems = 0.obs;

  Rx<StoryMediaModel?> storyMediaModel = Rx<StoryMediaModel?>(null);
  bool isLoading = false;

  mediaSelected(List<Media> media) {
    mediaList.value = media;
  }

  toggleMultiSelectionMode() {
    allowMultipleSelection.value = !allowMultipleSelection.value;
    update();
  }

  deleteStory() async {
    await ApiController()
        .deleteStory(id: storyMediaModel.value!.id)
        .then((response) async {});
  }

  setCurrentStoryMedia(StoryMediaModel storyMedia) {
    storyMediaModel.value = storyMedia;
    getIt<DBManager>().storyViewed(storyMedia);
    update();
  }

  void uploadAllMedia(
      {required List<Media> items, required BuildContext context}) async {
    var responses = await Future.wait(
            [for (Media media in items) uploadMedia(media, context)])
        .whenComplete(() {});

    publishAction(galleryItems: responses, context: context);
  }

  Future<Map<String, String>> uploadMedia(
      Media media, BuildContext context) async {
    Map<String, String> gallery = {};

    await AppUtil.checkInternet().then((value) async {
      if (value) {
        final tempDir = await getTemporaryDirectory();
        File mainFile;
        String? videoThumbnailPath;

        if (media.mediaType == GalleryMediaType.photo) {
          Uint8List mainFileData = await media.file!.compress();
          //image media
          mainFile =
              await File('${tempDir.path}/${media.id!.replaceAll('/', '')}.png')
                  .create();
          mainFile.writeAsBytesSync(mainFileData);
        } else {
          Uint8List mainFileData = media.file!.readAsBytesSync();
          // video
          mainFile =
              await File('${tempDir.path}/${media.id!.replaceAll('/', '')}.mp4')
                  .create();
          mainFile.writeAsBytesSync(mainFileData);

          File videoThumbnail = await File(
                  '${tempDir.path}/${media.id!.replaceAll('/', '')}_thumbnail.png')
              .create();

          videoThumbnail.writeAsBytesSync(media.thumbnail!);

          await ApiController()
              .uploadFile(
                  file: videoThumbnail.path,
                  type: UploadMediaType.storyOrHighlights)
              .then((response) async {
            videoThumbnailPath = response.postedMediaFileName!;
            await videoThumbnail.delete();
          });
        }

        EasyLoading.show(status: LocalizationString.loading);
        await ApiController()
            .uploadFile(
                file: mainFile.path, type: UploadMediaType.storyOrHighlights)
            .then((response) async {
          String mainFileUploadedPath = response.postedMediaFileName!;
          await mainFile.delete();
          gallery = {
            // 'image': media.mediaType == 1 ? mainFileUploadedPath : '',
            'image': media.mediaType == GalleryMediaType.photo
                ? mainFileUploadedPath
                : videoThumbnailPath!,
            'video': media.mediaType == GalleryMediaType.photo
                ? ''
                : mainFileUploadedPath,
            'type': media.mediaType == GalleryMediaType.photo ? '2' : '3',
            'description': '',
            'background_color': '',
          };
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
    return gallery;
  }

  void publishAction(
      {required List<Map<String, String>> galleryItems,
      required BuildContext context}) {
    AppUtil.checkInternet().then((value) async {
      EasyLoading.dismiss();

      if (value) {
        ApiController()
            .postStory(
          gallery: galleryItems,
        )
            .then((response) async {
          Get.offAll(const DashboardScreen());
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

// isSelected(String id) {
//   return selectedItems.where((item) => item.id == id).isNotEmpty;
// }
//
// selectItem(int index) async {
//   var galleryImage = mediaList[index];
//
//   if (isSelected(galleryImage.id)) {
//     selectedItems.removeWhere((anItem) => anItem.id == galleryImage.id);
//     // if (selectedItems.isEmpty) {
//     //   print('4');
//     //
//     //   selectedItems.add(galleryImage);
//     // }
//   } else {
//     if (selectedItems.length < 10) {
//       selectedItems.add(galleryImage);
//     }
//   }
//
//   update();
// }
}
