import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ReelsController extends GetxController {
  RxList<PostModel> publicMoments = <PostModel>[].obs;
  RxList<PostModel> filteredMoments = <PostModel>[].obs;
  RxList<PostModel> likedReels = <PostModel>[].obs;

  Rx<PostModel?> currentViewingReel = Rx<PostModel?>(null);

  bool isLoadingReelsWithAudio = false;
  int reelsWithAudioCurrentPage = 1;
  bool canLoadMoreReelsWithAudio = true;

  bool isLoadingReels = false;
  int reelsCurrentPage = 1;
  bool canLoadMoreReels = true;
  PostSearchQuery reelSearchQuery = PostSearchQuery();

  clearReels() {
    isLoadingReels = false;
    reelsCurrentPage = 1;
    canLoadMoreReels = true;
    currentViewingReel.value = null;

    update();
  }

  clearReelsWithAudio() {
    isLoadingReelsWithAudio = false;
    reelsWithAudioCurrentPage = 1;
    canLoadMoreReelsWithAudio = true;
    filteredMoments.clear();
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

  addReels(List<PostModel> reelsList, int? startPage) {
    filteredMoments.clear();
    reelsCurrentPage = startPage ?? 1;
    filteredMoments.addAll(reelsList);
    update();
  }

  setReelsSearchQuery(PostSearchQuery query) {
    if (query != reelSearchQuery) {
      clearReels();
    }
    update();
    reelSearchQuery = query;
    getReels();
  }

  void getReels() async {
    if (canLoadMoreReels == true) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingReels = true;
          ApiController()
              .getPosts(
              isReel: 1,
              userId: reelSearchQuery.userId,
              isPopular: reelSearchQuery.isPopular,
              isFollowing: reelSearchQuery.isFollowing,
              isSold: reelSearchQuery.isSold,
              isMine: reelSearchQuery.isMine,
              isRecent: reelSearchQuery.isRecent,
              title: reelSearchQuery.title,
              hashtag: reelSearchQuery.hashTag,
              page: reelsCurrentPage)
              .then((response) async {
            // posts.value = [];
            publicMoments.addAll(response.success
                ? response.posts
                .where((element) => element.gallery.isNotEmpty)
                .toList()
                : []);
            // reels.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingReels = false;

            if (reelsCurrentPage == 1) {
              currentPageChanged(0, publicMoments.first);
            }

            reelsCurrentPage += 1;

            if (response.posts.length == response.metaData?.pageCount) {
              canLoadMoreReels = true;
              // totalPages = response.metaData!.pageCount;
            } else {
              canLoadMoreReels = false;
            }
            update();
          });
        }
      });
    }
  }

  void getReelsWithAudio(int audioId) async {
    if (canLoadMoreReelsWithAudio == true) {
      AppUtil.checkInternet().then((value) async {
        if (value) {
          isLoadingReelsWithAudio = true;
          ApiController()
              .getPosts(
              isReel: 1, audioId: audioId, page: reelsWithAudioCurrentPage)
              .then((response) async {
            // posts.value = [];
            filteredMoments.addAll(response.success
                ? response.posts
                .where((element) => element.gallery.isNotEmpty)
                .toList()
                : []);
            // reels.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoadingReelsWithAudio = false;

            if (reelsWithAudioCurrentPage == 1) {
              currentPageChanged(0, publicMoments.first);
            }

            reelsWithAudioCurrentPage += 1;

            if (response.posts.length == response.metaData?.pageCount) {
              canLoadMoreReelsWithAudio = true;
              // totalPages = response.metaData!.pageCount;
            } else {
              canLoadMoreReelsWithAudio = false;
            }
            update();
          });
        }
      });
    }
  }

  void likeUnlikeReel(
      {required PostModel post, required BuildContext context}) {
    post.isLike = !post.isLike;
    if (post.isLike) {
      likedReels.add(post);
    } else {
      likedReels.remove(post);
    }
    likedReels.refresh();
    post.totalLike = post.isLike ? (post.totalLike) + 1 : (post.totalLike) - 1;
    AppUtil.checkInternet().then((value) async {
      if (value) {
        ApiController()
            .likeUnlike(post.isLike, post.id)
            .then((response) async {});
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: true);
      }
    });

    // update();
  }
}
