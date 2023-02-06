import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectUserForChat extends StatefulWidget {
  final Function(UserModel) userSelected;

  const SelectUserForChat({Key? key, required this.userSelected})
      : super(key: key);

  @override
  SelectUserForChatState createState() => SelectUserForChatState();
}

class SelectUserForChatState extends State<SelectUserForChat> {
  final SelectUserForChatController _selectUserForChatController = Get.find();
  final AgoraCallController _agoraCallController = Get.find();

  @override
  void initState() {
    super.initState();

    _selectUserForChatController.clear();
    _selectUserForChatController.getFollowingUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Theme.of(context).cardColor,
            width: double.infinity,
            child: Column(
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                // SearchBar(
                //         showSearchIcon: true,
                //         iconColor: Theme.of(context).primaryColor,
                //         onSearchChanged: (value) {
                //           selectUserForChatController.searchTextChanged(value);
                //         },
                //         onSearchStarted: () {
                //           //controller.startSearch();
                //         },
                //         onSearchCompleted: (searchTerm) {})
                //     .hP8,
                // divider(context: context).tP16,
                Expanded(
                  child: GetBuilder<SelectUserForChatController>(
                      init: _selectUserForChatController,
                      builder: (ctx) {
                        ScrollController scrollController = ScrollController();
                        scrollController.addListener(() {
                          if (scrollController.position.maxScrollExtent ==
                              scrollController.position.pixels) {
                            if (!_selectUserForChatController
                                .followingIsLoading) {
                              _selectUserForChatController.getFollowingUsers();
                            }
                          }
                        });

                        List<UserModel> usersList =
                            _selectUserForChatController.following;
                        return _selectUserForChatController.followingIsLoading
                            ? const ShimmerUsers().hP16
                            : usersList.isNotEmpty
                            ? ListView.separated(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 50),
                          controller: scrollController,
                          itemCount: usersList.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Container(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2),
                                        child: ThemeIconWidget(
                                          ThemeIcon.group,
                                          size: 20,
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ).p8)
                                        .circular,
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      LocalizationString.createGroup,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w900),
                                    )
                                  ],
                                ),
                              ).ripple(() {
                                Get.back();
                                Get.to(() =>
                                const SelectUserForGroupChat());
                              }).hP16;
                            } else if (index == 1) {
                              return SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Container(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.2),
                                        child: ThemeIconWidget(
                                          ThemeIcon.randomChat,
                                          size: 20,
                                          color: Theme.of(context)
                                              .primaryColor,
                                        ).p8)
                                        .circular,
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      LocalizationString.strangerChat,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                          fontWeight:
                                          FontWeight.w900),
                                    )
                                  ],
                                ),
                              ).ripple(() {
                                Get.to(() => const FindRandomUser(
                                  isCalling: false,
                                ));
                              }).hP16;
                            } else {
                              return UserTile(
                                profile: usersList[index - 2],
                                viewCallback: () {
                                  EasyLoading.show(
                                      status:
                                      LocalizationString.loading);

                                  widget.userSelected(
                                      usersList[index - 2]);
                                },
                                audioCallCallback: () {
                                  Get.back();
                                  initiateAudioCall(
                                      context, usersList[index - 2]);
                                },
                                chatCallback: () {
                                  EasyLoading.show(
                                      status:
                                      LocalizationString.loading);

                                  widget.userSelected(
                                      usersList[index - 2]);
                                },
                                videoCallCallback: () {
                                  Get.back();
                                  initiateVideoCall(
                                      context, usersList[index - 2]);
                                },
                              ).hP16;
                            }
                          },
                          separatorBuilder: (context, index) {
                            if (index < 2) {
                              return divider(context: context).vP16;
                            }

                            return const SizedBox(
                              height: 20,
                            );
                          },
                        )
                            : emptyUser(
                            title: LocalizationString.noUserFound,
                            subTitle:
                            LocalizationString.followSomeUserToChat,
                            context: context);
                      }),
                ),
              ],
            ),
          ).round(20).p16,
        ),
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

      _agoraCallController.makeCallRequest(call: call);
    }, permissionDenied: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToCameraForVideoCall,
          isSuccess: false);
    }, permissionNotAskAgain: () {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseAllowAccessToCameraForVideoCall,
          isSuccess: false);
    });
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

          _agoraCallController.makeCallRequest(call: call);
        }, permissionDenied: () {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.pleaseAllowAccessToMicrophoneForAudioCall,
              isSuccess: false);
        }, permissionNotAskAgain: () {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.pleaseAllowAccessToMicrophoneForAudioCall,
              isSuccess: false);
        });
  }
}

class SelectFollowingUserForMessageSending extends StatefulWidget {
  final Function(UserModel) sendToUserCallback;

  const SelectFollowingUserForMessageSending({
    Key? key,
    required this.sendToUserCallback,
    // this.post,
  }) : super(key: key);

  @override
  SelectFollowingUserForMessageSendingState createState() =>
      SelectFollowingUserForMessageSendingState();
}

class SelectFollowingUserForMessageSendingState
    extends State<SelectFollowingUserForMessageSending> {
  final SelectUserForChatController selectUserForChatController = Get.find();

  @override
  void initState() {
    super.initState();
    selectUserForChatController.getFollowingUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectUserForChatController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 340,
          color: Theme.of(context).backgroundColor,
          child: GetBuilder<SelectUserForChatController>(
              init: selectUserForChatController,
              builder: (ctx) {
                ScrollController scrollController = ScrollController();
                scrollController.addListener(() {
                  if (scrollController.position.maxScrollExtent ==
                      scrollController.position.pixels) {
                    if (!selectUserForChatController.followingIsLoading) {
                      selectUserForChatController.getFollowingUsers();
                    }
                  }
                });

                List<UserModel> usersList =
                    selectUserForChatController.following;
                return selectUserForChatController.followingIsLoading
                    ? const ShimmerUsers().hP16
                    : usersList.isNotEmpty
                    ? ListView.separated(
                  padding: const EdgeInsets.only(top: 20, bottom: 50),
                  controller: scrollController,
                  itemCount: usersList.length,
                  itemBuilder: (context, index) {
                    UserModel user = usersList[index];
                    return SendMessageUserTile(
                      state: selectUserForChatController
                          .completedActionUsers
                          .contains(user)
                          ? ButtonState.success
                          : selectUserForChatController
                          .failedActionUsers
                          .contains(user)
                          ? ButtonState.fail
                          : selectUserForChatController
                          .processingActionUsers
                          .contains(user)
                          ? ButtonState.loading
                          : ButtonState.idle,
                      profile: usersList[index],
                      sendCallback: () {
                        Get.back();
                        widget.sendToUserCallback(usersList[index]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                ).hP16
                    : emptyUser(
                    title: LocalizationString.noUserFound,
                    subTitle:
                    LocalizationString.followFriendsToSendPost,
                    context: context);
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
