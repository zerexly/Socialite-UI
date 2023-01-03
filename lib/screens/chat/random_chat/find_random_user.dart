import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class FindRandomUser extends StatefulWidget {
  final bool isCalling;

  const FindRandomUser({Key? key, required this.isCalling}) : super(key: key);

  @override
  State<FindRandomUser> createState() => _FindRandomUserState();
}

class _FindRandomUserState extends State<FindRandomUser> {
  final RandomChatAndCallController _randomChatAndCallController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    _randomChatAndCallController.getRandomOnlineUsers(true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _randomChatAndCallController.clear();
    super.dispose();
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
          backNavigationBar(context: context, title: 'Finding...'),
          divider(context: context).tP8,
          const Spacer(),
          Obx(() => _randomChatAndCallController.randomOnlineUser.value == null
              ? Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    RippleWave(
                      color: Theme.of(context).primaryColor,
                      childTween: Tween(begin: 0.2, end: 1),
                      child: const Icon(
                        Icons.emoji_emotions,
                        size: 100,
                        color: Colors.white,
                      ),
                    ).p(50),
                    const SizedBox(
                      height: 150,
                    ),
                    Text(
                      LocalizationString.findingPerfectUserToChat,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontWeight: FontWeight.w200),
                      textAlign: TextAlign.center,
                    ).hP25,
                  ],
                )
              : Column(
                  children: [
                    UserAvatarView(
                        size: 120,
                        user: _randomChatAndCallController
                            .randomOnlineUser.value!),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _randomChatAndCallController
                          .randomOnlineUser.value!.userName,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    widget.isCalling == true
                        ? callWidgets()
                        : SizedBox(
                            height: 50,
                            width: 250,
                            child: FilledButtonType1(
                                text: LocalizationString.chat,
                                onPress: () {
                                  EasyLoading.show(
                                      status: LocalizationString.loading);

                                  _chatDetailController.getChatRoomWithUser(
                                      userId:_randomChatAndCallController
                                          .randomOnlineUser.value!.id, callback:(room) {
                                    EasyLoading.dismiss();

                                    Get.back();
                                    Get.to(() => ChatDetail(
                                          // opponent: usersList[index - 1].toChatRoomMember,
                                          chatRoom: room,
                                        ));
                                  });
                                }),
                          ),
                  ],
                )),
          const Spacer(),
        ],
      ),
    );
  }

  Widget callWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Column(
            children: [
              const ThemeIconWidget(
                ThemeIcon.mobile,
                size: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                LocalizationString.audio,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
        ).round(10).shadow(context: context, shadowOpacity: 0.1).ripple(() {
          audioCall();
        }),
        const SizedBox(
          width: 20,
        ),
        Container(
          child: Column(
            children: [
              const ThemeIconWidget(
                ThemeIcon.videoCamera,
                size: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                LocalizationString.video,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
        ).round(10).shadow(context: context, shadowOpacity: 0.1).ripple(() {
          videoCall();
        }),
      ],
    );
  }

  void videoCall() {
    _chatDetailController.initiateVideoCall(context);
  }

  void audioCall() {
    _chatDetailController.initiateAudioCall(context);
  }
}
