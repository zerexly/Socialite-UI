import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final ChatHistoryController _chatController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    super.initState();
    _chatController.getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: Container(
        height: 50,
        width: 50,
        color: Theme.of(context).primaryColor,
        child: const ThemeIconWidget(
          ThemeIcon.edit,
          size: 25,
        ),
      ).circular.bP16.ripple(() {
        selectUsers();
      }),
      body: KeyboardDismissOnTap(
          child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          (_settingsController.setting.value!.enableAudioCalling ||
                  _settingsController.setting.value!.enableVideoCalling)
              ? titleNavigationBarWithIcon(
                  context: context,
                  title: LocalizationString.chats,
                  icon: ThemeIcon.mobile,
                  completion: () {
                    Get.to(() => const CallHistory());
                  })
              : titleNavigationBar(
                  context: context,
                  title: LocalizationString.chats,
                ),
          divider(context: context).tP8,
          SearchBar(
                  showSearchIcon: true,
                  iconColor: Theme.of(context).primaryColor,
                  onSearchChanged: (value) {
                    _chatController.searchTextChanged(value);
                  },
                  onSearchStarted: () {
                    //controller.startSearch();
                  },
                  onSearchCompleted: (searchTerm) {})
              .p16,
          Expanded(child: chatListView().hP16)
        ],
      )),
    );
  }

  Widget chatListView() {
    return GetBuilder<ChatHistoryController>(
        init: _chatController,
        builder: (ctx) {
          return _chatController.searchedRooms.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  itemCount: _chatController.searchedRooms.length,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        _chatController
                            .deleteRoom(_chatController.searchedRooms[index]);
                      },
                      background: Container(
                        color: Theme.of(context).errorColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              LocalizationString.delete,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w900)
                                  .copyWith(color: Colors.white70),
                            )
                          ],
                        ).hP25,
                      ),
                      child: ChatHistoryTile(
                              model: _chatController.searchedRooms[index])
                          .ripple(() {
                        ChatRoomModel model =
                            _chatController.searchedRooms[index];
                        _chatController.clearUnreadCount(chatRoom: model);

                        Get.to(() => ChatDetail(chatRoom: model))!
                            .then((value) {
                          _chatController.getChatRooms();
                        });
                      }),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 20,
                    );
                  })
              : _chatController.isLoading == true
                  ? Container()
                  : emptyData(
                      title: LocalizationString.noChatFound,
                      subTitle: LocalizationString.followSomeUserToChat,
                      context: context);
        });
  }

  void selectUsers() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: SelectUserForChat(userSelected: (user) {
                _chatDetailController.getChatRoomWithUser(
                    userId: user.id,
                    callback: (room) {
                      EasyLoading.dismiss();

                      Get.back();
                      Get.to(() => ChatDetail(
                                // opponent: usersList[index - 1].toChatRoomMember,
                                chatRoom: room,
                              ))!
                          .then((value) {
                        _chatController.getChatRooms();
                      });
                    });
              }),
            ));
  }
}
