import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

showNewMessageBanner(ChatMessageModel message, int room) {
  ApiController().getChatRoomDetail(room).then((response) {
    showOverlayNotification((context) {
      return Container(
        color: Colors.transparent,
        child: Container(
          color: Theme.of(context).cardColor.lighten(),
          child: ListTile(
            leading: AvatarView(
              size: 40,
              url: response.room?.isGroupChat == true
                  ? response.room!.image
                  : response.room!
                      .memberById(message.senderId)
                      .userDetail
                      .picture,
              name: response.room?.isGroupChat == true
                  ? response.room!.name
                  : response.room!
                      .memberById(message.senderId)
                      .userDetail
                      .userName,
            ),
            title: Text(
              response.room?.isGroupChat == true
                  ? '(${response.room!.name}) ${response.room!.memberById(message.senderId).userDetail.userName}'
                  : response.room!
                      .memberById(message.senderId)
                      .userDetail
                      .userName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(message.shortInfo,
                style: Theme.of(context).textTheme.titleSmall),
          ).setPadding(top: 60, left: 16, right: 16).ripple(() {
            OverlaySupportEntry.of(context)!.dismiss();

            Get.to(() => ChatDetail(
                  chatRoom: response.room!,
                ));
          }),
        ).shadow(context: context).round(15),
      );
    }, duration: const Duration(milliseconds: 4000));
  });
}
