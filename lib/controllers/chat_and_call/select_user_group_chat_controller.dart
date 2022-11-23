import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectUserForGroupChatController extends GetxController {
  final ChatDetailController _chatDetailController = Get.find();

  RxList<UserModel> friends = <UserModel>[].obs;
  RxList<UserModel> selectedFriends = <UserModel>[].obs;

  int page = 1;
  bool canLoadMore = true;
  bool isLoading = false;

  String searchText = '';

  clear() {
    page = 1;
    canLoadMore = true;
    isLoading = false;
    selectedFriends.clear();
  }

  addUsersToRoom(ChatRoomModel room) {
    for (UserModel user in selectedFriends) {
      getIt<SocketManager>().emit(SocketConstants.addUserInChatRoom,
          {'userId': user.id.toString(), 'room': room.id});

      _chatDetailController.chatRoom.value!.roomMembers
          .add(user.toChatRoomMember);
    }

    _chatDetailController.update();
  }

  searchTextChanged(String text) {
    searchText = text;
  }

  selectFriend(UserModel user) {
    if (selectedFriends.contains(user)) {
      selectedFriends.remove(user);
    } else {
      selectedFriends.add(user);
    }
    update();
  }

  getFriends() {
    if (canLoadMore) {
      isLoading = true;
      ApiController().getFollowingUsers(page: page).then((response) {
        isLoading = false;
        friends.value = response.users;

        page += 1;
        if (response.users.length == response.metaData?.perPage) {
          canLoadMore = true;
        } else {
          canLoadMore = false;
        }
        update();
      });
    }
  }
}
