import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../model/club_join_request.dart';

class ClubDetailController extends GetxController {
  final ChatDetailController _chatDetailController = Get.find();

  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<ClubJoinRequest> joinRequests = <ClubJoinRequest>[].obs;

  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  PostSearchQuery postSearchQuery = PostSearchQuery();

  int postsPage = 1;
  bool canLoadMorePosts = true;
  RxBool isLoading = false.obs;

  int jonRequestsPage = 1;
  bool canLoadMoreJoinRequests = true;

  clear() {
    isLoading.value = false;
    posts.clear();
    joinRequests.clear();
    postsPage = 1;
    canLoadMorePosts = true;

    jonRequestsPage = 1;
    canLoadMoreJoinRequests = true;
  }

  setEvent(ClubModel clubObj) {
    club.value = clubObj;
    club.refresh();

    update();
  }

  void getPosts({required int clubId, required VoidCallback callback}) async {
    if (canLoadMorePosts == true) {
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

  getClubJoinRequests({required int clubId}) {
    if (canLoadMoreJoinRequests == true) {
      isLoading.value = true;

      AppUtil.checkInternet().then((value) async {
        if (value) {
          ApiController()
              .getClubJoinRequests(clubId: clubId, page: jonRequestsPage)
              .then((response) async {
            joinRequests.addAll(
                response.success ? response.clubJoinRequests.toList() : []);
            isLoading.value = false;

            if (jonRequestsPage >= response.metaData!.pageCount) {
              canLoadMoreJoinRequests = false;
            } else {
              canLoadMoreJoinRequests = true;
            }
            jonRequestsPage += 1;
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
    if (club.value!.isRequestBased == true) {
      club.value!.isRequested = true;
      club.refresh();
      ApiController()
          .sendClubJoinRequest(clubId: club.value!.id!)
          .then((response) {});
    } else {
      club.value!.isJoined = true;
      club.refresh();
      ApiController().joinClub(clubId: club.value!.id!).then((response) {
        if (response.success) {
          if (club.value!.enableChat == 1) {
            _chatDetailController.getRoomDetail(club.value!.chatRoomId!,
                (chatRoom) {
              getIt<DBManager>().saveRooms([chatRoom]);
            });
          }
        }
      });
    }
  }

  leaveClub() {
    club.value!.isJoined = false;
    club.refresh();
    ApiController().leaveClub(clubId: club.value!.id!).then((response) {});
  }

  acceptClubJoinRequest(ClubJoinRequest request) {
    joinRequests.remove(request);
    joinRequests.refresh();
    update();
    ApiController()
        .acceptDeclineClubJoinRequest(requestId: request.id!, replyStatus: 10)
        .then((response) {});
  }

  declineClubJoinRequest(ClubJoinRequest request) {
    joinRequests.remove(request);
    joinRequests.refresh();
    update();

    ApiController()
        .acceptDeclineClubJoinRequest(requestId: request.id!, replyStatus: 3)
        .then((response) {});
  }
}
