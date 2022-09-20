import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class NotificationsScreen1 extends StatefulWidget {
  const NotificationsScreen1({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen1> createState() => _NotificationsScreen1State();
}

class _NotificationsScreen1State extends State<NotificationsScreen1> {
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    profileController.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            backNavigationBar(context, LocalizationString.notifications),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<ProfileController>(
                  init: profileController,
                  builder: (ctx) {
                    return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: profileController.notifications.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const SizedBox(height: 20)
                                  : Container(),
                              NotificationTileType4(
                                      notification: profileController
                                          .notifications[index])
                                  .hP16
                                  .ripple(() {
                                handleNotificationTap(
                                    profileController.notifications[index]);
                              }),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 20);
                        });
                  }),
            ),
          ],
        ));
  }

  handleNotificationTap(NotificationModel notification) {
    if (notification.type == 1) {
      int userId = notification.referenceId;
      Get.to(() => OtherUserProfile(userId: userId));
    } else if (notification.type == 2) {
      int postId = notification.referenceId;
      Get.to(() => CommentsScreen(postId: postId, handler: () {}));
    } else if (notification.type == 3) {
      Get.to(() => SinglePostDetail(postId: notification.referenceId));
    } else if (notification.type == 4) {
      int competitionId = notification.referenceId;
      Get.to(() => CompetitionDetailScreen(
            competition: null,
            competitionId: competitionId,
            refreshPreviousScreen: () {},
          ));
    } else if (notification.type == 7) {
      Get.to(() => SinglePostDetail(
            postId: notification.referenceId,
          ));
    }
  }
}
