import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class ClubDetailController extends GetxController {
  final ChatDetailController _chatDetailController = Get.find();

  RxList<PostModel> posts = <PostModel>[].obs;
  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  PostSearchQuery postSearchQuery = PostSearchQuery();

  int postsPage = 1;
  bool canLoadMorePosts = true;
  RxBool isLoading = false.obs;

  clear() {
    isLoading.value = false;
    posts.value = [];
    postsPage = 1;
    canLoadMorePosts = true;
  }

  setEvent(ClubModel clubObj) {
    club.value = clubObj;
    club.refresh();

    update();
  }

  void getPosts({required int clubId, required VoidCallback callback}) async {
    if (canLoadMorePosts == true) {
      // for (int i = 0; i < 5; i++) {
      //   BannerAdsHelper().loadBannerAds((ad) {
      //     bannerAds.add(ad);
      //     bannerAds.refresh();
      //   });
      // }

      postSearchQuery.isRecent = 1;
      postSearchQuery.clubId = clubId;
      isLoading.value = true;

      AppUtil.checkInternet().then((value) async {
        if (value) {
          ApiController()
              .getPosts(
                  userId: postSearchQuery.userId,
                  isPopular: postSearchQuery.isPopular,
                  isFollowing: postSearchQuery.isFollowing,
                  isSold: postSearchQuery.isSold,
                  isMine: postSearchQuery.isMine,
                  isRecent: postSearchQuery.isRecent,
                  title: postSearchQuery.title,
                  hashtag: postSearchQuery.hashTag,
                  clubId: postSearchQuery.clubId,
                  page: postsPage)
              .then((response) async {
            posts.addAll(response.success
                ? response.posts
                    .where((element) => element.gallery.isNotEmpty)
                    .toList()
                : []);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            isLoading.value = false;

            if (postsPage >= response.metaData!.pageCount) {
              canLoadMorePosts = false;
            } else {
              canLoadMorePosts = true;
            }
            postsPage += 1;

            callback();
          });
        }
      });
    }
  }

  postTextTapHandler({required PostModel post, required String text}) {
    if (text.startsWith('#')) {
      Get.to(() => Posts(
                hashTag: text.replaceAll('#', ''),
                source: PostSource.posts,
              ))!
          .then((value) {
        getPosts(clubId: postSearchQuery.clubId!, callback: () {});
      });
    } else {
      String userTag = text.replaceAll('@', '');
      if (post.mentionedUsers
          .where((element) => element.userName == userTag)
          .isNotEmpty) {
        int mentionedUserId = post.mentionedUsers
            .where((element) => element.userName == userTag)
            .first
            .id;
        Get.to(() => OtherUserProfile(userId: mentionedUserId))!.then((value) {
          getPosts(clubId: postSearchQuery.clubId!, callback: () {});
        });
      }
    }
  }

  removePostFromList(PostModel post) {
    posts.removeWhere((element) => element.id == post.id);
    posts.refresh();
  }

  joinClub() {
    club.value!.isJoined = true;
    club.refresh();
    ApiController().joinClub(clubId: club.value!.id!).then((response) {
      if (response.success) {
        if (club.value!.enableChat == 1) {
          // save chat group in local db

          _chatDetailController.getRoomDetail(club.value!.chatRoomId!,
              (chatRoom) {

                getIt<DBManager>().saveRoom(chatRoom);
          });
        }
      }
    });
  }

  leaveClub() {
    club.value!.isJoined = false;
    club.refresh();
    ApiController().leaveClub(clubId: club.value!.id!).then((response) {});
  }
}
