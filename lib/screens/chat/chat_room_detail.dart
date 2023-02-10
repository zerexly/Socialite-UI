import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatRoomDetail extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatRoomDetail({Key? key, required this.chatRoom}) : super(key: key);

  @override
  State<ChatRoomDetail> createState() => _ChatRoomDetailState();
}

class _ChatRoomDetailState extends State<ChatRoomDetail> {
  final ChatRoomDetailController _chatRoomDetailController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    if (_settingsController.setting.value!.enableStarMessage) {
      _chatRoomDetailController.getStarredMessages(widget.chatRoom);
    }
    _chatDetailController.getUpdatedChatRoomDetail(widget.chatRoom);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemeIconWidget(
                  ThemeIcon.backArrow,
                  color: Theme.of(context).iconTheme.color,
                  size: 20,
                ).p8.ripple(() {
                  Get.back();
                }),
                Obx(() => _chatDetailController.chatRoom.value == null
                    ? Container()
                    : Text(
                        _chatDetailController.chatRoom.value!.isGroupChat
                            ? _chatDetailController.chatRoom.value!.name!
                            : _chatDetailController
                                .chatRoom.value!.opponent.userDetail.userName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      )),
                Obx(() => _chatDetailController.chatRoom.value?.amIGroupAdmin ==
                        true && _chatDetailController.chatRoom.value?.isGroupChat == true
                    ? ThemeIconWidget(
                        ThemeIcon.edit,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ).ripple(() {
                        Get.to(() => UpdateGroupInfo(
                                group: _chatDetailController.chatRoom.value!))!
                            .then((value) {
                          _chatDetailController
                              .getUpdatedChatRoomDetail(widget.chatRoom);
                        });
                      })
                    : const SizedBox(
                        width: 20,
                      )),
              ],
            ).hP16,
            divider(context: context).tP8,
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                    left: 0, top: 0, right: 0, bottom: 80),
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  widget.chatRoom.isGroupChat ? groupInfo() : opponentInfo(),
                  const SizedBox(
                    height: 25,
                  ),
                  widget.chatRoom.isGroupChat
                      ? Container()
                      : Column(
                          children: [
                            callWidgets(),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                  Obx(() =>
                      (_chatDetailController.chatRoom.value?.description ?? '')
                              .isEmpty
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                descriptionWidget(),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            )),
                  commonOptionsWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  Obx(() => _chatDetailController.chatRoom.value?.isGroupChat ==
                              true &&
                          _chatDetailController.chatRoom.value?.amIGroupAdmin ==
                              true
                      ? Column(children: [
                          groupSettingWidget(),
                          const SizedBox(
                            height: 50,
                          )
                        ])
                      : Container()),
                  widget.chatRoom.isGroupChat
                      ? Column(
                          children: [
                            participantsWidget(),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        )
                      : Container(),
                  extraOptionsWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  widget.chatRoom.isGroupChat
                      ? Column(children: [
                          exitAndDeleteGroup(),
                          const SizedBox(
                            height: 50,
                          )
                        ])
                      : Container(),
                ],
              ),
            )
          ],
        ));
  }

  Widget descriptionWidget() {
    return Container(
      color: Theme.of(context).cardColor,
      width: double.infinity,
      child: Text(
        _chatDetailController.chatRoom.value!.description!,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.w300),
      ).p16,
    ).round(10).shadow(context: context, shadowOpacity: 0.1).hP16;
  }

  Widget groupSettingWidget() {
    return Column(
      children: [
        Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: const ThemeIconWidget(
                      ThemeIcon.setting,
                      color: Colors.white,
                    ).p4,
                  ).round(5),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocalizationString.groupSettings,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              ThemeIconWidget(
                ThemeIcon.nextArrow,
                color: Theme.of(context).iconTheme.color,
                size: 15,
              )
            ],
          ).hP8,
        ).ripple(() {
          Get.to(() => const GroupSettings());
        }),
      ],
    ).round(10).shadow(context: context, shadowOpacity: 0.1).hP16;
  }

  Widget commonOptionsWidget() {
    return Column(
      children: [
        Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: const ThemeIconWidget(
                      ThemeIcon.gallery,
                      color: Colors.white,
                    ).p4,
                  ).round(5),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocalizationString.media,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              ThemeIconWidget(
                ThemeIcon.nextArrow,
                color: Theme.of(context).iconTheme.color,
                size: 15,
              )
            ],
          ).hP8,
        ).ripple(() {
          Get.to(() => ChatMediaList(
                chatRoom: widget.chatRoom,
              ));
        }),
        divider(context: context),
        Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: const ThemeIconWidget(
                      ThemeIcon.wallpaper,
                      color: Colors.white,
                    ).p4,
                  ).round(5),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    LocalizationString.wallpaper,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              ThemeIconWidget(
                ThemeIcon.nextArrow,
                color: Theme.of(context).iconTheme.color,
                size: 15,
              )
            ],
          ).hP8,
        ).ripple(() {
          Get.to(() => WallpaperForChatBackground(
                roomId: widget.chatRoom.id,
              ));
        }),
        divider(context: context),
        _chatRoomDetailController.starredMessages.isNotEmpty &&
                _settingsController.setting.value!.enableStarMessage
            ? Obx(() => Container(
                  height: 50,
                  color: Theme.of(context).cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Theme.of(context).primaryColor,
                            child: const ThemeIconWidget(
                              ThemeIcon.filledStar,
                              color: Colors.white,
                            ).p4,
                          ).round(5),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            LocalizationString.starredMessages,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '(${_chatRoomDetailController.starredMessages.length})',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          ThemeIconWidget(
                            ThemeIcon.nextArrow,
                            color: Theme.of(context).iconTheme.color,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ).hP8,
                ).ripple(() {
                  Get.to(() => StarredMessages(
                        chatRoom: widget.chatRoom,
                      ));
                }))
            : Container(),
      ],
    ).round(10).shadow(context: context, shadowOpacity: 0.1).hP16;
  }

  Widget extraOptionsWidget() {
    return Column(
      children: [
        Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationString.exportChat,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w300),
              )
            ],
          ).hP8,
        ).ripple(() {
          exportChatActionPopup();
        }),
        divider(context: context),
        Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocalizationString.deleteChat,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)
                  .copyWith(color: Theme.of(context).errorColor),
            ).hP8,
          ),
        ).ripple(() {
          _chatRoomDetailController.deleteRoomChat(widget.chatRoom);
          _chatDetailController.deleteChat(widget.chatRoom.id);
          AppUtil.showToast(
              context: context,
              message: LocalizationString.chatDeleted,
              isSuccess: true);
        })
      ],
    ).round(10).shadow(context: context, shadowOpacity: 0.1).hP16;
  }

  Widget exitAndDeleteGroup() {
    return Column(
      children: [
        divider(context: context),
        Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.chatRoom.amIMember
                  ? LocalizationString.leaveGroup
                  : LocalizationString.deleteGroup,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)
                  .copyWith(color: Theme.of(context).errorColor),
            ).hP8,
          ),
        ).ripple(() {
          if (widget.chatRoom.amIMember) {
            _chatRoomDetailController.leaveGroup(widget.chatRoom);
          } else {
            _chatRoomDetailController.deleteGroup(widget.chatRoom);
          }
          Get.back();
        }),
      ],
    ).round(10).shadow(context: context, shadowOpacity: 0.1).hP16;
  }

  Widget callWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_settingsController.setting.value!.enableAudioCalling)
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
          }).rp(20),
        if (_settingsController.setting.value!.enableVideoCalling)
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

  Widget groupInfo() {
    return Obx(() => _chatDetailController.chatRoom.value == null
        ? Container()
        : Column(
            children: [
              AvatarView(
                url: _chatDetailController.chatRoom.value!.image,
                size: 100,
                name: _chatDetailController.chatRoom.value!.name!,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _chatDetailController.chatRoom.value!.name!,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w900),
              )
            ],
          ));
  }

  Widget opponentInfo() {
    return Obx(() => _chatDetailController.chatRoom.value == null
        ? Container()
        : Column(
            children: [
              UserAvatarView(
                user: _chatDetailController.chatRoom.value!.opponent.userDetail,
                size: 100,
                onTapHandler: () {
                  //open live
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _chatDetailController
                    .chatRoom.value!.opponent.userDetail.userName,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w900),
              )
            ],
          ));
  }

  void exportChatActionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(
                        child: Text(LocalizationString.exportChatWithMedia)),
                    onTap: () async {
                      Get.back();
                      exportChatWithMedia();
                    }),
                divider(context: context),
                ListTile(
                    title: Center(
                        child: Text(LocalizationString.exportChatWithoutMedia)),
                    onTap: () async {
                      Get.back();
                      exportChatWithoutMedia();
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.cancel)),
                    onTap: () => Get.back()),
              ],
            ));
  }

  Widget participantsWidget() {
    return Obx(() => _chatDetailController.chatRoom.value == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_chatDetailController.chatRoom.value!.roomMembers.length} ${LocalizationString.participants}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height:
                    (_chatDetailController.chatRoom.value!.roomMembers.length +
                            (_chatDetailController.chatRoom.value!.amIGroupAdmin
                                ? 1
                                : 0)) *
                        60,
                color: Theme.of(context).cardColor,
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _chatDetailController
                            .chatRoom.value!.roomMembers.length +
                        (_chatDetailController.chatRoom.value!.amIGroupAdmin
                            ? 1
                            : 0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      if (index == 0 &&
                          _chatDetailController.chatRoom.value!.amIGroupAdmin) {
                        return Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              color: Theme.of(context).primaryColor.lighten(),
                              child: const ThemeIconWidget(
                                ThemeIcon.plus,
                                size: 25,
                              ),
                            ).circular,
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              LocalizationString.addParticipants,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w600),
                            )
                          ],
                        ).hP8.ripple(() {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => FractionallySizedBox(
                                  heightFactor: 0.9,
                                  child: SelectUserForGroupChat(
                                    group:
                                        _chatDetailController.chatRoom.value!,
                                    invitedUserCallback: () {
                                      _chatDetailController
                                          .getUpdatedChatRoomDetail(
                                              widget.chatRoom);
                                    },
                                  )));
                        });
                      }
                      ChatRoomMember member =
                          _chatDetailController.chatRoom.value!.roomMembers[
                              index -
                                  (_chatDetailController
                                          .chatRoom.value!.amIGroupAdmin
                                      ? 1
                                      : 0)];
                      return Row(
                        children: [
                          UserAvatarView(
                            user: member.userDetail,
                            size: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.userDetail.isMe
                                    ? LocalizationString.you
                                    : member.userDetail.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ).bP4,
                              member.userDetail.country != null
                                  ? Text(
                                      '${member.userDetail.city!}, ${member.userDetail.country!}',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    )
                                  : Container()
                            ],
                          ).hP16,

                          const Spacer(),
                          member.isAdmin == 1
                              ? Text(
                                  LocalizationString.admin,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ).bP4
                              : Container()
                          // const Spacer(),
                        ],
                      ).hP8.ripple(() {
                        if (!member.userDetail.isMe) {
                          openActionOptionsForParticipant(member);
                        }
                      });
                    },
                    separatorBuilder: (ctx, index) {
                      return divider(context: context).vp(10);
                    }).vP8,
              ).round(10).shadow(context: context, shadowOpacity: 0.1),
            ],
          ).hP16);
  }

  void openActionOptionsForParticipant(ChatRoomMember member) {
    GenericItem userDetail = GenericItem(
      id: '1',
      title: LocalizationString.userDetail,
      subTitle: LocalizationString.userDetail,
      // isSelected: selectedItem?.id == '1',
    );

    GenericItem makeAdmin = GenericItem(
      id: '2',
      title: LocalizationString.makeAdmin,
      subTitle: LocalizationString.makeAdmin,
      // isSelected: selectedItem?.id == '1',
    );

    GenericItem removeAdmin = GenericItem(
      id: '3',
      title: LocalizationString.removeAdmin,
      subTitle: LocalizationString.removeAdmin,
      // isSelected: selectedItem?.id == '1',
    );

    GenericItem removeFromGroup = GenericItem(
      id: '4',
      title: LocalizationString.removeFromGroup,
      subTitle: LocalizationString.removeFromGroup,
      // isSelected: selectedItem?.id == '1',
    );
    GenericItem cancel = GenericItem(
      id: '5',
      title: LocalizationString.cancel,
      subTitle: LocalizationString.cancel,
      // isSelected: selectedItem?.id == '1',
    );
    List<GenericItem> items = [];
    items.add(userDetail);
    if (member.isAdmin == 1 && widget.chatRoom.amIGroupAdmin) {
      items.add(removeAdmin);
    } else {
      if (widget.chatRoom.amIGroupAdmin) {
        items.add(makeAdmin);
        items.add(removeFromGroup);
      }
    }
    items.add(cancel);

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ActionSheet1(
              items: items,
              itemCallBack: (item) {
                if (item.id == '1') {
                  Get.to(() => OtherUserProfile(
                        userId: member.userDetail.id,
                      ));
                } else if (item.id == '2') {
                  _chatRoomDetailController.makeUserAsAdmin(
                      member.userDetail, widget.chatRoom);
                } else if (item.id == '3') {
                  _chatRoomDetailController.removeUserAsAdmin(
                      member.userDetail, widget.chatRoom);
                } else if (item.id == '4') {
                  _chatRoomDetailController.removeUserFormGroup(
                      member.userDetail, widget.chatRoom);
                }
              },
            ));
  }

  void exportChatWithMedia() {
    _chatRoomDetailController.exportChat(
        roomId: widget.chatRoom.id, includeMedia: true);
  }

  void exportChatWithoutMedia() {
    _chatRoomDetailController.exportChat(
        roomId: widget.chatRoom.id, includeMedia: false);
  }

  leaveChat() {
    _chatRoomDetailController.leaveGroup(widget.chatRoom);
    Get.back();
  }

  void videoCall() {
    _chatDetailController.initiateVideoCall();
  }

  void audioCall() {
    _chatDetailController.initiateAudioCall();
  }
}
