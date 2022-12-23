import 'dart:convert';
import 'dart:math';
import 'package:foap/helper/common_import.dart';
import 'package:path/path.dart' as p;

class DBManager {
  // final db = Localstore.instance;
  late Database database;
  var random = Random.secure();

  createDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, 'socialified.db');

    try {
      await Directory(databasesPath).create(recursive: true);

      print('openDatabase');
      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE StoryViewHistory (storyId INTEGER PRIMARY KEY, time INTEGER)');
        await db.execute(
            'CREATE TABLE ChatRooms (id INTEGER PRIMARY KEY, title TEXT ,status INTEGER,type INTEGER,is_chat_user_online INTEGER, created_by INTEGER,created_at INTEGER,updated_at INTEGER,imageUrl TEXT,description TEXT,chat_access_group INTEGER,last_message_id TEXT,unread_messages_count INTEGER)');
        await db.execute(
            'CREATE TABLE Messages (local_message_id TEXT PRIMARY KEY, id INTEGER, room_id INTEGER,messageType INTEGER, message TEXT,username TEXT, created_by INTEGER,created_at INTEGER,viewed_at INTEGER,isDeleted INTEGER,isStar INTEGER,deleteAfter INTEGER,status INTEGER,encryption_key TEXT)');
        await db.execute(
            'CREATE TABLE ChatRoomMembers (id INTEGER PRIMARY KEY, room_id INTEGER, user_id INTEGER,is_admin INTEGER,user TEXT)');
        await db.execute(
            'CREATE TABLE UsersCache (id INTEGER PRIMARY KEY, username TEXT,email TEXT,picture TEXT)');
      });
    } catch (_) {}
  }

  storyViewed(StoryMediaModel story) async {
    //save the item
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO StoryViewHistory(storyId, time) VALUES(${story.id},"${story.createdAtDate}")');
    });

    // db
    //     .collection('viewedStories')
    //     .doc(story.id.toString())
    //     .set({'storyId': story.id, 'time': story.createdAtDate});
  }

  Future<List<int>> getAllViewedStories() async {
    List<int> ids = [];

    List<Map> list = await database.rawQuery('SELECT * FROM StoryViewHistory');

    // final items = await db.collection('viewedStories').get();
    for (var doc in list) {
      ids.add((doc as Map<String, dynamic>)['storyId']);
    }

    return ids;
  }

  clearOldStories() async {
    // final items = await db.collection('viewedStories').get();
    int currentEpochTime = DateTime.now().millisecondsSinceEpoch;

    await database.rawDelete(
        'DELETE  FROM StoryViewHistory WHERE time > ${currentEpochTime - 86400000}');

    // for (Map<String, dynamic> doc in items?.values ?? []) {
    //   if (currentEpochTime - doc['time'] > 86400000) {
    //     //delete old story
    //     db.collection('viewedStories').doc(doc['storyId'].toString()).delete();
    //   }
    // }
  }

  //******************** Chat ************************//

  Future saveRooms(List<ChatRoomModel> chatRooms) async {
    for (ChatRoomModel room in chatRooms) {
      saveRoom(room);
    }
  }

  Future saveRoom(ChatRoomModel chatRoom) async {
    ChatRoomModel? room = await getRoomById(chatRoom.id);
    if (room == null) {
      //   var json = chatRoom.toJson();
      // json['updated_at'] = chatRoom.createdAt;
      // await db.collection('rooms').doc(chatRoom.id.toString()).set(json);
      var batch = database.batch();

      // await database.transaction((txn) async {
      batch.rawInsert(
          'INSERT INTO ChatRooms(id, title, status,type,is_chat_user_online,created_by,created_at,updated_at,imageUrl,description,chat_access_group) VALUES(${chatRoom.id},"${chatRoom.name}", ${chatRoom.status},${chatRoom.type}, ${chatRoom.isOnline},${chatRoom.createdBy},${chatRoom.createdAt},${chatRoom.createdAt},"${chatRoom.image}","${chatRoom.description}",${chatRoom.groupAccess})');

      for (ChatRoomMember member in chatRoom.roomMembers) {
        // await addUserInRoom(member, chatRoom);
        batch.rawInsert(
          'INSERT INTO ChatRoomMembers(id, room_id, user_id,is_admin) VALUES(${member.id}, ${member.roomId}, ${member.userId},${member.isAdmin})',
        );

        batch.rawDelete(
          'DELETE  FROM UsersCache WHERE id = ${member.userDetail.id}',
        );

        batch.rawInsert(
          'INSERT INTO UsersCache(id, username,email,picture) VALUES(${member.userDetail.id}, "${member.userDetail.userName}", "${member.userDetail.email}","${member.userDetail.picture}")',
        );
      }
      await batch.commit(noResult: true);

      // });
    }
  }

  Future updateRoom(ChatRoomModel chatRoom) async {
    ChatRoomModel? room = await getRoomById(chatRoom.id);
    ChatMessageModel? lastMessage = room?.lastMessage;
    int? updateAt = room?.updatedAt;

    // var chatRoomJson = chatRoom.toJson();
    // if (lastMessage != null) {
    //   chatRoomJson['lastMessage'] = lastMessage;
    // }
    // chatRoomJson['updated_at'] = updateAt;

    var batch = database.batch();

    // await database.transaction((txn) async {
    batch.rawUpdate('UPDATE ChatRooms '
        'SET title = "${chatRoom.name}",'
        'status = ${chatRoom.status},'
        'type = ${chatRoom.type},'
        'is_chat_user_online = ${chatRoom.isOnline},'
        'updated_at = $updateAt,'
        'imageUrl = "${chatRoom.image}",'
        'description = "${chatRoom.description}",'
        'chat_access_group = ${chatRoom.groupAccess},'
        'last_message_id = "${lastMessage?.localMessageId}" '
        'WHERE id = ${chatRoom.id}');
    for (ChatRoomMember member in chatRoom.roomMembers) {
      // await addUserInRoom(member, chatRoom);
      batch.rawDelete(
          'DELETE  FROM ChatRoomMembers WHERE room_id = ${member.roomId} AND user_id = ${member.userId}');

      batch.rawInsert(
        'INSERT INTO ChatRoomMembers(id, room_id, user_id,is_admin) VALUES(${member.id}, ${member.roomId}, ${member.userId},${member.isAdmin})',
      );

      batch.rawDelete(
        'DELETE  FROM UsersCache WHERE id = ${member.userDetail.id}',
      );

      batch.rawInsert(
        'INSERT INTO UsersCache(id, username,email,picture) VALUES(${member.userDetail.id}, "${member.userDetail.userName}", "${member.userDetail.email}","${member.userDetail.picture}")',
      );
      // print('inserted2: $id2');
    }
    await batch.commit(noResult: true);

    // });
    // if (room == null) {
    // await db.collection('rooms').doc(chatRoom.id.toString()).set(chatRoomJson);

    // for (ChatRoomMember user in chatRoom.roomMembers) {
    //   await addUserInRoom(user, chatRoom);
    // }
    // }
  }

  // Future addUserInRoom(ChatRoomMember user, ChatRoomModel chatRoom) async {
  //   final member = await db
  //       .collection('roomsUsers')
  //       .doc(chatRoom.id.toString())
  //       .collection('members')
  //       .doc(user.id.toString())
  //       .get();
  //
  //   if (member == null) {
  //     await db
  //         .collection('roomsUsers')
  //         .doc(chatRoom.id.toString())
  //         .collection('members')
  //         .doc(user.id.toString())
  //         .set(user.toJson());
  //   }
  // }

  Future<List<ChatRoomMember>> getAllMembersInRoom(int roomId) async {
    List<Map> list = await database
        .rawQuery('SELECT * FROM ChatRoomMembers WHERE room_id = $roomId');

    // final result = await db
    //     .collection('roomsUsers')
    //     .doc(roomId.toString())
    //     .collection('members')
    //     .get();
    //
    // List dbUsers = (result?.values ?? []).toList();

    List<ChatRoomMember> membersArr = [];

    for (var user in list) {
      List<Map> userData = await database
          .rawQuery('SELECT * FROM UsersCache WHERE id = ${user["user_id"]}');

      Map<String, dynamic> userDetail = Map<String, dynamic>.from(user);

      userDetail['user'] = userData.first;
      ChatRoomMember userModel = ChatRoomMember.fromJson(userDetail);
      membersArr.add(userModel);
    }
    return membersArr;
  }

  saveAsLastMessageInRoom(
      {required int roomId, required ChatMessageModel chatMessage}) async {
    // var roomData = await db.collection('rooms').doc(roomId.toString()).get();
    // roomData!['lastMessage'] = chatMessage.toJson();
    // roomData['updated_at'] = chatMessage.createdAt;
    //
    // db.collection('rooms').doc(roomId.toString()).set(roomData);
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE ChatRooms '
          'SET '
          'updated_at = ${chatMessage.createdAt},'
          'last_message_id = "${chatMessage.localMessageId}" '
          'WHERE id = $roomId');
    });
  }

  Future<List<ChatRoomModel>> getAllRooms() async {
    List<Map> dbRooms = await database.rawQuery('SELECT * FROM ChatRooms');
    List<Map> updateAbleRoomJson = List<Map>.from(dbRooms);
    // final items = await db.collection('rooms').get();

    List<ChatRoomModel> rooms = [];

    // List dbRooms = (items?.values ?? []).toList();
    updateAbleRoomJson.sort((a, b) {
      if (b['updated_at'] == null || a['updated_at'] == null) {
        return 0;
      }
      return b['updated_at'].compareTo(a['updated_at']);
    });

    for (Map roomJson in updateAbleRoomJson) {
      List<Map> userData = await database.rawQuery(
          'SELECT * FROM UsersCache WHERE id = ${roomJson["created_by"]}');

      Map<String, dynamic> updateAbleRoomJson =
          Map<String, dynamic>.from(roomJson);

      updateAbleRoomJson['createdByUser'] = userData.first;
      ChatRoomModel room = ChatRoomModel.fromJson(updateAbleRoomJson);
      List<ChatRoomMember> usersInRoom = await getAllMembersInRoom(room.id);
      room.roomMembers = usersInRoom;
      if (room.amIMember) {
        rooms.add(room);
      }
    }
    return rooms;
  }

  Future<ChatRoomModel?> getRoomById(int roomId) async {
    List<Map> dbRooms =
        await database.rawQuery('SELECT * FROM ChatRooms WHERE id = $roomId');
    // final items = await db.collection('rooms').get();
    // List dbRooms = (items?.values ?? []).toList();
    // dbRooms = dbRooms.where((element) => element['id'] == roomId).toList();

    if (dbRooms.isNotEmpty) {
      Map<String, dynamic> roomJson = dbRooms.first as Map<String, dynamic>;

      List<Map> userData = await database.rawQuery(
          'SELECT * FROM UsersCache WHERE id = ${roomJson["created_by"]}');

      print('roomJson["created_by"] ${roomJson["created_by"]}');
      Map<String, dynamic> updatedRoomJson =
          Map<String, dynamic>.from(roomJson);

      updatedRoomJson['createdByUser'] = userData.first;
      ChatRoomModel chatRoom = ChatRoomModel.fromJson(updatedRoomJson);
      return chatRoom;
    }
    return null;
  }

  saveMessage(ChatRoomModel chatRoom, ChatMessageModel chatMessage) async {
    if (chatMessage.isMineMessage) {
      chatMessage.viewedAt = DateTime.now().millisecondsSinceEpoch;
    }

    // final encryptionKey =
    //     encrypt.Key.fromUtf8(AppConfigConstants.chatMessageEncryptionKey);
    // final iv = encrypt.IV.fromLength(16);
    //
    // final encrypter = encrypt.Encrypter(encrypt.AES(encryptionKey));
    //
    // final encryptedMessageContent =
    //     encrypter.encrypt(chatMessage.messageContent, iv: iv);

    await database.transaction((txn) async {
      await txn.rawInsert('INSERT INTO Messages(local_message_id, '
          'id,'
          'room_id,'
          'messageType, '
          'message,'
          'username, '
          'created_by,'
          'created_at,'
          'viewed_at,'
          'isDeleted,'
          'isStar,'
          'deleteAfter) VALUES('
          '"${chatMessage.localMessageId}",'
          '${chatMessage.id},'
          '"${chatRoom.id}", '
          '${chatMessage.messageType},'
          '${jsonEncode(chatMessage.messageContent.replaceAll('"', '****doubleQuote****'))}, '
          '"${chatMessage.userName}",'
          '${chatMessage.senderId},'
          '${chatMessage.createdAt},'
          '${chatMessage.viewedAt},'
          '"${chatMessage.isDeleted}",'
          '"${chatMessage.isStar}",'
          '${chatMessage.deleteAfter})');
    });

    // db
    //     .collection('rooms')
    //     .doc(chatRoom.id.toString())
    //     .collection('messages')
    //     .doc(chatMessage.localMessageId.toString())
    //     .set(chatMessage.toJson());

    //need to check, not sure why added
    // getAllMessages(chatRoom.id);

    if (chatMessage.isDateSeparator == false &&
        chatMessage.messageContentType != MessageContentType.groupAction) {
      saveAsLastMessageInRoom(roomId: chatRoom.id, chatMessage: chatMessage);
    }
  }

  Future<List<ChatMessageModel>> getAllMessages(int roomId) async {
    List<ChatMessageModel> messages = [];
    List<ChatMessageModel> messagesToDelete = [];
    List<ChatMessageModel> messagesToUpdate = [];

    await getApplicationDocumentsDirectory();

    // final items = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .get();

    List<Map> dbMessages = await database
        .rawQuery('SELECT * FROM Messages WHERE room_id = $roomId');
    List<Map> updateAbleDbMessages = List<Map>.from(dbMessages);

    String? lastMessageDate;

    // List dbMessages = (items?.values ?? []).toList();
    updateAbleDbMessages
        .sort((a, b) => a['created_at'].compareTo(b['created_at']));

    for (var doc in updateAbleDbMessages) {
      ChatMessageModel message =
          ChatMessageModel.fromJson((doc as Map<String, dynamic>));
      int timeDifference = 0;
      print('message.viewedAt = ${message.viewedAt}');
      print('message.deleteAfter = ${message.deleteAfter}');

      if (message.viewedAt != null) {
        final date2 = DateTime.now();
        DateTime viewAtDateTime =
            DateTime.fromMillisecondsSinceEpoch(message.viewedAt!);
        timeDifference = date2.difference(viewAtDateTime).inSeconds;
      } else {
        messagesToUpdate.add(message);
      }

      // print('timeDifference = ${timeDifference}');
      // print(
      //     'getIt<UserProfileManager>().user!.chatDeleteTime = ${getIt<UserProfileManager>().user!.chatDeleteTime}');

      if (timeDifference < getIt<UserProfileManager>().user!.chatDeleteTime) {
        String dateTimeStr = message.date;
        if (dateTimeStr != lastMessageDate &&
            message.isDateSeparator == false) {
          ChatMessageModel separatorMessage = ChatMessageModel();
          separatorMessage.createdAt = message.createdAt;
          separatorMessage.isDateSeparator = true;
          messages.add(separatorMessage);
          lastMessageDate = dateTimeStr;
        }
        messages.add(message);
      } else {
        messagesToDelete.add(message);
      }
    }

    ChatRoomModel? chatRoom = await getRoomById(roomId);

    if (chatRoom != null) {
      hardDeleteMessages(messages: messagesToDelete);
    }
    if (messagesToUpdate.isNotEmpty) {
      updateMessageViewedTime(messagesToUpdate);
    }

    return messages;
  }

  updateMessageContent(
      int roomId, String localMessageId, String content) async {
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE Messages '
          'SET '
          'message = $content '
          'WHERE local_message_id = "$localMessageId"');
    });

    // var message = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .doc(localMessageId.toString())
    //     .get();
    //
    // if (message != null) {
    //   // var messageData = matchedMessages.first;
    //   message['message'] = content;
    //   db
    //       .collection('rooms')
    //       .doc(roomId.toString())
    //       .collection('messages')
    //       .doc(localMessageId.toString())
    //       .set(message);
    // }
  }

  updateMessageViewedTime(List<ChatMessageModel> messages) async {
    for (ChatMessageModel message in messages) {
      await database.transaction((txn) async {
        await txn.rawUpdate('UPDATE Messages '
            'SET '
            'viewed_at = ${DateTime.now().millisecondsSinceEpoch} '
            'WHERE local_message_id = "${message.localMessageId}"');
      });

      // var dbMessage = await db
      //     .collection('rooms')
      //     .doc(message.roomId.toString())
      //     .collection('messages')
      //     .doc(message.localMessageId.toString())
      //     .get();
      //
      // if (dbMessage != null) {
      //   dbMessage['viewed_at'] = DateTime.now().millisecondsSinceEpoch;
      //   db
      //       .collection('rooms')
      //       .doc(message.roomId.toString())
      //       .collection('messages')
      //       .doc(message.localMessageId.toString())
      //       .set(dbMessage);
      // }
    }
  }

  updateMessageStatus(
      {required int roomId,
      required String localMessageId,
      required int id,
      required int status}) async {
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE Messages '
          'SET '
          'status = $status,'
          'id = $id '
          'WHERE local_message_id = "$localMessageId"');
    });

    // var message = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .doc(localMessageId.toString())
    //     .get();
    //
    // if (message != null) {
    //   message['id'] = id;
    //   message['status'] = status;
    //   db
    //       .collection('rooms')
    //       .doc(roomId.toString())
    //       .collection('messages')
    //       .doc(localMessageId.toString())
    //       .set(message);
    // }
  }

  starUnStarMessage(
      {required int roomId,
      required String localMessageId,
      required int isStar}) async {
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE Messages '
          'SET '
          'isStar = $isStar '
          'WHERE local_message_id = "$localMessageId"');
    });

    // var message = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .doc(localMessageId.toString())
    //     .get();
    //
    // if (message != null) {
    //   message['isStar'] = isStar;
    //
    //   db
    //       .collection('rooms')
    //       .doc(roomId.toString())
    //       .collection('messages')
    //       .doc(localMessageId.toString())
    //       .set(message);
    // }
  }

  Future<List<ChatMessageModel>> getMessages(
      {required int roomId, required MessageContentType contentType}) async {
    List<ChatMessageModel> messages = [];

    List<Map> dbMessages = await database
        .rawQuery('SELECT * FROM Messages WHERE room_id = $roomId');

    print('dbMessages = ${dbMessages.length}');
    // final items = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .get();
    for (var doc in dbMessages) {
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
    List<Map> dbMessages = await database
        .rawQuery('SELECT * FROM Messages WHERE room_id = $roomId');

    // final items = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .get();
    for (var doc in dbMessages) {
      messages.add(ChatMessageModel.fromJson((doc as Map<String, dynamic>)));
    }
    messages = messages.where((element) => element.isStar == 1).toList();
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  Future<List<ChatMessageModel>> getMessagesById(
      {required int messageId, required int roomId}) async {
    List<ChatMessageModel> messages = [];

    List<Map> dbMessages = await database.rawQuery(
        'SELECT * FROM Messages WHERE room_id = $roomId AND id = $messageId');

    // final items = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .get();
    for (var doc in dbMessages) {
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
    // final items = await db
    //     .collection('rooms')
    //     .doc(roomId.toString())
    //     .collection('messages')
    //     .get();
    List<Map> dbMessages = await database.rawQuery(
        'SELECT * FROM Messages WHERE room_id = $roomId AND (type = 2 || type = 3 || type = 4)');

    for (var doc in dbMessages) {
      messages.add(ChatMessageModel.fromJson((doc as Map<String, dynamic>)));
    }
    // messages = messages
    //     .where((element) =>
    //         element.messageContentType == MessageContentType.photo ||
    //         element.messageContentType == MessageContentType.video)
    //     .toList();
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  deleteRoom(ChatRoomModel chatRoom) async {
    // await db.collection('rooms').doc(chatRoom.id.toString()).delete();

    await database.transaction((txn) async {
      await database
          .rawDelete('DELETE FROM ChatRooms WHERE id = ${chatRoom.id}');
      await database
          .rawDelete('DELETE FROM Messages WHERE room_id = ${chatRoom.id}');
    });

    // List<ChatMessageModel> messages = await getAllMessages(chatRoom.id);
    // hardDeleteMessages(chatRoom: chatRoom, messages: messages);
    getIt<FileManager>().deleteRoomMedia(chatRoom);
  }

  hardDeleteMessages({required List<ChatMessageModel> messages}) async {
    var batch = database.batch();

    for (ChatMessageModel message in messages) {
      // await database.transaction((txn) async {
      batch.rawDelete(
          'DELETE FROM Messages WHERE local_message_id = "${message.localMessageId}"');
      // });

      // db
      //     .collection('rooms')
      //     .doc(chatRoom.id.toString())
      //     .collection('messages')
      //     .doc(message.localMessageId.toString())
      //     .delete()
      //     .then((value) {});

      if (message.isMediaMessage) {
        getIt<FileManager>().deleteMessageMedia(message);
      }
    }
    await batch.commit(noResult: true);
  }

  deleteMessages(
      {required ChatRoomModel chatRoom,
      required List<ChatMessageModel> messagesToDelete}) async {
    // final items = await db
    //     .collection('rooms')
    //     .doc(chatRoom.id.toString())
    //     .collection('messages')
    //     .get();

    // var messages = items?.values ?? [];
    var batch = database.batch();

    for (ChatMessageModel message in messagesToDelete) {
      // await database.transaction((txn) async {
      batch.rawUpdate('UPDATE Messages '
          'SET '
          'isDeleted = 1 '
          'WHERE id = ${message.id} OR local_message_id = "${message.localMessageId}"');
      // });

      // var matchedMessages = messages.where((element) =>
      //     element['id'] == message.id ||
      //     element['local_message_id'] == message.localMessageId);
      // if (matchedMessages.isNotEmpty) {
      //   var messageData = matchedMessages.first;
      //   messageData['isDeleted'] = 1;
      //
      //   db
      //       .collection('rooms')
      //       .doc(chatRoom.id.toString())
      //       .collection('messages')
      //       .doc(message.localMessageId.toString())
      //       .set(messageData);
      // }
    }
    await batch.commit(noResult: true);
  }

  messagedDeletedByOtherUser(
      {required int chatRoomId, required int messageId}) async {
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE Messages '
          'SET '
          'isDeleted = 1 '
          'WHERE id = $messageId');
    });

    // final items = await db
    //     .collection('rooms')
    //     .doc(chatRoomId.toString())
    //     .collection('messages')
    //     .get();
    //
    // var messages = items?.values ?? [];
    //
    // var matchedMessages =
    //     messages.where((element) => element['id'] == messageId);
    //
    // if (matchedMessages.isNotEmpty) {
    //   var messageData = matchedMessages.first;
    //   messageData['isDeleted'] = 1;
    //
    //   String localMessageId = messageData['local_message_id'] as String;
    //   db
    //       .collection('rooms')
    //       .doc(chatRoomId.toString())
    //       .collection('messages')
    //       .doc(localMessageId)
    //       .set(messageData);
    // }
  }

  updateUnReadCount({required int roomId}) async {
    ChatRoomModel? room = await getRoomById(roomId);

    if (room != null) {
      await database.transaction((txn) async {
        await txn.rawUpdate('UPDATE ChatRooms '
            'SET '
            'unread_messages_count = ${room.unreadMessages + 1}'
            'WHERE id = $roomId');
      });
    }

    // final room =
    //     await db.collection('unreadCountData').doc(roomId.toString()).get();
    // Map<String, dynamic> roomData = {};
    //
    // if (room != null) {
    //   roomData['roomId'] = roomId;
    //   roomData['unreadCount'] = (room['unreadCount'] ?? 0) + 1;
    // } else {
    //   roomData['roomId'] = roomId;
    //   roomData['unreadCount'] = 1;
    // }
    // db.collection('unreadCountData').doc(roomId.toString()).set(roomData);
  }

  Future<int> roomsWithUnreadMessages() async {
    List<Map> rooms = await database
        .rawQuery('SELECT * FROM ChatRooms WHERE unread_messages_count > 0');

    // final rooms = await db.collection('unreadCountData').get();

    return rooms.length;
  }

  clearUnReadCount({required int roomId}) async {
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE ChatRooms '
          'SET '
          'unread_messages_count = 0 '
          'WHERE id = $roomId');
    });

    // await db.collection('unreadCountData').doc(roomId.toString()).delete();
  }

  clearAllUnreadCount() async {
    await database.transaction((txn) async {
      await txn.rawUpdate('UPDATE ChatRooms '
          'SET '
          'unread_messages_count = 0');
    });

    // final items = await db.collection('unreadCountData').get();
    //
    // for (Map<String, dynamic> doc in items?.values ?? []) {
    //   db.collection('unreadCountData').doc(doc['roomId'].toString()).delete();
    // }
  }

// Future<List<ChatRoomModel>> mapUnReadCount(List<ChatRoomModel> rooms) async {
//   List<ChatRoomModel> mappedRooms = rooms;
//
//   final items = await db.collection('unreadCountData').get();
//   for (var doc in items?.values ?? []) {
//     var matchedRooms =
//         mappedRooms.where((element) => element.id == doc['roomId'] as int);
//     if (matchedRooms.isNotEmpty) {
//       matchedRooms.first.unreadMessages = doc['unreadCount'] as int;
//     }
//   }
//
//   return mappedRooms;
// }
}
