import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class HighlightsController extends GetxController {
  RxList<HighlightsModel> highlights = <HighlightsModel>[].obs;
  RxList<StoryMediaModel> selectedStoriesMedia = <StoryMediaModel>[].obs;
  RxList<StoryMediaModel> stories = <StoryMediaModel>[].obs;

  Rx<HighlightMediaModel?> storyMediaModel = Rx<HighlightMediaModel?>(null);

  String coverImage = '';
  String coverImageName = '';

  File? pickedImage;
  String? picture;
  UserModel? model;

  bool isLoading = true;

  setCurrentStoryMedia(HighlightMediaModel storyMedia) {
    storyMediaModel.value = storyMedia;
    update();
  }

  updateCoverImage(File? image) {
    pickedImage = image;
    update();
  }

  updateCoverImagePath() {
    for (StoryMediaModel media in selectedStoriesMedia) {
      if (media.image != null) {
        coverImage = media.image!;
        coverImageName = media.imageName!;
        break;
      }
    }
  }

  void getHighlights({required int userId}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        isLoading = true;
        update();
        ApiController().getHighlights(userId: userId).then((response) async {
          isLoading = false;
          highlights.value = response.success ? response.highlights : [];
          update();
        });
      }
    });
  }

  getAllStories() {
    isLoading = true;
    update();
    ApiController().getMyStories().then((response) {
      isLoading = false;
      stories.value = response.myStories;
      update();
    });
  }

  createHighlights({required String name}) async {
    if (pickedImage != null) {
      await uploadCoverImage();
    }

    EasyLoading.show(status: LocalizationString.loading);
    ApiController()
        .createHighlight(
            name: name,
            image: coverImageName,
            stories: selectedStoriesMedia
                .map((element) => element.id.toString())
                .toList()
                .join(','))
        .then((value) async {
      EasyLoading.dismiss();
      Get.offAll(const DashboardScreen(selectedTab: 4));
    });
  }

  Future uploadCoverImage() async {
    await ApiController()
        .uploadFile(file: pickedImage!.path, type: UploadMediaType.storyOrHighlights)
        .then((response) async {
      coverImageName = response.postedMediaFileName!;
    });
  }

  deleteStoryFromHighlight() async {
    await ApiController()
        .deleteStoryFromHighlights(id: storyMediaModel.value!.id)
        .then((response) async {});
  }
}
