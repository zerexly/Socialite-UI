import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectPostMediaController extends GetxController {
  RxList<Media> selectedMediaList = <Media>[].obs;
  RxBool allowMultipleSelection = false.obs;
  RxInt currentIndex = 0.obs;

  clear() {
    allowMultipleSelection.value = false;
    selectedMediaList.clear();
    update();
  }

  toggleMultiSelectionMode() {
    allowMultipleSelection.value = !allowMultipleSelection.value;
    update();
  }

  mediaSelected(List<Media> media) {
    selectedMediaList.value = media;
    selectedMediaList.refresh();
    update();
  }

  updateGallerySlider(int index) {
    currentIndex.value = index;
    update();
  }
}
