import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:foap/helper/common_import.dart';
import 'package:push/push.dart';
import 'package:get/get.dart';

class NotificationManager {
  final AgoraLiveController agoraLiveController = Get.find();
  final AgoraCallController agoraCallController = Get.find();

  actionOnCall(Map<String, String?> data, bool accept) {
    String channelName = data['channelName'] as String;
    String token = data['token'] as String;
    String callType = data['callType'] as String;
    String id = data['id'] as String;
    String uuid = data['uuid'] as String;
    String callerId = data['callerId'] as String;

    ApiController().getOtherUser(callerId).then((response) {
      Call call = Call(
          uuid: uuid,
          channelName: channelName,
          isOutGoing: true,
          opponent: response.user!,
          token: token,
          callType: int.parse(callType),
          callId: int.parse(id));

      if (accept) {
        agoraCallController.acceptCall(call: call);
      } else {
        agoraCallController.declineCall(call: call);
      }
    });
  }

  initialize() {
    // flutterLocalNotificationsPlugin.initialize(const InitializationSettings());
    AwesomeNotifications().actionStream.listen((action) {
      AwesomeNotifications().dismissAllNotifications();

      if (action.buttonKeyPressed == "answer") {
        actionOnCall(action.payload!, true);
      } else if (action.buttonKeyPressed == "delete") {
        actionOnCall(action.payload!, false);
      }
    });

    Push.instance.onNewToken.listen((token) {
      // print("Just got a new FCM registration token: $token");
      SharedPrefs().setFCMToken(token);
    });

    // Handle notification launching app from terminated state
    Push.instance.notificationTapWhichLaunchedAppFromTerminated.then((data) {
      if (data == null) {
        // print("App was not launched by tapping a notification");
      } else {
        // print('Notification tap launched app from terminated state:\n'
        //     'RemoteMessage: ${data} \n');
        String? callType = data['callType'] as String?;

        if (callType != null) {
          handleCallNotification(data);
        } else {
          parseNotificationData(data, true);
        }
      }
    });

    // Handle notification taps
    Push.instance.onNotificationTap.listen((data) {
      // print('Notification was tapped:\n''Data: ${data} \n');
      String? callType = data['callType'] as String?;

      if (callType != null) {
        handleCallNotification(data);
      } else {
        parseNotificationData(data, true);
      }
    });

    // Handle push notifications
    Push.instance.onMessage.listen((message) {
      // print('RemoteMessage received while app is in foreground:\n'
      //     'RemoteMessage.Notification: ${message.notification} \n'
      //     ' title: ${message.notification?.title.toString()}\n'
      //     ' body: ${message.notification?.body.toString()}\n'
      //     'RemoteMessage.Data: ${message.data}');

      String? callType = message.data?['callType'] as String?;

      if (callType != null) {
        handleCallNotification(message.data!);
      } else {
        parseNotificationData(message.data, true);
      }
    });

    // Handle push notifications
    Push.instance.onBackgroundMessage.listen((message) async {
      String? callType = message.data?['callType'] as String?;

      if (callType != null) {
        handleCallNotification(message.data!);
      } else {
        if (Platform.isAndroid) {
          handleAndroidNotifications(message.data!);
        }
      }
    });
  }

  handleAndroidNotifications(Map<String?, Object?> data) {
    String message = data['body'] as String;
    int notificationType = int.parse(data['notification_type'] as String);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        //simple notification
        id: 123,
        channelKey: 'calls',
        //set configuration with key "basic"
        title: notificationType == 1
            ? 'New Follower'
            : notificationType == 2
                ? 'New comment'
                : notificationType == 4
                    ? 'New competition added'
                    : notificationType == 100
                        ? 'New message'
                        : notificationType == 100
                            ? 'Live'
                            : '',
        body: message,
        payload: {
          "reference_id": data['reference_id'] as String,
          "body": data['body'] as String,
          "notification_type": data['notification_type'] as String,
        },
        category: NotificationCategory.Event,
        displayOnBackground: true,
        wakeUpScreen: true,
        fullScreenIntent: true,
        displayOnForeground: true,
        autoDismissible: false,
      ),
    );
  }

  handleCallNotification(Map<String?, Object?> data) {
    String channelName = data['channelName'] as String;
    String token = data['token'] as String;
    String id = data['callType'] as String;
    String uuid = data['uuid'] as String;
    String callerId = data['callerId'] as String;
    String username = data['username'] as String;
    String callType = data['callType'] as String;

    AwesomeNotifications().createNotification(
        content: NotificationContent(
          //simple notification
          id: 123,
          channelKey: 'calls',
          //set configuration wuth key "basic"
          title: callType == '1' ? 'Audio call' : 'Video call',
          body: 'Call from $username',
          payload: {
            "channelName": channelName,
            "token": token,
            "callerId": callerId.toString(),
            "callType": callType,
            "id": id,
            "uuid": uuid
          },
          category: NotificationCategory.Call,
          displayOnBackground: true,
          wakeUpScreen: true,
          fullScreenIntent: true,
          displayOnForeground: true,
          autoDismissible: false,
        ),
        actionButtons: [
          NotificationActionButton(
            key: "answer",
            label: "Answer",
          ),
          NotificationActionButton(
            key: "decline",
            label: "Decline",
          )
        ]);
  }

  parseNotificationData(dynamic data, bool isInForeground) {
    int notificationType = int.parse(data['notification_type'] as String);

    if (isInForeground) {
      // show banner
      if (notificationType == 1) {
        int referenceId = int.parse(data['reference_id'] as String);
        String message = data['body'];

        // following notification
        ApiController().getOtherUser(referenceId.toString()).then((response) {
          showOverlayNotification((context) {
            return Container(
              color: Colors.transparent,
              child: Card(
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  leading: UserAvatarView(
                    size: 40,
                    user: response.user!,
                  ),
                  title: Text(
                    LocalizationString.newFollower,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(message,
                      style: Theme.of(context).textTheme.titleSmall),
                ).vp(12).ripple(() {
                  OverlaySupportEntry.of(context)!.dismiss();
                  Get.to(() => OtherUserProfile(userId: referenceId));
                }),
              ).setPadding(top: 50, left: 8, right: 8).round(10),
            );
          }, duration: const Duration(milliseconds: 4000));
        });
      } else if (notificationType == 2) {
        int referenceId = int.parse(data['reference_id'] as String);
        String message = data['title'];

        // comment notification
        showOverlayNotification((context) {
          return Container(
            color: Colors.transparent,
            child: Card(
              color: Theme.of(context).cardColor,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                title: Text(
                  LocalizationString.newComment,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).primaryColor),
                ),
                subtitle: Text(message,
                    style: Theme.of(context).textTheme.titleSmall),
              ).vp(12).ripple(() {
                OverlaySupportEntry.of(context)!.dismiss();
                Get.to(
                    () => CommentsScreen(postId: referenceId, handler: () {}));
              }),
            ).setPadding(top: 50, left: 8, right: 8).round(10),
          );
        }, duration: const Duration(milliseconds: 4000));
      } else if (notificationType == 4) {
        // new competition added notification
      } else if (notificationType == 100) {
      } else if (notificationType == 101) {
        int liveId = int.parse(data['liveCallId'] as String);
        String channelName = data['channelName'];
        String agoraToken = data['token'];
        int userId = int.parse(data['userId'] as String);
        String body = data['body'];

        ApiController().getOtherUser(userId.toString()).then((response) {
          // live notification
          showOverlayNotification((context) {
            return Container(
              color: Colors.transparent,
              child: Card(
                color: Theme.of(context).cardColor,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ListTile(
                  leading: UserAvatarView(
                    size: 40,
                    user: response.user!,
                  ),
                  title: Text(
                    LocalizationString.live,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor),
                  ),
                  subtitle:
                      Text(body, style: Theme.of(context).textTheme.titleSmall),
                ).vp(12).ripple(() {
                  OverlaySupportEntry.of(context)!.dismiss();

                  Live live = Live(
                      channelName: channelName,
                      isHosting: false,
                      host: response.user!,
                      token: agoraToken,
                      liveId: liveId);

                  agoraLiveController.joinAsAudience(live: live);
                }),
              ).setPadding(top: 50, left: 8, right: 8).round(10),
            );
          }, duration: const Duration(milliseconds: 4000));
        });
      }
    } else {
      // go to screen
      if (notificationType == 1) {
        int referenceId = int.parse(data['reference_id'] as String);
        // following notification
        Get.to(() => OtherUserProfile(userId: referenceId));
      } else if (notificationType == 2) {
        int referenceId = int.parse(data['reference_id'] as String);
        // comment notification
        Get.to(() => CommentsScreen(postId: referenceId, handler: () {}));
      } else if (notificationType == 4) {
        int referenceId = int.parse(data['reference_id'] as String);
        // new competition added notification
        Get.to(() => CompetitionDetailScreen(
              competition: null,
              competitionId: referenceId,
              refreshPreviousScreen: () {},
            ));
      } else if (notificationType == 100) {
        int userId = int.parse(data['userId'] as String);
        UserModel user = UserModel();
        user.id = userId;
        Get.to(() => ChatDetail(chatRoom: null, opponent: user));
      } else if (notificationType == 101) {
        int liveId = int.parse(data['liveCallId'] as String);
        String channelName = data['channelName'];
        String agoraToken = data['token'];
        int userId = int.parse(data['userId'] as String);

        ApiController().getOtherUser(userId.toString()).then((response) {
          Live live = Live(
              channelName: channelName,
              isHosting: false,
              host: response.user!,
              token: agoraToken,
              liveId: liveId);

          agoraLiveController.joinAsAudience(live: live);
        });
      }
    }
  }
}
