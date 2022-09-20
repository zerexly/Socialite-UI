import 'package:foap/components/place_picker/place_picker.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatDetail extends StatefulWidget {
  final ChatRoomModel? chatRoom;
  final UserModel? opponent;

  const ChatDetail({Key? key, required this.chatRoom, required this.opponent})
      : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final ChatController chatController = Get.find();
  final ChatDetailController chatDetailController = Get.find();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  String? wallpaper;

  @override
  void initState() {
    loadChat();
    loadWallpaper();
    super.initState();
  }

  loadWallpaper() async {
    wallpaper = await SharedPrefs().getWallpaper(
        userId: widget.opponent == null
            ? widget.chatRoom!.opponent.id
            : widget.opponent!.id);
    setState(() {});
  }

  loadChat() {
    chatDetailController.loadChat(widget.chatRoom, widget.opponent);
    scrollToBottom();
  }

  @override
  void dispose() {
    super.dispose();
    chatDetailController.clear();
  }

  scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(milliseconds: 100), () {
        if (chatDetailController.messages.isNotEmpty) {
          itemScrollController.jumpTo(
            index: chatDetailController.messages.length,
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
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.chatRoom?.opponent.userName ??
                              widget.opponent!.userName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 5),
                        Obx(() => Container(
                              height: 8,
                              width: 8,
                              color: chatDetailController
                                          .opponent.value?.isOnline ==
                                      true
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor,
                            ).circular)
                      ],
                    ),
                    Obx(() => chatDetailController.isTyping.value == true
                        ? Text(
                            LocalizationString.typing,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        : Container()),
                  ],
                ).ripple(() {
                  Get.to(() => ChatRoomDetail(
                          chatRoom: chatDetailController.chatRoom))!
                      .then((value) {
                    loadChat();
                    loadWallpaper();
                  });
                }),
                Row(
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
                ),
              ],
            ).hP16,
            divider(context: context).tP8,
            Expanded(child: messagesListView()),
            Obx(() {
              return Column(
                children: [
                  SizedBox(
                    height:
                        chatDetailController.smartReplySuggestions.isNotEmpty
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
                                chatDetailController
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
                            chatDetailController.sendSmartMessage(
                                smartMessage: chatDetailController
                                    .smartReplySuggestions[index],
                                roomId: chatDetailController.chatRoomId);
                          });
                        },
                        separatorBuilder: (ctx, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        itemCount:
                            chatDetailController.smartReplySuggestions.length),
                  ).vP8,
                ],
              );
            }),
            Obx(() {
              return chatDetailController.actionMode.value ==
                          ChatMessageActionMode.none ||
                      chatDetailController.actionMode.value ==
                          ChatMessageActionMode.reply
                  ? messageComposerView()
                  : selectedMessageView();
            })
          ],
        ),
      ),
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
                chatDetailController.actionMode.value ==
                        ChatMessageActionMode.forward
                    ? ThemeIcon.fwd
                    : chatDetailController.actionMode.value ==
                            ChatMessageActionMode.delete
                        ? ThemeIcon.delete
                        : ThemeIcon.send,
                color: Theme.of(context).primaryColor,
              ).ripple(() {
                if (chatDetailController.actionMode.value ==
                    ChatMessageActionMode.forward) {
                  selectUserForMessageForward();
                } else {
                  deleteMessageActionPopup();
                }
              }),
              Text(
                  '${chatDetailController.selectedMessages.length} ${LocalizationString.selected.toLowerCase()}',
                  style: Theme.of(context).textTheme.bodyLarge),
              Text(
                LocalizationString.cancel,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ).ripple(() {
                chatDetailController.setToActionMode(
                    mode: ChatMessageActionMode.none);
              })
            ],
          ).hP16,
        ));
  }

  Widget replyMessageView() {
    return Obx(() => chatDetailController
                .selectedMessage.value!.messageContentType ==
            MessageContentType.text
        ? replyTextMessageView(chatDetailController.selectedMessage.value!)
        : replyMediaMessageView(chatDetailController.selectedMessage.value!));
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
            chatDetailController.setReplyMessage(message: null);
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
                  chatDetailController.selectedMessage.value!.isMineMessage
                      ? LocalizationString.you
                      : chatDetailController.selectedMessage.value!.userName,
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
            chatDetailController.setToActionMode(
                mode: ChatMessageActionMode.none);
          })
        ],
      ).setPadding(left: 16, right: 16, top: 8, bottom: 8),
    );
  }

  Widget messageComposerView() {
    return Column(
      children: [
        chatDetailController.actionMode.value == ChatMessageActionMode.reply
            ? replyMessageView()
            : Container(),
        GetBuilder<ChatDetailController>(
            init: chatDetailController,
            builder: (ctx) {
              return Container(
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
                        Container(
                          height: 30,
                          width: 30,
                          color: Theme.of(context).primaryColor,
                          child: ThemeIconWidget(
                            ThemeIcon.camera,
                            color: Theme.of(context).iconTheme.color,
                          ).p4,
                        ).circular.ripple(() {
                          openGallery();
                        }),
                        const SizedBox(
                          width: 10,
                        ),
                        Obx(() => chatDetailController.expandActions == true
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      color: Theme.of(context).primaryColor,
                                      child: ThemeIconWidget(
                                        ThemeIcon.contacts,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 20,
                                      ).ripple(() {
                                        openContactList();
                                      })).circular,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      height: 30,
                                      width: 30,
                                      color: Theme.of(context).primaryColor,
                                      child: ThemeIconWidget(
                                        ThemeIcon.location,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 20,
                                      ).ripple(() {
                                        openLocationPicker();
                                      })).circular,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      height: 30,
                                      width: 30,
                                      color: Theme.of(context).primaryColor,
                                      child: ThemeIconWidget(
                                        ThemeIcon.mic,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 20,
                                      ).ripple(() {
                                        openVoiceRecord();
                                      })).circular,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      height: 30,
                                      width: 30,
                                      color: Theme.of(context).primaryColor,
                                      child: ThemeIconWidget(
                                        ThemeIcon.sticker,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: 20,
                                      ).ripple(() {
                                        openGiphy();
                                      })).circular,
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    color: Theme.of(context).primaryColor,
                                    child: ThemeIconWidget(
                                      ThemeIcon.close,
                                      color: Theme.of(context).iconTheme.color,
                                    ).p4,
                                  ).circular.ripple(() {
                                    chatDetailController
                                        .expandCollapseActions();
                                  })
                                ],
                              )
                            : Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 40,
                                        child: Obx(() => TextField(
                                              controller: chatDetailController
                                                  .messageTf.value,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                              maxLines: 50,
                                              onChanged: (text) {
                                                chatDetailController
                                                    .messageChanges();
                                              },
                                              decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5),
                                                  labelStyle: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor),
                                                  hintStyle: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor),
                                                  hintText: LocalizationString
                                                      .pleaseEnterMessage),
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    chatDetailController
                                            .messageTf.value.text.isNotEmpty
                                        ? Text(
                                            LocalizationString.send,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight:
                                                        FontWeight.w900),
                                          ).ripple(() {
                                            sendMessage();
                                          })
                                        : Container(
                                            height: 30,
                                            width: 30,
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: ThemeIconWidget(
                                              ThemeIcon.plus,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ).circular.ripple(() {
                                            chatDetailController
                                                .expandCollapseActions();
                                          }),
                                  ],
                                ),
                              )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ).hP16,
              );
            }),
      ],
    );
  }

  openGiphy() async {
    String randomId = 'hsvcewd78djhbejkd';

    GiphyGif? gif = await GiphyGet.getGif(
      context: context,
      //Required
      apiKey: AppConfigConstants.giphyApiKey,
      //Required.
      lang: GiphyLanguage.english,
      //Optional - Language for query.
      randomID: randomId,
      // Optional - An ID/proxy for a specific user.
      tabColor: Colors.teal, // Optional- default accent color.
    );

    if (gif != null) {
      chatDetailController.sendGifMessage(
          gif: gif.images!.original!.url,
          mode: chatDetailController.actionMode.value,
          roomId: chatDetailController.chatRoomId);
    }
  }

  sendMessage() {
    // if (messageTf.text.removeAllWhitespace.trim().isNotEmpty) {
    chatDetailController.sendTextMessage(
        context: context,
        mode: chatDetailController.actionMode.value,
        roomId: chatDetailController.chatRoomId);
    // messageTf.text = '';
    //scrollToBottom();
    // }
  }

  Widget messagesListView() {
    return Container(
      decoration: wallpaper == null
          ? null
          : BoxDecoration(
              image: DecorationImage(
                image: AssetImage(wallpaper!),
                fit: BoxFit.cover,
              ),
            ),
      child: GetBuilder<ChatDetailController>(
          init: chatDetailController,
          builder: (ctx) {
            return ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              padding: const EdgeInsets.only(
                  top: 10, bottom: 50, left: 16, right: 16),
              itemCount: chatDetailController.messages.length,
              itemBuilder: (ctx, index) {
                return chatDetailController.messages[index].isDeleted == 1 ||
                        chatDetailController.messages[index].isDateSeparator
                    ? messageTile(index)
                    : FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width * 0.50,
                        blurSize: 5.0,
                        menuItemExtent: 45,
                        menuBoxDecoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0))),
                        duration: const Duration(milliseconds: 100),
                        animateMenuItems: false,
                        blurBackgroundColor: Colors.black54,
                        openWithTap: false,
                        // Open Focused-Menu on Tap rather than Long Press
                        menuOffset: 10.0,
                        // Offset value to show menuItem from the selected item
                        bottomOffsetHeight: 80.0,
                        // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                        menuItems: <FocusedMenuItem>[
                          // Add Each FocusedMenuItem  for Menu Options
                          FocusedMenuItem(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: Text(
                                LocalizationString.reply,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailingIcon: const Icon(Icons.reply, size: 18),
                              onPressed: () {
                                chatDetailController.setReplyMessage(
                                    message:
                                        chatDetailController.messages[index]);
                              }),
                          FocusedMenuItem(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: Text(
                                LocalizationString.fwd,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailingIcon: const Icon(
                                Icons.send,
                                size: 18,
                              ),
                              onPressed: () {
                                chatDetailController.selectMessage(
                                    chatDetailController.messages[index]);
                                chatDetailController.setToActionMode(
                                    mode: ChatMessageActionMode.forward);
                              }),
                          FocusedMenuItem(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              title: Text(
                                LocalizationString.delete,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailingIcon:
                                  const Icon(Icons.delete_outline, size: 18),
                              onPressed: () {
                                chatDetailController.selectMessage(
                                    chatDetailController.messages[index]);

                                chatDetailController.setToActionMode(
                                    mode: ChatMessageActionMode.delete);
                              }),
                        ],
                        onPressed: () {},
                        child: messageTile(index),
                      );
              },
            );
          }),
    );
  }

  Widget messageTile(int index) {
    return Obx(() {
      ChatMessageModel chatMessage = chatDetailController.messages[index];
      return Column(
        children: [
          chatMessage.isDateSeparator
              ? Container(
                  height: 25,
                  color: Theme.of(context)
                      .primaryColor
                      .lighten(0.2)
                      .withOpacity(0.5),
                  width: 100,
                  child: Center(
                    child: Text(chatMessage.date),
                  ),
                ).round(15).bP25
              : ChatMessageTile(
                  message: chatMessage,
                  actionMode: chatDetailController.actionMode.value ==
                          ChatMessageActionMode.forward ||
                      chatDetailController.actionMode.value ==
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
    });
  }

  void messageTapped(ChatMessageModel model) async {
    if (model.messageContentType == MessageContentType.forward) {
      messageTapped(model.originalMessage);
    }
    if (model.messageContentType == MessageContentType.photo) {
      int index = chatDetailController.mediaMessages
          .indexWhere((element) => element == model);

      Get.to(() => MediaListViewer(
                chatRoom: chatDetailController.chatRoom,
                medias: chatDetailController.mediaMessages,
                startFrom: index,
              ))!
          .then((value) => loadChat());
    } else if (model.messageContentType == MessageContentType.video) {
      Get.to(() => VideoPlayerScreen(
                chatMessage: model,
              ))!
          .then((value) => loadChat());
    } else if (model.messageContentType == MessageContentType.post) {
      Get.to(() => SinglePostDetail(
                postId: model.postContent.postId,
              ))!
          .then((value) => loadChat());
    } else if (model.messageContentType == MessageContentType.contact) {
      openActionPopupForContact(model.mediaContent.contact!);
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
                      chatDetailController.addNewContact(contact);
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

  void replyMessageTapped(ChatMessageModel model) {
    int index = chatDetailController.messages.indexWhere((element) =>
        element.localMessageId == model.originalMessage.localMessageId);
    if (index != -1) {
      Timer(const Duration(milliseconds: 1), () {
        itemScrollController.jumpTo(
          index: index,
        );
      });
    }
  }

  void openGallery() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => ChooseMediaForChat(
              selectedMediaCompletetion: (medias) {
                for (Media media in medias) {
                  if (media.mediaType == GalleryMediaType.image) {
                    chatDetailController.sendImageMessage(
                        media: media,
                        mode: chatDetailController.actionMode.value,
                        context: context,
                        roomId: chatDetailController.chatRoomId);
                    Navigator.of(context).pop();
                  } else {
                    Get.back();
                    chatDetailController.sendVideoMessage(
                        media: media,
                        model: chatDetailController.actionMode.value,
                        context: context,
                        roomId: chatDetailController.chatRoomId);
                  }
                }
              },
            ));
  }

  void videoCall() {
    chatDetailController.initiateVideoCall(context);
  }

  void audioCall() {
    chatDetailController.initiateAudioCall(context);
  }

  selectUserForMessageForward() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            SelectUserToSendMessage(sendToUserCallback: (user) {
              // chatDetailController.forwardSelectedMessages(user);
            }, selectedUser: (user) {
              // chatDetailController.sendPostAsMessage(
              //     post: widget.model, toOpponent: user);
            })).then((value) {
      chatDetailController.setToActionMode(mode: ChatMessageActionMode.none);
    });
  }

  void openVoiceRecord() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => VoiceRecord(
              recordingCallback: (media) {
                chatDetailController.sendAudioMessage(
                    media: media,
                    mode: chatDetailController.actionMode.value,
                    context: context,
                    roomId: chatDetailController.chatRoomId);
              },
            ));
  }

  void openContactList() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => FractionallySizedBox(
              heightFactor: 1,
              child: ContactList(
                selectedContactsHandler: (contacts) {
                  for (Contact contact in contacts) {
                    chatDetailController.sendContactMessage(
                        contact: contact,
                        mode: chatDetailController.actionMode.value,
                        context: context,
                        roomId: chatDetailController.chatRoomId);
                  }
                },
              ),
            ));
  }

  void openLocationPicker() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
            heightFactor: 0.9,
            child: PlacePicker(
              apiKey: AppConfigConstants.googleMapApiKey,
              displayLocation: null,
            ))).then((location) {
      if (location != null) {
        LocationResult result = location as LocationResult;
        LocationModel locationModel = LocationModel(
            latitude: result.latLng!.latitude,
            longitude: result.latLng!.longitude,
            name: result.name!);

        chatDetailController.sendLocationMessage(
            location: locationModel,
            mode: chatDetailController.actionMode.value,
            context: context,
            roomId: chatDetailController.chatRoomId);
      }
    });
  }

  void deleteMessageActionPopup() {
    bool ifAnyMessageByOpponent = chatDetailController.selectedMessages
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
                      chatDetailController.deleteMessage(deleteScope: 1);
                      // postCardController.reportPost(widget.model);
                    }),
                divider(context: context),
                ifAnyMessageByOpponent == false
                    ? ListTile(
                        title: Center(
                            child:
                                Text(LocalizationString.deleteMessageForAll)),
                        onTap: () async {
                          Get.back();
                          chatDetailController.deleteMessage(deleteScope: 2);
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
