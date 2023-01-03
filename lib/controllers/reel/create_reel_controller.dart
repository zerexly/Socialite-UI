import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class CreateReelController extends GetxController {
  final PlayerManager _playerManager = Get.find();

  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ReelMusicModel> audios = <ReelMusicModel>[].obs;

  RxString searchText = ''.obs;
  int selectedSegment = 0;

  RxBool isLoadingReels = false.obs;
  int reelsCurrentPage = 1;
  bool canLoadMoreReels = true;
  final player = AudioPlayer(); // Create a player

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
    isLoadingReels.value = false;
    reelsCurrentPage = 1;
    canLoadMoreReels = true;
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
    isLoadingReels.value = true;
    ApiController().getReelCategories().then((result) {
      categories.value = result.categories;
      getReelAudios();
      update();
    });
  }

  getReelAudios() {
    CategoryModel category = categories[selectedSegment];

    if (canLoadMoreReels == true) {
      isLoadingReels.value = true;

      ApiController()
          .getAudios(
              categoryId: category.id,
              title: searchText.value.isNotEmpty ? searchText.value : null)
          .then((response) {
        isLoadingReels.value = false;
        audios.value = response.audios;

        reelsCurrentPage += 1;

        if (response.posts.length == response.metaData?.pageCount) {
          canLoadMoreReels = true;
        } else {
          canLoadMoreReels = false;
        }

        update();
      });
    }
  }

  playAudio(ReelMusicModel reelAudio) async {
    Audio audio = Audio(id: reelAudio.id.toString(), url: reelAudio.url);
    _playerManager.playAudio(audio);

    update();
  }

  stopPlayingAudio() {
    _playerManager.stopAudio();
    update();
  }
}
