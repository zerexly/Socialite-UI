import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class StarredMessages extends StatefulWidget {
  final ChatRoomModel? chatRoom;

  const StarredMessages({Key? key, required this.chatRoom}) : super(key: key);

  @override
  State<StarredMessages> createState() => _StarredMessagesState();
}

class _StarredMessagesState extends State<StarredMessages> {
  final ChatRoomDetailController _chatRoomDetailController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
              return _chatDetailController.actionMode.value ==
                      ChatMessageActionMode.edit
                  ? selectedMessageView()
                  : Container();
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
              Get.back();
            }),
            const Spacer(),
            Text(
              LocalizationString.edit,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w400),
            ).p8.ripple(() {
              _chatDetailController.setToActionMode(
                  mode: ChatMessageActionMode.edit);
            }),
          ],
        ).hP16,
        Positioned(
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                LocalizationString.starredMessages,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ))
      ],
    );
  }

  Widget selectedMessageView() {
    return Container(
      color: Theme.of(context).backgroundColor.darken(0.02),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocalizationString.delete,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w900),
          ).ripple(() {
            deleteMessageActionPopup();
          }),
          Text(
            LocalizationString.forward,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w900),
          ).ripple(() {
            selectUserForMessageForward();
          }),
          Text(
            LocalizationString.unStar,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w900),
          ).ripple(() {
            _chatRoomDetailController.unStarMessages();
            _chatDetailController.setToActionMode(
                mode: ChatMessageActionMode.none);
          }),
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
    );
  }

  Widget messagesListView() {
    return Container(
      decoration: _chatDetailController.wallpaper.value.isEmpty
          ? null
          : BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_chatDetailController.wallpaper.value),
                fit: BoxFit.cover,
              ),
            ),
      child: Obx(() => ListView.builder(
            padding:
                const EdgeInsets.only(top: 10, bottom: 50, left: 16, right: 16),
            itemCount: _chatRoomDetailController.starredMessages.length,
            itemBuilder: (ctx, index) {
              return messageTile(index);
            },
          )),
    );
  }

  Widget messageTile(int index) {
    return Obx(() {
      ChatMessageModel chatMessage =
          _chatRoomDetailController.starredMessages[index];
      return Column(
        children: [
          ChatMessageTile(
            message: chatMessage,
            showName: true,
            actionMode: _chatDetailController.actionMode.value ==
                ChatMessageActionMode.edit,
            replyMessageTapHandler: (message) {
              // replyMessageTapped(chatMessage);
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
      int index = _chatDetailController.mediaMessages
          .indexWhere((element) => element == model);

      Get.to(() => MediaListViewer(
            chatRoom: _chatDetailController.chatRoom.value!,
            medias: _chatDetailController.mediaMessages,
            startFrom: index,
          ));
    } else if (model.messageContentType == MessageContentType.video) {
      Get.to(() => PlayVideoController(
            chatMessage: model,
          ));
    } else if (model.messageContentType == MessageContentType.post) {
      Get.to(() => SinglePostDetail(
            postId: model.postContent.postId,
          ));
    } else if (model.messageContentType == MessageContentType.contact) {
      openActionPopupForContact(model.mediaContent.contact!);
    } else if (model.messageContentType == MessageContentType.profile) {
      Get.to(() => OtherUserProfile(
            userId: model.profileContent.userId,
          ));
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

  selectUserForMessageForward() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) =>
            SelectFollowingUserForMessageSending(sendToUserCallback: (user) {
              _chatDetailController.getChatRoomWithUser(
                  userId:user.id,
                  callback: (room) {
                        _chatDetailController.forwardSelectedMessages(
                            room: room);
                        Get.back();
                      });
            })).then((value) {
      _chatDetailController.setToActionMode(mode: ChatMessageActionMode.none);
    });
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
                ifAnyMessageByOpponent == false
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
