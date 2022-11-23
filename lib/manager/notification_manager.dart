import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:foap/helper/common_import.dart';
import 'package:push/push.dart';
import 'package:get/get.dart';

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onMessage.listen(
          (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
    // With this token you can test it easily on your phone
    _firebaseMessaging.getToken().then((fcmToken) {
      if (fcmToken != null) {
        SharedPrefs().setFCMToken(fcmToken);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      SharedPrefs().setFCMToken(fcmToken);
    }).onError((err) {});
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}

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
      } else if (action.buttonKeyPressed == "decline") {
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
      String? callType = data['callType'] as String?;

      if (callType != null) {
        handleCallNotification(data);
      } else {
        parseNotificationData(data, true);
      }
    });

    // Handle push notifications
    Push.instance.onMessage.listen((message) {
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
                        : notificationType == 101
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
    int notificationType = int.parse(data['notification_type'] as String);

    if (notificationType == 104) {
      //call cancelled by caller
      AwesomeNotifications().dismissAllNotifications();
    } else {
      // new call
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
  }

  parseNotificationData(dynamic data, bool isInForeground) {
    int notificationType =
        int.parse(data['notification_type'] as String? ?? '0');

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
              competitionId: referenceId,
              refreshPreviousScreen: () {},
            ));
      } else if (notificationType == 100) {
        // print(data);
        int? roomId = data['room'] as int?;
        if (roomId != null) {
          ApiController().getChatRoomDetail(roomId).then((response) {
            if (response.room != null) {
              Get.to(
                  () => ChatDetail(chatRoom: response.room!));
            }
          });
        }
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
