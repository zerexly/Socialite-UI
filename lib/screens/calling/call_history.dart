import 'package:foap/components/call_history_tile.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key? key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  final CallHistoryController callHistoryController = Get.find();

  @override
  void initState() {
    callHistoryController.callHistory();
    super.initState();
  }

  @override
  void dispose() {
    callHistoryController.clear();
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
                  LocalizationString.callLog,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  child: ThemeIconWidget(
                    ThemeIcon.mobile,
                    color: Theme.of(context).iconTheme.color,
                    size: 15,
                  ).p4.ripple(() {
                    selectUsers();
                  }),
                ).borderWithRadius(context: context, value: 2, radius: 8),
              ],
            ).setPadding(left: 16, right: 16, top: 8, bottom: 16),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<CallHistoryController>(
                  init: callHistoryController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!callHistoryController.isLoading) {
                          callHistoryController.callHistory();
                        }
                      }
                    });

                    return ListView.separated(
                        padding: const EdgeInsets.only(top: 20, bottom: 100),
                        controller: scrollController,
                        itemBuilder: (ctx, index) {
                          return CallHistoryTile(
                                  model: callHistoryController.calls[index])
                              .ripple(() {
                            callHistoryController.reInitiateCall(
                                call: callHistoryController.calls[index],
                                context: context);
                          });
                        },
                        separatorBuilder: (ctx, index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: callHistoryController.calls.length);
                  }).hP16,
            ),
          ],
        ));
  }

  void selectUsers() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const SelectUserForChat());
  }
}
