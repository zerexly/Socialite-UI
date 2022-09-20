import 'package:foap/helper/common_import.dart';
import 'package:foap/manager/file_manager.dart';

class DBManager {
  final db = Localstore.instance;

  storyViewed(StoryMediaModel story) {
    //save the item
    db
        .collection('viewedStories')
        .doc(story.id.toString())
        .set({'storyId': story.id, 'time': story.createdAtDate});
  }

  Future<List<int>> getAllViewedStories() async {
    List<int> ids = [];
    final items = await db.collection('viewedStories').get();
    for (var doc in items?.values ?? []) {
      ids.add((doc as Map<String, dynamic>)['storyId']);
    }

    return ids;
  }

  clearOldStories() async {
    final items = await db.collection('viewedStories').get();
    int currentEpochTime = DateTime.now().millisecondsSinceEpoch;

    for (Map<String, dynamic> doc in items?.values ?? []) {
      if (currentEpochTime - doc['time'] > 86400000) {
        //delete old story
        db.collection('viewedStories').doc(doc['storyId'].toString()).delete();
      }
    }
  }

  //******************** Chat ************************//

  saveMessage(int roomId, ChatMessageModel chatMessage) {
    db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .doc(chatMessage.localMessageId.toString())
        .set(chatMessage.toJson());
  }

  updateMessageContent(
      int roomId, String localMessageId, String content) async {
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();

    var messages = items?.values ?? [];
    var matchedMessages = messages
        .where((element) => element['local_message_id'] == localMessageId);

    if (matchedMessages.isNotEmpty) {
      var messageData = matchedMessages.first;
      messageData['message'] = content;
      db
          .collection('rooms')
          .doc(roomId.toString())
          .collection('messages')
          .doc(localMessageId.toString())
          .set(messageData);
    }
  }

  updateMessageStatus(
      {required int roomId,
      required String localMessageId,
      required int id,
      required int status,
      required int createdAt}) async {
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();

    var messages = items?.values ?? [];
    var matchedMessages = messages
        .where((element) => element['local_message_id'] == localMessageId);
    if (matchedMessages.isNotEmpty) {
      var messageData = matchedMessages.first;
      messageData['id'] = id;
      messageData['status'] = status;
      messageData['created_at'] = createdAt;

      db
          .collection('rooms')
          .doc(roomId.toString())
          .collection('messages')
          .doc(localMessageId.toString())
          .set(messageData);
    }
  }

  Future<List<ChatMessageModel>> getAllMessages(int roomId) async {
    List<ChatMessageModel> messages = [];
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();
    String? lastMessageDate;

    List dbMessages = (items?.values ?? []).toList();
    dbMessages.sort((a, b) => a['created_at'].compareTo(b['created_at']));

    for (var doc in dbMessages) {
      ChatMessageModel message =
          ChatMessageModel.fromJson((doc as Map<String, dynamic>));
      String dateTimeStr = message.date;
      if (dateTimeStr != lastMessageDate && message.isDateSeparator == false) {
        ChatMessageModel separatorMessage = ChatMessageModel();
        separatorMessage.createdAt = message.createdAt;
        separatorMessage.isDateSeparator = true;
        messages.add(separatorMessage);
        lastMessageDate = dateTimeStr;
      }
      messages.add(message);
    }
    return messages;
  }

  Future<List<ChatMessageModel>> getMessages(
      {required int roomId, required MessageContentType contentType}) async {
    List<ChatMessageModel> messages = [];
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();
    for (var doc in items?.values ?? []) {
      messages.add(ChatMessageModel.fromJson((doc as Map<String, dynamic>)));
    }
    messages = messages
        .where((element) =>
            element.messageContentType == contentType &&
            element.messageContent.isNotEmpty)
        .toList();
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  Future<List<ChatMessageModel>> getMessagesById(
      {required int messageId, required int roomId}) async {
    List<ChatMessageModel> messages = [];
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();
    for (var doc in items?.values ?? []) {
      ChatMessageModel message =
          ChatMessageModel.fromJson((doc as Map<String, dynamic>));
      if (message.id == messageId) {
        messages.add(message);
      }
    }

    return messages;
  }

  Future<List<ChatMessageModel>> getMediaMessages({required int roomId}) async {
    List<ChatMessageModel> messages = [];
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();
    for (var doc in items?.values ?? []) {
      messages.add(ChatMessageModel.fromJson((doc as Map<String, dynamic>)));
    }
    messages = messages
        .where((element) =>
            element.messageContentType == MessageContentType.photo ||
            element.messageContentType == MessageContentType.video)
        .toList();
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  deleteRoom(ChatRoomModel chatRoom) async {
    // await db.collection('rooms').doc(chatRoom.id.toString()).delete();
    List<ChatMessageModel> messages = await getAllMessages(chatRoom.id);
    hardDeleteMessages(chatRoom: chatRoom, messages: messages);
    getIt<FileManager>().deleteRoomMedia(chatRoom);
  }

  hardDeleteMessages(
      {required ChatRoomModel chatRoom,
      required List<ChatMessageModel> messages}) async {
    for (ChatMessageModel message in messages) {
      db
          .collection('rooms')
          .doc(chatRoom.id.toString())
          .collection('messages')
          .doc(message.localMessageId.toString())
          .delete()
          .then((value) {});

      getIt<FileManager>().deleteMessageMedia(message);
    }
  }

  deleteMessages(
      {required ChatRoomModel chatRoom,
      required List<ChatMessageModel> messagesToDelete}) async {
    final items = await db
        .collection('rooms')
        .doc(chatRoom.id.toString())
        .collection('messages')
        .get();

    var messages = items?.values ?? [];

    for (ChatMessageModel message in messagesToDelete) {
      var matchedMessages = messages.where((element) =>
          element['id'] == message.id ||
          element['local_message_id'] == message.localMessageId);
      if (matchedMessages.isNotEmpty) {
        var messageData = matchedMessages.first;
        messageData['isDeleted'] = 1;

        db
            .collection('rooms')
            .doc(chatRoom.id.toString())
            .collection('messages')
            .doc(message.localMessageId.toString())
            .set(messageData);
      }
    }
  }

  messagedDeleted({required int chatRoomId, required int messageId}) async {
    final items = await db
        .collection('rooms')
        .doc(chatRoomId.toString())
        .collection('messages')
        .get();

    var messages = items?.values ?? [];

    var matchedMessages =
        messages.where((element) => element['id'] == messageId);

    print(matchedMessages.length);

    if (matchedMessages.isNotEmpty) {
      var messageData = matchedMessages.first;
      messageData['isDeleted'] = 1;

      String localMessageId = messageData['local_message_id'] as String;
      db
          .collection('rooms')
          .doc(chatRoomId.toString())
          .collection('messages')
          .doc(localMessageId)
          .set(messageData);
    }
  }

  updateUnReadCount({required int roomId}) async {
    final room =
        await db.collection('unreadCountData').doc(roomId.toString()).get();
    Map<String, dynamic> roomData = {};

    if (room != null) {
      roomData['roomId'] = roomId;
      roomData['unreadCont'] = room['unreadCont'] + 1;
    } else {
      roomData['roomId'] = roomId;
      roomData['unreadCont'] = 1;
    }
    db.collection('unreadCountData').doc(roomId.toString()).set(roomData);
  }

  clearUnReadCount({required int roomId}) async {
    final room =
        await db.collection('unreadCountData').doc(roomId.toString()).get();
    Map<String, dynamic> roomData = {};

    if (room != null) {
      roomData['roomId'] = roomId;
      roomData['unreadCont'] = 0;
      db.collection('unreadCountData').doc(roomId.toString()).set(roomData);
    }
  }

  Future<List<ChatRoomModel>> mapUnReadCount(List<ChatRoomModel> rooms) async {
    List<ChatRoomModel> mappedRooms = rooms;

    final items = await db.collection('unreadCountData').get();
    for (var doc in items?.values ?? []) {
      var matchedRooms =
          mappedRooms.where((element) => element.id == doc['roomId'] as int);
      if (matchedRooms.isNotEmpty) {
        matchedRooms.first.unreadMessages = doc['unreadCont'] as int;
      }
    }

    return mappedRooms;
  }
}
