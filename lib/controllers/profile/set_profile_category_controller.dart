import 'package:get/get.dart';

class SetProfileCategoryController extends GetxController {
  RxInt profileCategoryType = (-1).obs;

  setProfileCategoryType(int categoryType) {
    profileCategoryType.value = categoryType;
  }
}
