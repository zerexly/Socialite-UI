import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatHistoryController extends GetxController {
  final ChatDetailController _chatDetailController = Get.find();
  final DashboardController _dashboardController = Get.find();

  List<ChatRoomModel> allRooms = [];
  RxList<ChatRoomModel> searchedRooms = <ChatRoomModel>[].obs;

  Map<String, dynamic> typingStatus = {};
  bool isLoading = false;

  getChatRooms() async {
    isLoading = true;
    allRooms = await getIt<DBManager>().getAllRooms();
    // for(ChatRoomModel room in allRooms){
    //   getIt<DBManager>().deleteMessagesInRoom(room);
    // }
    searchedRooms.value = allRooms;
    update();

    if (allRooms.isEmpty) {
      ApiController().getChatRooms().then((response) async {
        isLoading = false;
        List<ChatRoomModel> groupChatRooms = response.chatRooms
            // .where((element) => element.isGroupChat == true)
            .toList();
        await getIt<DBManager>().saveRooms(groupChatRooms);

        allRooms = await getIt<DBManager>().getAllRooms();
        // allRooms = await getIt<DBManager>().mapUnReadCount(groupChatRooms);
        searchedRooms.value = allRooms;
        update();
      });
    }
    else{
      isLoading = false;
    }
  }

  searchTextChanged(String text) {
    if (text.isEmpty) {
      searchedRooms.value = allRooms;
      return;
    }
    searchedRooms.value = allRooms.where((room) {
      if (room.isGroupChat) {
        return room.name!.toLowerCase().contains(text);
      } else {
        return room.opponent.userDetail.userName.toLowerCase().contains(text);
      }
    }).toList();
    searchedRooms.refresh();
  }

  clearUnreadCount({required ChatRoomModel chatRoom}) async {
    getIt<DBManager>().clearUnReadCount(roomId: chatRoom.id);

    int roomsWithUnreadMessageCount =
        await getIt<DBManager>().roomsWithUnreadMessages();
    _dashboardController.updateUnreadMessageCount(roomsWithUnreadMessageCount);

    getChatRooms();
    update();
  }

  deleteRoom(ChatRoomModel chatRoom) {
    allRooms.removeWhere((element) => element.id == chatRoom.id);
    getIt<DBManager>().deleteRoom(chatRoom);
    update();
    ApiController().deleteChatRoom(chatRoom.id);
  }

  // ******************* updates from socket *****************//

  newMessageReceived(ChatMessageModel message) async {
    List<ChatRoomModel> existingRooms =
        allRooms.where((room) => room.id == message.roomId).toList();

    if (existingRooms.isNotEmpty &&
        message.roomId != _chatDetailController.chatRoom.value?.id) {
      ChatRoomModel room = existingRooms.first;
      room.lastMessage = message;
      room.whoIsTyping.remove(message.userName);
      typingStatus[message.userName] = null;

      // room.unreadMessages += 1;
      // allRooms.refresh();
      searchedRooms.refresh();
      update();
      getIt<DBManager>().updateUnReadCount(roomId: message.roomId);
    }

    getChatRooms();
  }

  userTypingStatusChanged(
      {required String userName, required int roomId, required bool status}) {
    var matchedRooms = allRooms.where((element) => element.id == roomId);

    if (matchedRooms.isNotEmpty) {
      var room = matchedRooms.first;

      if (typingStatus[userName] == null) {
        room.whoIsTyping.add(userName);
        searchedRooms.refresh();
      }

      typingStatus[userName] = DateTime.now();

      // room.isTyping = status;
      // searchedRooms.refresh();
      // update();
      if (status == true) {
        Timer(const Duration(seconds: 5), () {
          if (typingStatus[userName] != null) {
            if (DateTime.now().difference(typingStatus[userName]!).inSeconds >
                4) {
              room.whoIsTyping.remove(userName);
              typingStatus[userName] = null;
              searchedRooms.refresh();
              update();
            }
          }
        });
      }
      update();
    }
  }

  userAvailabilityStatusChange({required int userId, required bool isOnline}) {
    var matchedRooms =
        allRooms.where((element) => element.opponent.id == userId);

    if (matchedRooms.isNotEmpty) {
      var room = matchedRooms.first;
      room.isOnline = isOnline;
      room.opponent.userDetail.isOnline = isOnline;
      searchedRooms.refresh();
      // update();
    }
  }
}
