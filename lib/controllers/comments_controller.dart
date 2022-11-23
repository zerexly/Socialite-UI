import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CommentsController extends GetxController {
  RxInt isEditing = 0.obs;
  RxString currentHashtag = ''.obs;
  RxString currentUserTag = ''.obs;

  RxList<CommentModel> comments = <CommentModel>[].obs;
  RxList<Hashtag> hashTags = <Hashtag>[].obs;
  RxList<UserModel> searchedUsers = <UserModel>[].obs;

  int currentUpdateAbleStartOffset = 0;
  int currentUpdateAbleEndOffset = 0;

  RxString searchText = ''.obs;
  RxInt position = 0.obs;

  int hashtagsPage = 1;
  bool canLoadMoreHashtags = true;
  bool hashtagsIsLoading = false;

  int accountsPage = 1;
  bool canLoadMoreAccounts = true;
  bool accountsIsLoading = false;

  clear() {
    hashtagsPage = 1;
    canLoadMoreHashtags = true;
    hashtagsIsLoading = false;

    accountsPage = 1;
    canLoadMoreAccounts = true;
    accountsIsLoading = false;
    update();
  }

  void getComments(int postId, BuildContext context) {
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
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: true);
      }
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

  // adding hashtag and mentions

  startedEditing() {
    isEditing.value = 1;
    update();
  }

  stoppedEditing() {
    isEditing.value = 0;
    update();
  }

  searchHashTags({required String text}) {
    if (canLoadMoreHashtags) {
      hashtagsIsLoading = true;

      ApiController()
          .searchHashtag(hashtag: text.replaceAll('#', ''))
          .then((response) {
        hashTags.value = response.hashtags;

        hashtagsIsLoading = false;
        hashtagsPage += 1;
        if (response.hashtags.length == response.metaData?.perPage) {
          canLoadMoreHashtags = true;
        } else {
          canLoadMoreHashtags = false;
        }

        update();
      });
    }
  }

  addUserTag(String user) {
    String updatedText = searchText.value.replaceRange(
        currentUpdateAbleStartOffset, currentUpdateAbleEndOffset, '$user ');
    searchText.value = updatedText;
    position.value = updatedText.indexOf(user, currentUpdateAbleStartOffset) +
        user.length +
        1;

    currentUserTag.value = '';

    searchedUsers.clear();
    update();
  }

  addHashTag(String hashtag) {
    String updatedText = searchText.value.replaceRange(
        currentUpdateAbleStartOffset, currentUpdateAbleEndOffset, '$hashtag ');
    position.value =
        updatedText.indexOf(hashtag, currentUpdateAbleStartOffset) +
            hashtag.length +
            1;

    searchText.value = updatedText;
    currentHashtag.value = '';

    hashTags.clear();
    update();
  }

  searchUsers(String text) {
    if (canLoadMoreAccounts) {
      accountsIsLoading = true;
      ApiController()
          .findFriends(isExactMatch: 0, searchText: text.replaceAll('@', ''))
          .then((response) {
        searchedUsers.value = response.users;
        accountsIsLoading = false;

        accountsPage += 1;
        if (response.topUsers.length == response.metaData?.perPage) {
          canLoadMoreAccounts = true;
        } else {
          canLoadMoreAccounts = false;
        }
        update();
      });
    }
  }

  textChanged(String text, int position) {
    clear();
    isEditing.value = 1;
    searchText.value = text;
    String substring = text.substring(0, position).replaceAll("\n", " ");
    List<String> parts = substring.split(' ');
    String lastPart = parts.last;

    if (lastPart.startsWith('#') == true && lastPart.contains('@') == false) {
      if (currentHashtag.value.startsWith('#') == false) {
        currentHashtag.value = lastPart;
        currentUpdateAbleStartOffset = position;
      }

      if (lastPart.length > 1) {
        searchHashTags(text: lastPart);
        currentUpdateAbleEndOffset = position;
      }
    } else if (lastPart.startsWith('@') == true &&
        lastPart.contains('#') == false) {
      if (currentUserTag.value.startsWith('@') == false) {
        currentUserTag.value = lastPart;
        currentUpdateAbleStartOffset = position;
      }
      if (lastPart.length > 1) {
        searchUsers(lastPart);
        currentUpdateAbleEndOffset = position;
      }
    } else {
      if (currentHashtag.value.startsWith('#') == true) {
        currentHashtag.value = lastPart;
      }
      currentHashtag.value = '';
      hashTags.value = [];

      if (currentUserTag.value.startsWith('!') == true) {
        currentUserTag.value = lastPart;
      }
      currentUserTag.value = '';
      searchedUsers.value = [];
    }

    this.position.value = position;
  }
}
