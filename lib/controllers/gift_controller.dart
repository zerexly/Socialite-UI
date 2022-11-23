import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class GiftController extends GetxController {
  RxList<GiftCategoryModel> giftsCategories = <GiftCategoryModel>[].obs;
  RxList<GiftModel> gifts = <GiftModel>[].obs;
  RxList<GiftModel> topGifts = <GiftModel>[].obs;

  RxInt selectedSegment = 0.obs;

  segmentChanged(int segment) {
    selectedSegment.value = segment;
    loadGifts(giftsCategories[segment].id);
  }

  loadGiftCategories() {
    gifts.clear();
    update();
    ApiController().getGiftCategories().then((response) {
      giftsCategories.value = response.giftCategories;
      loadGifts(giftsCategories.first.id);
    });
  }

  loadMostUsedGifts() {
    ApiController().getMostUsedGifts().then((response) {
      topGifts.value = response.gifts;

      update();
    });
  }

  loadGifts(int categoryId) {
    ApiController().getGiftsByCategory(categoryId).then((response) {
      gifts.value = response.gifts;

      update();
    });
  }
}
