import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatDetail extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const ChatDetail({Key? key, required this.chatRoom}) : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final ChatDetailController _chatDetailController = Get.find();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    loadChat();
    super.initState();
  }

  loadChat() {
    _chatDetailController.loadChat(widget.chatRoom);
    scrollToBottom();
  }

  @override
  void dispose() {
    super.dispose();
    _chatDetailController.clear();
  }

  scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 100), () {
        if (_chatDetailController.messages.isNotEmpty) {
          _controller.animateTo(
            _controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.fastOutSlowIn,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            appBar(),
            divider(context: context).tP8,
            Expanded(child: messagesListView()),
            Obx(() {
              return Column(
                children: [
                  SizedBox(
                    height:
                        _chatDetailController.smartReplySuggestions.isNotEmpty
                            ? 50
                            : 0,
                    child: ListView.separated(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 5, bottom: 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return SizedBox(
                            height: 0,
                            child: Center(
                              child: Text(
                                _chatDetailController
                                    .smartReplySuggestions[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ).hP8,
                            ),
                          )
                              .borderWithRadius(
                                  context: context, value: 1, radius: 10)
                              .ripple(() {
                            _chatDetailController.sendSmartMessage(
                                smartMessage: _chatDetailController
                                    .smartReplySuggestions[index],
                                room: _chatDetailController.chatRoom.value!);
                          });
                        },
                        separatorBuilder: (ctx, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        itemCount:
                            _chatDetailController.smartReplySuggestions.length),
                  ),
                ],
              );
            }),
            Obx(() {
              return _chatDetailController.chatRoom.value?.amIMember == true
                  ? _chatDetailController.actionMode.value ==
                              ChatMessageActionMode.none ||
                          _chatDetailController.actionMode.value ==
                              ChatMessageActionMode.reply
                      ? _chatDetailController.chatRoom.value!.canIChat
                          ? messageComposerView()
                          : cantChatView()
                      : selectedMessageView()
                  : cantChatView();
            })
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ThemeIconWidget(
              ThemeIcon.backArrow,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ).p8.ripple(() {
              Timer(const Duration(milliseconds: 500), () {
                _chatDetailController.clear();
              });
              Get.back();
            }),
            Obx(() => _chatDetailController.chatRoom.value?.isGroupChat == false
                ? Row(
                    children: [
                      ThemeIconWidget(
                        ThemeIcon.mobile,
                        color: Theme.of(context).iconTheme.color,
                        size: 25,
                      ).p4.ripple(() {
                        audioCall();
                      }),
                      const SizedBox(
                        width: 20,
                      ),
                      ThemeIconWidget(
                        ThemeIcon.videoCamera,
                        color: Theme.of(context).iconTheme.color,
                        size: 25,
                      ).p4.ripple(() {
                        videoCall();
                      })
                    ],
                  )
                : Container()),
          ],
        ).hP16,
        Positioned(
          left: 16,
          right: 16,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Obx(() {
                    return _chatDetailController.chatRoom.value == null ||
                            _chatDetailController
                                .chatRoom.value!.roomMembers.isEmpty
                        ? Container()
                        : Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _chatDetailController
                                                .chatRoom.value!.isGroupChat ==
                                            true
                                        ? _chatDetailController
                                            .chatRoom.value!.name!
                                        : _chatDetailController.chatRoom.value!
                                            .opponent.userDetail.userName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(width: 5),
                                  _chatDetailController
                                              .chatRoom.value!.isGroupChat ==
                                          false
                                      ? Container(
                                          height: 8,
                                          width: 8,
                                          color: _chatDetailController
                                                      .chatRoom
                                                      .value!
                                                      .opponent
                                                      .userDetail
                                                      .isOnline ==
                                                  true
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).disabledColor,
                                        ).circular
                                      : Container(),
                                ],
                              ),
                              _chatDetailController
                                          .chatRoom.value!.isGroupChat ==
                                      false
                                  ? _chatDetailController.isTypingMapping[
                                              _chatDetailController
                                                  .chatRoom
                                                  .value!
                                                  .opponent
                                                  .userDetail
                                                  .userName] ==
                                          true
                                      ? Text(
                                          LocalizationString.typing,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        )
                                      : Text(
                                          _chatDetailController
                                                      .chatRoom
                                                      .value!
                                                      .opponent
                                                      .userDetail
                                                      .isOnline ==
                                                  true
                                              ? LocalizationString.online
                                              : _chatDetailController
                                                  .chatRoom
                                                  .value!
                                                  .opponent
                                                  .userDetail
                                                  .lastSeenAtTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        )
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      child: Text(
                                          _chatDetailController
                                                  .whoIsTyping.isNotEmpty
                                              ? '${_chatDetailController.whoIsTyping.join(',')} ${LocalizationString.typing}'
                                              : _chatDetailController
                                                  .chatRoom.value!.roomMembers
                                                  .map((e) {
                                                    if (e.userDetail.isMe) {
                                                      return LocalizationString
                                                          .you;
                                                    }
                                                    return e
                                                        .userDetail.userName;
                                                  })
                                                  .toList()
                                                  .join(','),
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ),
                            ],
                          );
                  }).ripple(() {
                    Get.to(() => ChatRoomDetail(
                            chatRoom: _chatDetailController.chatRoom.value!))!
                        .then((value) {
                      loadChat();
                    });
                  }),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget selectedMessageView() {
    return Obx(() => Container(
          color: Theme.of(context).backgroundColor.darken(0.02),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ThemeIconWidget(
                _chatDetailController.actionMode.value ==
                        ChatMessageActionMode.forward
                    ? ThemeIcon.fwd
                    : _chatDetailController.actionMode.value ==
                            ChatMessageActionMode.delete
                        ? ThemeIcon.delete
                        : ThemeIcon.send,
                color: Theme.of(context).primaryColor,
              ).ripple(() {
                if (_chatDetailController.actionMode.value ==
                    ChatMessageActionMode.forward) {
                  selectUserForMessageForward();
                } else {
                  deleteMessageActionPopup();
                }
              }),
              Text(
                  '${_chatDetailController.selectedMessages.length} ${LocalizationString.selected.toLowerCase()}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text(
                LocalizationString.cancel,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ).ripple(() {
                _chatDetailController.setToActionMode(
                    mode: ChatMessageActionMode.none);
              })
            ],
          ).hP16,
        ));
  }

  Widget replyMessageView() {
    return Obx(() => _chatDetailController
                .selectedMessage.value!.messageContentType ==
            MessageContentType.text
        ? replyTextMessageView(_chatDetailController.selectedMessage.value!)
        : replyMediaMessageView(_chatDetailController.selectedMessage.value!));
  }

  Widget replyTextMessageView(ChatMessageModel message) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isMineMessage
                      ? LocalizationString.you
                      : message.userName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ).bP4,
                Text(
                  message.messageContent,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          ThemeIconWidget(
            ThemeIcon.closeCircle,
            size: 28,
            color: Theme.of(context).iconTheme.color,
          ).ripple(() {
            _chatDetailController.setReplyMessage(message: null);
          })
        ],
      ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
    );
  }

  Widget replyMediaMessageView(ChatMessageModel message) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _chatDetailController.selectedMessage.value!.isMineMessage
                      ? LocalizationString.you
                      : _chatDetailController.selectedMessage.value!.userName,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ).bP4,
                messageTypeShortInfo(
                  model: message,
                  context: context,
                ),
              ],
            ),
          ),
          messageMainContent(message),
          const SizedBox(width: 10),
          ThemeIconWidget(
            ThemeIcon.closeCircle,
            size: 28,
            color: Theme.of(context).iconTheme.color,
          ).ripple(() {
            _chatDetailController.setToActionMode(
                mode: ChatMessageActionMode.none);
          })
        ],
      ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
    );
  }

  Widget messageComposerView() {
    return Column(
      children: [
        _chatDetailController.actionMode.value == ChatMessageActionMode.reply
            ? replyMessageView()
            : Container(),
        Container(
          color: Theme.of(context).backgroundColor.darken(0.02),
          height: 70,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Obx(() => TextField(
                                  controller:
                                      _chatDetailController.messageTf.value,
                                  textAlign: TextAlign.start,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 50,
                                  onChanged: (text) {
                                    _chatDetailController.messageChanges();
                                  },
                                  decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 5),
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                      hintText: LocalizationString
                                          .pleaseEnterMessage),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Obx(() {
                          return _chatDetailController
                                  .messageTf.value.text.isNotEmpty
                              ? Text(
                                  LocalizationString.send,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w900),
                                ).ripple(() {
                                  sendMessage();
                                })
                              : Container(
                                  height: 30,
                                  width: 30,
                                  color: Theme.of(context).primaryColor,
                                  child: ThemeIconWidget(
                                    ThemeIcon.plus,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ).circular.ripple(() {
                                  openMediaSharingOptionView();
                                  // chatDetailController
                                  //     .expandCollapseActions();
                                });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ).hP16,
        )
      ],
    );
  }

  Widget cantChatView() {
    return Container(
      color: Theme.of(context).backgroundColor.darken(0.02),
      height: 70,
      child: Center(
        child: Text(
          LocalizationString.onlyAdminCanSendMessage,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget messagesListView() {
    return GetBuilder<ChatDetailController>(
        init: _chatDetailController,
        builder: (ctx) {
          return _chatDetailController.messages.isEmpty
              ? Container()
              : Container(
                  decoration: _chatDetailController.wallpaper.value.isEmpty
                      ? null
                      : BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                _chatDetailController.wallpaper.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                  child: ListView.builder(
                    controller: _controller,
                    // itemScrollController: _itemScrollController,
                    // itemPositionsListener: _itemPositionsListener,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 50, left: 16, right: 16),
                    itemCount: _chatDetailController.messages.length,
                    itemBuilder: (ctx, index) {
                      ChatMessageModel message =
                          _chatDetailController.messages[index];

                      return message.isDeleted == 1 ||
                              message.isDateSeparator ||
                              message.messageContentType ==
                                  MessageContentType.groupAction
                          ? messageTile(message)
                          : chatMessageFocusMenu(message);
                    },
                  ));
        });
  }

  Widget chatMessageFocusMenu(ChatMessageModel message) {
    final dataKey = GlobalKey();
    message.globalKey = dataKey;
    return FocusedMenuHolder(
      key: dataKey,

      menuWidth: MediaQuery.of(context).size.width * 0.50,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(15.0))),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: false,
      blurBackgroundColor: Colors.black54,
      openWithTap: false,
      // Open Focused-Menu on Tap rather than Long Press
      menuOffset: 10.0,
      // Offset value to show menuItem from the selected item
      bottomOffsetHeight: 80.0,
      // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
      menuItems: [
        if (message.copyContent != null)
          FocusedMenuItem(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                LocalizationString.copy,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailingIcon: const Icon(Icons.file_copy, size: 18),
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: message.messageContent));
              }),
        if (_chatDetailController.chatRoom.value?.canIChat == true)
          FocusedMenuItem(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                LocalizationString.reply,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailingIcon: const Icon(Icons.reply, size: 18),
              onPressed: () {
                _chatDetailController.setReplyMessage(message: message);
              }),
        FocusedMenuItem(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              LocalizationString.fwd,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailingIcon: const Icon(
              Icons.send,
              size: 18,
            ),
            onPressed: () {
              _chatDetailController.selectMessage(message);
              _chatDetailController.setToActionMode(
                  mode: ChatMessageActionMode.forward);
            }),
        FocusedMenuItem(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              LocalizationString.delete,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailingIcon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () {
              _chatDetailController.selectMessage(message);

              _chatDetailController.setToActionMode(
                  mode: ChatMessageActionMode.delete);
            }),
        FocusedMenuItem(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              message.isStar == 1
                  ? LocalizationString.unStar
                  : LocalizationString.star,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailingIcon: Icon(
              Icons.star,
              size: 18,
              color: message.isStar == 1
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              if (message.isStar == 1) {
                _chatDetailController.unStarMessage(message);
              } else {
                _chatDetailController.starMessage(message);
              }
            })
      ],
      onPressed: () {},
      child: messageTile(message),
    );
  }

  Widget messageTile(ChatMessageModel chatMessage) {
    return Column(
      children: [
        chatMessage.isDateSeparator
            ? Container(
                color: Theme.of(context)
                    .primaryColor
                    .lighten(0.2)
                    .withOpacity(0.5),
                width: 120,
                child: Center(
                  child: Text(chatMessage.date)
                      .setPadding(left: 8, right: 8, top: 4, bottom: 4),
                ),
              ).round(15).bP25
            : ChatMessageTile(
                message: chatMessage,
                showName:
                    _chatDetailController.chatRoom.value?.isGroupChat == true,
                actionMode: _chatDetailController.actionMode.value ==
                        ChatMessageActionMode.forward ||
                    _chatDetailController.actionMode.value ==
                        ChatMessageActionMode.delete,
                replyMessageTapHandler: (message) {
                  replyMessageTapped(chatMessage);
                },
                messageTapHandler: (message) {
                  messageTapped(chatMessage);
                },
              ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  void messageTapped(ChatMessageModel model) async {
    if (model.messageContentType == MessageContentType.forward) {
      messageTapped(model.originalMessage);
    }
    if (model.messageContentType == MessageContentType.photo) {
      int index = _chatDetailController.mediaMessages
          .indexWhere((element) => element == model);

      Get.to(() => MediaListViewer(
                chatRoom: _chatDetailController.chatRoom.value!,
                medias: _chatDetailController.mediaMessages,
                startFrom: index,
              ))!
          .then((value) => loadChat());
    } else if (model.messageContentType == MessageContentType.video) {
      if (model.messageContent.isNotEmpty) {
        Get.to(() => PlayVideoController(
                  chatMessage: model,
                ))!
            .then((value) => loadChat());
      }
    } else if (model.messageContentType == MessageContentType.post) {
      Get.to(() => SinglePostDetail(
                postId: model.postContent.postId,
              ))!
          .then((value) => loadChat());
    } else if (model.messageContentType == MessageContentType.contact) {
      openActionPopupForContact(model.mediaContent.contact!);
    } else if (model.messageContentType == MessageContentType.profile) {
      Get.to(() => OtherUserProfile(
                userId: model.profileContent.userId,
              ))!
          .then((value) => loadChat());
    } else if (model.messageContentType == MessageContentType.location) {
      try {
        final coords = Coords(model.mediaContent.location!.latitude,
            model.mediaContent.location!.longitude);
        final title = model.mediaContent.location!.name;
        final availableMaps = await MapLauncher.installedMaps;

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(
                          '${LocalizationString.openIn} ${map.mapName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      } catch (e) {
        // print(e);
      }
    } else if (model.messageContentType == MessageContentType.file) {
      String? path = await getIt<FileManager>().localFilePathForMessage(model);

      if (path != null) {
        OpenFile.open(path);
      }
    }
  }

  void openActionPopupForContact(Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(
                        child: Text(
                      contact.displayName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w900),
                    )),
                    onTap: () async {}),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.saveContact)),
                    onTap: () async {
                      Get.back();
                      _chatDetailController.addNewContact(contact);
                      AppUtil.showToast(
                          context: context,
                          message: LocalizationString.contactSaved,
                          isSuccess: false);
                    }),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.cancel)),
                    onTap: () => Get.back()),
              ],
            ));
  }

  sendMessage() {
    // if (messageTf.text.removeAllWhitespace.trim().isNotEmpty) {
    _chatDetailController.sendTextMessage(
        context: context,
        mode: _chatDetailController.actionMode.value,
        room: _chatDetailController.chatRoom.value!);
    // messageTf.text = '';
    scrollToBottom();
    // }
  }

  void replyMessageTapped(ChatMessageModel model) {
    int index = _chatDetailController.messages.indexWhere((element) =>
        element.localMessageId == model.originalMessage.localMessageId);
    if (index != -1) {
      Scrollable.ensureVisible(model.globalKey!.currentContext!);
      // _controller.jumpTo(
      //   _controller.position.maxScrollExtent,
      //   duration: const Duration(milliseconds: 250),
      //   curve: Curves.fastOutSlowIn,
      // );

      // Timer(const Duration(milliseconds: 1), () {
      //
      //   _itemScrollController.jumpTo(
      //     index: index,
      //   );
      // });
    }
  }

  void videoCall() {
    _chatDetailController.initiateVideoCall(context);
  }

  void audioCall() {
    _chatDetailController.initiateAudioCall(context);
  }

  selectUserForMessageForward() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            SelectFollowingUserForMessageSending(sendToUserCallback: (user) {
              _chatDetailController.getChatRoomWithUser(
                  user.id,
                  (room) => () {
                        _chatDetailController.forwardSelectedMessages(
                            room: room);
                        Get.back();
                      });
            })).then((value) {
      _chatDetailController.setToActionMode(mode: ChatMessageActionMode.none);
    });
  }

  openMediaSharingOptionView() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => const FractionallySizedBox(
            heightFactor: 0.42, child: ChatMediaSharingOptionPopup()));
  }

  void deleteMessageActionPopup() {
    bool ifAnyMessageByOpponent = _chatDetailController.selectedMessages
        .where((e) => e.isMineMessage == false)
        .isNotEmpty;

    showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                ListTile(
                    title: Center(
                        child: Text(LocalizationString.deleteMessageForMe)),
                    onTap: () async {
                      Get.back();
                      _chatDetailController.deleteMessage(deleteScope: 1);
                      // postCardController.reportPost(widget.model);
                    }),
                divider(context: context),
                ifAnyMessageByOpponent == false &&
                        _chatDetailController.chatRoom.value?.canIChat == true
                    ? ListTile(
                        title: Center(
                            child:
                                Text(LocalizationString.deleteMessageForAll)),
                        onTap: () async {
                          Get.back();
                          _chatDetailController.deleteMessage(deleteScope: 2);
                          // postCardController.blockUser(widget.model.user.id);
                        })
                    : Container(),
                divider(context: context),
                ListTile(
                    title: Center(child: Text(LocalizationString.cancel)),
                    onTap: () => Get.back()),
              ],
            ));
  }
}
