import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PostCardController extends GetxController {
  final PostController postController = Get.find();
  RxInt currentIndex = 0.obs;

  updateGallerySlider(int index) {
    currentIndex.value = index;
  }

  reportPost(PostModel post, BuildContext context) {
    ApiController().reportPost(post.id).then((response) {
      if (response.success == true) {
        AppUtil.showToast(context: context,
            message: LocalizationString.postReportedSuccessfully,
            isSuccess: false);
      }
    });
  }

  void blockUser(int userId, BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().blockUser(userId).then((response) async {
          EasyLoading.dismiss();
        });
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: false);
      }
    });
  }
}
