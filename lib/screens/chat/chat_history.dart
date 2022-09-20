import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final ChatController chatController = Get.find();

  @override
  void initState() {
    super.initState();
    chatController.getChatRooms();
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
              Text(
                LocalizationString.chats,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                child: ThemeIconWidget(
                  ThemeIcon.edit,
                  color: Theme.of(context).iconTheme.color,
                  size: 15,
                ).p4.ripple(() {
                  selectUsers();
                }),
              ).borderWithRadius(context: context, value: 2, radius: 8),
            ],
          ).setPadding(left: 16, right: 16, top: 8, bottom: 16),
          divider(context: context).vP8,
          Expanded(child: chatListView().hP16)
        ],
      ),
    );
  }

  Widget chatListView() {
    return GetBuilder<ChatController>(
        init: chatController,
        builder: (ctx) {
          return ListView.separated(
              padding: const EdgeInsets.only(top: 10,bottom: 50),
              itemCount: chatController.rooms.length,
              itemBuilder: (ctx, index) {
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    chatController.deleteRoom(chatController.rooms[index]);
                  },
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          LocalizationString.delete,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(fontWeight: FontWeight.w900).copyWith(color: Colors.white70),
                        )
                      ],
                    ).hP25,
                  ),
                  child: ChatHistoryTile(model: chatController.rooms[index])
                      .ripple(() {
                    ChatRoomModel model = chatController.rooms[index];
                    chatController.clearUnreadCount(chatRoom: model);
                    Get.to(() =>
                        ChatDetail(chatRoom: model, opponent: model.opponent))!.then((value) {
                    });
                  }),
                );
              },
              separatorBuilder: (ctx, index) {
                return divider(context: context).vP8;
              });
        });
  }

  void selectUsers() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const SelectUserForChat());
  }
}
