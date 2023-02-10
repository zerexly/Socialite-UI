import 'package:foap/apiHandler/api_controller.dart';
import 'package:get/get.dart';
import '../../model/category_model.dart';

class SetProfileCategoryController extends GetxController {
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxInt profileCategoryType = (-1).obs;

  getProfileTypeCategories() {
    ApiController().getProfileCategoryType().then((response) {
      categories.value = response.categories;
    });
  }

  setProfileCategoryType(int categoryType) {
    profileCategoryType.value = categoryType;
    update();
  }

}
