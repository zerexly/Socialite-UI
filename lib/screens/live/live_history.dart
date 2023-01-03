import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class LiveHistory extends StatefulWidget {
  const LiveHistory({Key? key}) : super(key: key);

  @override
  LiveHistoryState createState() => LiveHistoryState();
}

class LiveHistoryState extends State<LiveHistory> {
  final LiveHistoryController _liveHistoryController = Get.find();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
        } else {
          _liveHistoryController.getLiveHistory();
        }
      }
    });

    _liveHistoryController.getLiveHistory();
  }

  @override
  void dispose() {
    super.dispose();
    _liveHistoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 50,
        ),
        backNavigationBar(context: context, title: LocalizationString.live),
        divider(context: context).tP8,
        Expanded(
          child: GetBuilder<LiveHistoryController>(
              init: _liveHistoryController,
              builder: (ctx) {
                return ListView.separated(
                    controller: _controller,
                    padding: const EdgeInsets.only(top: 20, bottom: 70),
                    itemBuilder: (ctx, index) {
                      LiveModel live = _liveHistoryController.lives[index];
                      return Container(
                        color: Theme.of(context).cardColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ThemeIconWidget(
                                  ThemeIcon.calendar,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${LocalizationString.startedAt} ${live.startedAt!}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ThemeIconWidget(
                                  ThemeIcon.diamond,
                                  size: 15,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  live.giftSummary!.totalCoin.toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    ThemeIconWidget(
                                      ThemeIcon.clock,
                                      size: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      live.totalTime.formatTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ).p16,
                      ).round(10);
                    },
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemCount: _liveHistoryController.lives.length);
              }).hP16,
        ),
      ]),
    );
  }
}
