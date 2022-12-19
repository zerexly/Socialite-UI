import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CreateReelController extends GetxController{
  RxList<ReelMusicModel> musicList = <ReelMusicModel>[].obs;

  RxString searchText = ''.obs;
  int selectedSegment = 0;
  bool isSearching = false;

  searchTextChanged(String text) {
    // clear();
    searchText.value = text;
    // postController.clearPosts();
    // searchData();
  }

  closeSearch() {
    // clear();
    // postController.clearPosts();
    searchText.value = '';
    // selectedSegment = 0;
    update();
  }

  segmentChanged(int index) {
    selectedSegment = index;
    // searchData();
    update();
  }

  searchSuggestedMusic(){

  }

}