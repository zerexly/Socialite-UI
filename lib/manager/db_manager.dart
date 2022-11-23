import 'package:foap/helper/common_import.dart';

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

  Future saveRooms(List<ChatRoomModel> chatRooms) async {
    for (ChatRoomModel room in chatRooms) {
      saveRoom(room);
    }
  }

  Future saveRoom(ChatRoomModel chatRoom) async {
    final room = await db.collection('rooms').doc(chatRoom.id.toString()).get();

    if (room == null) {
      var json = chatRoom.toJson();
      json['updated_at'] = chatRoom.createdAt;
      await db.collection('rooms').doc(chatRoom.id.toString()).set(json);

      for (ChatRoomMember user in chatRoom.roomMembers) {
        await addUserInRoom(user, chatRoom);
      }
    }
  }

  Future updateRoom(ChatRoomModel chatRoom) async {
    final room = await db.collection('rooms').doc(chatRoom.id.toString()).get();
    var lastMessage = room!['lastMessage'];
    var updateAt = room['updated_at'];

    var chatRoomJson = chatRoom.toJson();
    if (lastMessage != null) {
      chatRoomJson['lastMessage'] = lastMessage;
    }
    chatRoomJson['updated_at'] = updateAt;

    // if (room == null) {
    await db.collection('rooms').doc(chatRoom.id.toString()).set(chatRoomJson);

    for (ChatRoomMember user in chatRoom.roomMembers) {
      await addUserInRoom(user, chatRoom);
    }
    // }
  }

  Future addUserInRoom(ChatRoomMember user, ChatRoomModel chatRoom) async {
    final member = await db
        .collection('roomsUsers')
        .doc(chatRoom.id.toString())
        .collection('members')
        .doc(user.id.toString())
        .get();

    if (member == null) {
      await db
          .collection('roomsUsers')
          .doc(chatRoom.id.toString())
          .collection('members')
          .doc(user.id.toString())
          .set(user.toJson());
    }
  }

  Future<List<ChatRoomMember>> getAllUsersInRoom(int roomId) async {
    final result = await db
        .collection('roomsUsers')
        .doc(roomId.toString())
        .collection('members')
        .get();

    List dbUsers = (result?.values ?? []).toList();

    List<ChatRoomMember> membersArr = [];

    for (var user in dbUsers) {
      ChatRoomMember userModel = ChatRoomMember.fromJson(user);
      membersArr.add(userModel);
    }
    return membersArr;
  }

  saveAsLastMessageInRoom(
      {required int roomId, required ChatMessageModel chatMessage}) async {
    var roomData = await db.collection('rooms').doc(roomId.toString()).get();
    roomData!['lastMessage'] = chatMessage.toJson();
    roomData['updated_at'] = chatMessage.createdAt;

    db.collection('rooms').doc(roomId.toString()).set(roomData);
  }

  Future<List<ChatRoomModel>> getAllRooms() async {
    final items = await db.collection('rooms').get();
    List<ChatRoomModel> rooms = [];

    List dbRooms = (items?.values ?? []).toList();
    dbRooms.sort((a, b) {
      if (b['updated_at'] == null || a['updated_at'] == null) {
        return 0;
      }
      return b['updated_at'].compareTo(a['updated_at']);
    });

    for (var doc in dbRooms) {
      ChatRoomModel room =
          ChatRoomModel.fromJson((doc as Map<String, dynamic>));
      List<ChatRoomMember> usersInRoom = await getAllUsersInRoom(room.id);
      room.roomMembers = usersInRoom;
      if (room.amIMember) {
        rooms.add(room);
      }
    }
    return rooms;
  }

  Future<ChatRoomModel?> getRoomById(int roomId) async {
    final items = await db.collection('rooms').get();

    List dbRooms = (items?.values ?? []).toList();
    dbRooms = dbRooms.where((element) => element['id'] == roomId).toList();

    if (dbRooms.isNotEmpty) {
      ChatRoomModel chatRoom =
          ChatRoomModel.fromJson((dbRooms.first as Map<String, dynamic>));
      return chatRoom;
    }
    return null;
  }

  saveMessage(ChatRoomModel chatRoom, ChatMessageModel chatMessage) {
    db
        .collection('rooms')
        .doc(chatRoom.id.toString())
        .collection('messages')
        .doc(chatMessage.localMessageId.toString())
        .set(chatMessage.toJson());

    //need to check, not sure why added
    // getAllMessages(chatRoom.id);

    if (chatMessage.isDateSeparator == false &&
        chatMessage.messageContentType != MessageContentType.groupAction) {
      saveAsLastMessageInRoom(roomId: chatRoom.id, chatMessage: chatMessage);
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

  updateMessageContent(
      int roomId, String localMessageId, String content) async {
    var message = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .doc(localMessageId.toString())
        .get();

    // var messages = items?.values ?? [];
    // var matchedMessages = messages
    //     .where((element) => element['local_message_id'] == localMessageId);

    if (message != null) {
      // var messageData = matchedMessages.first;
      message['message'] = content;
      db
          .collection('rooms')
          .doc(roomId.toString())
          .collection('messages')
          .doc(localMessageId.toString())
          .set(message);
    }
  }

  updateMessageStatus(
      {required int roomId,
      required String localMessageId,
      required int id,
      required int status}) async {
    var message = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .doc(localMessageId.toString())
        .get();

    if (message != null) {
      message['id'] = id;
      message['status'] = status;
      // message['created_at'] = createdAt;

      db
          .collection('rooms')
          .doc(roomId.toString())
          .collection('messages')
          .doc(localMessageId.toString())
          .set(message);
    }
  }

  starUnStarMessage(
      {required int roomId,
      required String localMessageId,
      required int isStar}) async {
    var message = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .doc(localMessageId.toString())
        .get();

    if (message != null) {
      message['isStar'] = isStar;

      db
          .collection('rooms')
          .doc(roomId.toString())
          .collection('messages')
          .doc(localMessageId.toString())
          .set(message);
    }
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

  Future<List<ChatMessageModel>> getStarredMessages(
      {required int roomId}) async {
    List<ChatMessageModel> messages = [];
    final items = await db
        .collection('rooms')
        .doc(roomId.toString())
        .collection('messages')
        .get();
    for (var doc in items?.values ?? []) {
      messages.add(ChatMessageModel.fromJson((doc as Map<String, dynamic>)));
    }
    messages = messages.where((element) => element.isStar == 1).toList();
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
    await db.collection('rooms').doc(chatRoom.id.toString()).delete();
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

  messagedDeletedByOtherUser(
      {required int chatRoomId, required int messageId}) async {
    final items = await db
        .collection('rooms')
        .doc(chatRoomId.toString())
        .collection('messages')
        .get();

    var messages = items?.values ?? [];

    var matchedMessages =
        messages.where((element) => element['id'] == messageId);

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
      roomData['unreadCount'] = (room['unreadCount'] ?? 0) + 1;
    } else {
      roomData['roomId'] = roomId;
      roomData['unreadCount'] = 1;
    }
    db.collection('unreadCountData').doc(roomId.toString()).set(roomData);
  }

  Future<int> roomsWithUnreadMessages() async {
    final rooms = await db.collection('unreadCountData').get();

    return rooms?.length ?? 0;
  }

  clearUnReadCount({required int roomId}) async {
    await db.collection('unreadCountData').doc(roomId.toString()).delete();
  }

  clearAllUnreadCount() async {
    final items = await db.collection('unreadCountData').get();

    for (Map<String, dynamic> doc in items?.values ?? []) {
      db.collection('unreadCountData').doc(doc['roomId'].toString()).delete();
    }
  }

  Future<List<ChatRoomModel>> mapUnReadCount(List<ChatRoomModel> rooms) async {
    List<ChatRoomModel> mappedRooms = rooms;

    final items = await db.collection('unreadCountData').get();
    for (var doc in items?.values ?? []) {
      var matchedRooms =
          mappedRooms.where((element) => element.id == doc['roomId'] as int);
      if (matchedRooms.isNotEmpty) {
        matchedRooms.first.unreadMessages = doc['unreadCount'] as int;
      }
    }

    return mappedRooms;
  }
}
