import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxList<ChatRoomModel> rooms = <ChatRoomModel>[].obs;

  Map<String, dynamic> typingStatus = {};

  getChatRooms() {
    ApiController().getChatRooms().then((response) async {
      rooms.value = await getIt<DBManager>().mapUnReadCount(response.chatRooms);
      update();
    });
  }

  clearUnreadCount({required ChatRoomModel chatRoom}) {
    getIt<DBManager>().clearUnReadCount(roomId: chatRoom.id);

    rooms.value = rooms.map((element) {
      if (element.id == chatRoom.id) {
        element.unreadMessages = 0;
      }
      return element;
    }).toList();
    update();
  }

  deleteRoom(ChatRoomModel chatRoom) {
    rooms.removeWhere((element) => element.id == chatRoom.id);
    update();
    getIt<DBManager>().deleteRoom(chatRoom);
    ApiController().deleteChatRoom(chatRoom.id);
  }

  // ******************* updates from socket *****************//

  newMessageReceived(ChatMessageModel message) {
    List<ChatRoomModel> existingRooms =
        rooms.where((room) => room.id == message.roomId).toList();

    getIt<DBManager>().updateUnReadCount(roomId: message.roomId);

    if (existingRooms.isNotEmpty) {
      ChatRoomModel room = existingRooms.first;
      room.lastMessage = message;
      room.isTyping = false;
      room.unreadMessages += 1;
      rooms.refresh();
      update();
    } else {
      getChatRooms();
    }
  }

  messageUpdateReceived(Map<String, dynamic> updatedData) {
    String localMessageId = updatedData['localMessageId'];
    int messageId = updatedData['id'];
    int status = updatedData['current_status'];
    int createdAt = updatedData['created_at'];
    int roomId = updatedData['room'];

    getIt<DBManager>().updateMessageStatus(
        roomId: roomId,
        localMessageId: localMessageId,
        id: messageId,
        status: status,
        createdAt: createdAt);
  }

  userTypingStatusChanged({required String userName, required bool status}) {
    var matchedRooms =
        rooms.where((element) => element.opponent.userName == userName);
    if (matchedRooms.isNotEmpty) {
      var room = matchedRooms.first;

      typingStatus[userName] = DateTime.now();
      room.isTyping = status;
      rooms.refresh();
      update();
      if (status == true) {
        Timer(const Duration(seconds: 5), () {
          if (typingStatus[userName] != null) {
            if (DateTime.now().difference(typingStatus[userName]!).inSeconds >
                4) {
              room.isTyping = false;
              update();
            }
          } else {
            room.isTyping = false;
            update();
          }
        });
      }
    }
  }

  userAvailabilityStatusChange({required int userId, required bool isOnline}) {
    var matchedRooms = rooms.where((element) => element.opponent.id == userId);

    if (matchedRooms.isNotEmpty) {
      var room = matchedRooms.first;
      room.isOnline = isOnline;
      room.opponent.isOnline = isOnline;
      rooms.refresh();
      update();
    }
  }
}
