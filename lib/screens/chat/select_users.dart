import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectUserForChat extends StatefulWidget {
  const SelectUserForChat({Key? key}) : super(key: key);

  @override
  SelectUserForChatState createState() => SelectUserForChatState();
}

class SelectUserForChatState extends State<SelectUserForChat> {
  final ProfileController profileController = Get.find();
  final AgoraCallController agoraCallController = Get.find();

  @override
  void initState() {
    super.initState();

    profileController.clear();
    profileController.getFollowingUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 340,
          color: Theme.of(context).cardColor,
          child: GetBuilder<ProfileController>(
              init: profileController,
              builder: (ctx) {
                ScrollController scrollController = ScrollController();
                scrollController.addListener(() {
                  if (scrollController.position.maxScrollExtent ==
                      scrollController.position.pixels) {
                    if (!profileController.followingIsLoading) {
                      profileController.getFollowingUsers();
                    }
                  }
                });

                List<UserModel> usersList = profileController.following;
                return profileController.followingIsLoading
                    ? const ShimmerUsers().hP16
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 20, bottom: 50),
                        controller: scrollController,
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          return UserTile(
                            profile: usersList[index],
                            viewCallback: () {
                              Get.back();
                              // widget.selectedUser(usersList[index]);
                              Get.to(() => ChatDetail(
                                    opponent: usersList[index],
                                    chatRoom: null,
                                  ));
                            },
                            audioCallCallback: () {
                              Get.back();
                              initiateAudioCall(context, usersList[index]);
                            },
                            chatCallback: () {
                              Get.back();
                              Get.to(() => ChatDetail(
                                    opponent: usersList[index],
                                    chatRoom: null,
                                  ));
                            },
                            videoCallCallback: () {
                              Get.back();
                              initiateVideoCall(context, usersList[index]);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      ).hP16;
              }),
        ).round(20).p16,
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: 50,
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).iconTheme.color,
                size: 25,
              ),
            ),
          ).circular.ripple(() {
            Get.back();
          }),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  void initiateVideoCall(BuildContext context, UserModel opponent) {
    PermissionUtils.requestPermission(
        [Permission.camera, Permission.microphone], context,
        isOpenSettings: false, permissionGrant: () async {
      Call call = Call(
          uuid: '',
          callId: 0,
          channelName: '',
          token: '',
          isOutGoing: true,
          callType: 2,
          opponent: opponent);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {}, permissionNotAskAgain: () {});
  }

  void initiateAudioCall(BuildContext context, UserModel opponent) {
    PermissionUtils.requestPermission([Permission.microphone], context,
        isOpenSettings: false, permissionGrant: () async {
      Call call = Call(
          uuid: '',
          callId: 0,
          channelName: '',
          token: '',
          isOutGoing: true,
          callType: 1,
          opponent: opponent);

      agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {}, permissionNotAskAgain: () {});
  }
}

class SelectUserToSendMessage extends StatefulWidget {
  final PostModel? post;
  final Function(UserModel) selectedUser;
  final Function(UserModel) sendToUserCallback;

  const SelectUserToSendMessage({
    Key? key,
    required this.selectedUser,
    required this.sendToUserCallback,
    this.post,
  }) : super(key: key);

  @override
  SelectUserToSendMessageState createState() => SelectUserToSendMessageState();
}

class SelectUserToSendMessageState extends State<SelectUserToSendMessage> {
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
    profileController.clear();
    profileController.getFollowingUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 340,
          color: Theme.of(context).backgroundColor,
          child: GetBuilder<ProfileController>(
              init: profileController,
              builder: (ctx) {
                ScrollController scrollController = ScrollController();
                scrollController.addListener(() {
                  if (scrollController.position.maxScrollExtent ==
                      scrollController.position.pixels) {
                    if (!profileController.followingIsLoading) {
                      profileController.getFollowingUsers();
                    }
                  }
                });

                List<UserModel> usersList = profileController.following;
                return profileController.followingIsLoading
                    ? const ShimmerUsers().hP16
                    : ListView.separated(
                        padding: const EdgeInsets.only(top: 20),
                        controller: scrollController,
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          UserModel user = usersList[index];
                          return ForwardMessageUserTile(
                            state: profileController.completedActionUsers
                                    .contains(user)
                                ? ButtonState.success
                                : profileController.failedActionUsers
                                        .contains(user)
                                    ? ButtonState.fail
                                    : profileController.processingActionUsers
                                            .contains(user)
                                        ? ButtonState.loading
                                        : ButtonState.idle,
                            profile: usersList[index],
                            sendCallback: () {
                              profileController.sendMessage(
                                  toUser: user, post: widget.post);
                              // widget.sendToUserCallback(usersList[index]);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      ).hP16;
              }),
        ).round(20).p16,
        const SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 50,
            width: 50,
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: ThemeIconWidget(
                ThemeIcon.close,
                color: Theme.of(context).iconTheme.color,
                size: 25,
              ),
            ),
          ).circular.ripple(() {
            Get.back();
          }),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
