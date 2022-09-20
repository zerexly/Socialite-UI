import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

showNewMessageBanner(ChatMessageModel message){
  ApiController().getOtherUser(message.senderId.toString()).then((response) {

    showOverlayNotification((context) {
      return Container(
        color: Colors.transparent,
        child: Container(
          color: Theme.of(context).cardColor.lighten(),
          child: ListTile(
            leading: UserAvatarView(
              size: 40,
              user: response.user!,
            ),
            title: Text(
              response.user!.userName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(message.shortInfo,
                style: Theme.of(context).textTheme.titleSmall),
          ).setPadding(top: 60, left: 16, right: 16).ripple(() {
            OverlaySupportEntry.of(context)!.dismiss();

            Get.to(() => ChatDetail(opponent: response.user!, chatRoom: null,));
          }),
        ).shadow(context: context).round(15),
      );
    }, duration: const Duration(milliseconds: 4000));
  });
}