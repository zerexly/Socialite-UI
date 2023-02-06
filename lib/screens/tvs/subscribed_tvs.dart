import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/tvs/tv_channel_detail.dart';
import 'package:get/get.dart';
import 'package:foap/model/live_tv_model.dart';


class SubscribedTvList extends StatefulWidget {
  const SubscribedTvList({Key? key}) : super(key: key);

  @override
  State<SubscribedTvList> createState() => _SubscribedTvListState();
}

class _SubscribedTvListState extends State<SubscribedTvList> {
  final TvStreamingController _tvStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tvStreamingController.getSubscribedTvs();
    });
    super.initState();
  }

  @override
  void dispose() {
    _tvStreamingController.clearTvs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    sliver: SliverAppBar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      expandedHeight: 100.0,
                      floating: true,
                      pinned: true,
                      forceElevated: true,
                      leading: ThemeIconWidget(
                        ThemeIcon.backArrow,
                        size: 18,
                        color: Theme.of(context).iconTheme.color,
                      ).ripple(() {
                        Get.back();
                      }),
                      flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/tv/subscribed.png',
                                height: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                LocalizationString.subscribed,
                                textScaleFactor: 1,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          background: Container(
                            height: 170,
                            color: Theme.of(context).primaryColor,
                          ).overlay(Colors.black26)),
                    ),
                  )),
            ];
          },
          body: CustomScrollView(
            slivers: [
              // Next, create a SliverList
              GetBuilder<TvStreamingController>(
                  init: _tvStreamingController,
                  builder: (ctx) {
                    return _tvStreamingController.tvs.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                                height:
                                    (MediaQuery.of(context).size.height / 1.5),
                                width: (MediaQuery.of(context).size.width),
                                child: const Center(
                                    child: CircularProgressIndicator())))
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              mainAxisExtent: 140,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                TvModel tvModel =
                                    _tvStreamingController.tvs[index];
                                return Card(
                                    margin: const EdgeInsets.all(1),
                                    child: CachedNetworkImage(
                                      imageUrl: tvModel.image,
                                      fit: BoxFit.fitHeight,
                                      height: 230,
                                    ).round(10).ripple(() {
                                      Get.to(() => TVChannelDetail(
                                            tvModel: tvModel,
                                          ));
                                    })).round(5);
                              },
                              childCount: _tvStreamingController.tvs.length,
                            ),
                          );
                  })
            ],
          ),
        ));
  }
}
