import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ReelsController extends GetxController {
  RxList<PostModel> reels = <PostModel>[].obs;
  Rx<PostModel?> currentViewingReel = Rx<PostModel?>(null);

  bool isLoadingPosts = false;
  int postsCurrentPage = 1;
  bool canLoadMorePosts = true;

  clearPosts() {
    isLoadingPosts = false;
    postsCurrentPage = 1;
    canLoadMorePosts = true;
    currentViewingReel.value = null;

    update();
  }

  setCurrentViewingReel(PostModel reel) {
    currentViewingReel.value = reel;
    currentViewingReel.refresh();
    update();
  }

  currentPageChanged(int index, PostModel reel) {
    setCurrentViewingReel(reel);
    // currentPage.value = index;
    // currentPage.refresh();
  }

  void getReels() async {
    if (canLoadMorePosts == true) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingPosts = true;
          ApiController()
              .getPosts(
                  // userId: postSearchQuery!.userId,
                  // isPopular: postSearchQuery!.isPopular,
                  // isFollowing: postSearchQuery!.isFollowing,
                  // isSold: postSearchQuery!.isSold,
                  // isMine: postSearchQuery!.isMine,
                  // isRecent: postSearchQuery!.isRecent,
                  // title: postSearchQuery!.title,
                  // hashtag: postSearchQuery!.hashTag,
                  page: postsCurrentPage)
              .then((response) async {
            // posts.value = [];
            reels.addAll(response.success
                ? response.posts
                    .where((element) => element.gallery.isNotEmpty)
                    .toList()
                : []);
            // reels.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingPosts = false;

            if (postsCurrentPage == 1) {
              currentPageChanged(0, reels.first);
            }

            postsCurrentPage += 1;

            if (response.posts.length == response.metaData?.pageCount) {
              canLoadMorePosts = true;
              // totalPages = response.metaData!.pageCount;
            } else {
              canLoadMorePosts = false;
            }
            update();
          });
        }
      });
    }
  }
}
