import 'package:foap/components/call_history_tile.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  final CallHistoryController _callHistoryController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();

  @override
  void initState() {
    _callHistoryController.callHistory();
    super.initState();
  }

  @override
  void dispose() {
    _callHistoryController.clear();
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
            backNavigationBarWithIcon(
                context: context,
                icon: ThemeIcon.mobile,
                title: LocalizationString.callLog,
                iconBtnClicked: () {
                  selectUsers();
                }),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<CallHistoryController>(
                  init: _callHistoryController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!_callHistoryController.isLoading) {
                          _callHistoryController.callHistory();
                        }
                      }
                    });

                    return _callHistoryController.calls.isNotEmpty
                        ? ListView.separated(
                            padding:
                                const EdgeInsets.only(top: 20, bottom: 100),
                            controller: scrollController,
                            itemBuilder: (ctx, index) {
                              return CallHistoryTile(
                                      model:
                                          _callHistoryController.calls[index])
                                  .ripple(() {
                                _callHistoryController.reInitiateCall(
                                    call: _callHistoryController.calls[index],
                                    context: context);
                              });
                            },
                            separatorBuilder: (ctx, index) {
                              return const SizedBox(
                                height: 20,
                              );
                            },
                            itemCount: _callHistoryController.calls.length)
                        : _callHistoryController.isLoading == true
                            ? Container()
                            : emptyData(
                                title: LocalizationString.noCallFound,
                                subTitle: LocalizationString.makeSomeCalls,
                                context: context);
                  }).hP16,
            ),
          ],
        ));
  }

  void selectUsers() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => SelectUserForChat(userSelected: (user) {
              _chatDetailController.getChatRoomWithUser(
                  userId: user.id,
                  callback: (room) {
                    EasyLoading.dismiss();

                    Get.back();
                    Get.to(() => ChatDetail(
                          // opponent: usersList[index - 1].toChatRoomMember,
                          chatRoom: room,
                        ));
                  });
            }));
  }
}
