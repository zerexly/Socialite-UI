import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CommentsController extends GetxController {
  RxList<CommentModel> comments = <CommentModel>[].obs;

  void getComments(int postId,BuildContext context) {
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController().getComments(postId).then((response) async {
          if (response.success) {
            comments.value = response.comments;
            update();
            // widget.model?.totalComment = comments.length;
          }
        });
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: true);      }
    });
  }

  void postCommentsApiCall({required String comment, required int postId}) {
    CommentModel newMessage =
        CommentModel.fromNewMessage(comment, getIt<UserProfileManager>().user!);
    newMessage.commentTime = LocalizationString.justNow;
    comments.add(newMessage);
    update();

    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController().postComments(postId, comment);
      }
    });
  }

}
