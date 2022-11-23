import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class GroupChatRoomDetail extends StatefulWidget {
  final ChatRoomModel chatRoom;

  const GroupChatRoomDetail({Key? key, required this.chatRoom})
      : super(key: key);

  @override
  State<GroupChatRoomDetail> createState() => _GroupChatRoomDetailState();
}

class _GroupChatRoomDetailState extends State<GroupChatRoomDetail> {
  final ChatRoomDetailController chatRoomDetailController = Get.find();
  final ChatDetailController chatDetailController = Get.find();

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
                Text(
                  LocalizationString.contactInfo,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w900)
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  width: 20,
                )
              ],
            ).hP16,
            divider(context: context).vP8,
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  roomInfo(),
                  const SizedBox(
                    height: 25,
                  ),
                  callWidgets(),
                  const SizedBox(
                    height: 50,
                  ),
                  mediaWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  participantsWidget(),
                  const SizedBox(
                    height: 50,
                  ),
                  extraOptionsWidget()
                ],
              ),
            )
          ],
        ));
  }

  Widget mediaWidget() {
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
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
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
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
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
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
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
          chatRoomDetailController.deleteRoomChat(widget.chatRoom);
          AppUtil.showToast(
              context: context,
              message: LocalizationString.chatDeleted,
              isSuccess: true);
        })
      ],
    ).round(10).shadow(context: context, shadowOpacity: 0.1).hP16;
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

  Widget roomInfo() {
    return Column(
      children: [
        UserAvatarView(
          user: widget.chatRoom.opponent.userDetail,
          size: 100,
          onTapHandler: () {
            //open live
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          widget.chatRoom.opponent.userDetail.userName,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w900),
        )
      ],
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.chatRoom.roomMembers.length} ${LocalizationString.participants}',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: widget.chatRoom.roomMembers.length * 50,
          color: Theme.of(context).cardColor,
          child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: widget.chatRoom.roomMembers.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return UserTile(profile: widget.chatRoom.roomMembers[index].userDetail).hP8;
              },
              separatorBuilder: (ctx, index) {
                return divider(context: context).vP4;
              }).vP8,
        ).round(10).shadow(context: context, shadowOpacity: 0.1),
      ],
    ).hP16;
  }

  void exportChatWithMedia() {
    chatRoomDetailController.exportChat(
        roomId: widget.chatRoom.id, includeMedia: true);
  }

  void exportChatWithoutMedia() {
    chatRoomDetailController.exportChat(
        roomId: widget.chatRoom.id, includeMedia: false);
  }

  void videoCall() {
    chatDetailController.initiateVideoCall(context);
  }

  void audioCall() {
    chatDetailController.initiateAudioCall(context);
  }
}
