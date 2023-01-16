import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

showNewMessageBanner(ChatMessageModel message, int roomId) async {
  ChatRoomModel? room = await getIt<DBManager>().getRoomById(roomId);
  if (room == null) {
    ApiController().getChatRoomDetail(roomId).then((response) {
      if (response.room != null) {
        showNotification(message, response.room!);
      }
    });
  } else {
    showNotification(message, room);
  }
}

showNotification(ChatMessageModel message, ChatRoomModel room) {
  showOverlayNotification((context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        color: Theme.of(context).cardColor.lighten(),
        child: ListTile(
          leading: AvatarView(
            size: 40,
            url: room.isGroupChat == true
                ? room.image
                : room.memberById(message.senderId).userDetail.picture,
            name: room.isGroupChat == true
                ? room.name
                : room.memberById(message.senderId).userDetail.userName,
          ),
          title: Text(
            room.isGroupChat == true
                ? '(${room.name}) ${room.memberById(message.senderId).userDetail.userName}'
                : room.memberById(message.senderId).userDetail.userName,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).primaryColor),
          ),
          subtitle: Text(message.shortInfoForNotification,
              style: Theme.of(context).textTheme.titleSmall),
        ).setPadding(top: 60, left: 16, right: 16).ripple(() {
          OverlaySupportEntry.of(context)!.dismiss();

          Get.to(() => ChatDetail(
                chatRoom: room,
              ));
        }),
      ).shadow(context: context).round(15),
    );
  }, duration: const Duration(milliseconds: 4000));
}
