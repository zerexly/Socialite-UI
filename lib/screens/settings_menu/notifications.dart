import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationController _notificationController = Get.find();

  @override
  void initState() {
    _notificationController.getNotifications();
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
            backNavigationBar(
                context: context, title: LocalizationString.notifications),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<NotificationController>(
                  init: _notificationController,
                  builder: (ctx) {
                    return _notificationController.notifications.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount:
                                _notificationController.notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  index == 0
                                      ? const SizedBox(height: 20)
                                      : Container(),
                                  NotificationTileType4(
                                          notification: _notificationController
                                              .notifications[index])
                                      .hP16
                                      .ripple(() {
                                    handleNotificationTap(
                                        _notificationController
                                            .notifications[index]);
                                  }),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(height: 20);
                            })
                        : emptyData(
                            title: LocalizationString.noNotificationFound,
                            subTitle: '',
                            context: context);
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
