import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class TvListDashboard extends StatefulWidget {
  const TvListDashboard({Key? key}) : super(key: key);

  @override
  State<TvListDashboard> createState() => _TvListDashboardState();
}

class _TvListDashboardState extends State<TvListDashboard> {
  final TvStreamingController _tvStreamingController = Get.find();

  @override
  void initState() {
    _tvStreamingController.getTvCategories();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tvStreamingController.clearTvs();
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
          backNavigationBar(
            context: context,
            title: LocalizationString.tvs,
          ),
          divider(context: context).tP8,
          Expanded(
              child: GetBuilder<TvStreamingController>(
                  init: _tvStreamingController,
                  builder: (ctx) {
                    return ListView.separated(
                        padding: const EdgeInsets.only(top: 25, bottom: 50),
                        itemBuilder: (ctx, categoryGroupIndex) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _tvStreamingController
                                        .categories[categoryGroupIndex].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ).lP16,
                                  const Spacer(),
                                  const ThemeIconWidget(
                                    ThemeIcon.nextArrow,
                                    size: 15,
                                  ).rP16.ripple(() {
                                    Get.to(() => TvListByCategory(
                                        category: _tvStreamingController
                                            .categories[categoryGroupIndex]));
                                  }),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                height: 130,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _tvStreamingController
                                      .categories[categoryGroupIndex]
                                      .tvs
                                      .length,
                                  itemBuilder: (ctx, tvIndex) {
                                    TvModel tvModel = _tvStreamingController
                                        .categories[categoryGroupIndex]
                                        .tvs[tvIndex];
                                    return CachedNetworkImage(
                                      imageUrl: tvModel.image,
                                      fit: BoxFit.cover,
                                      height: 130,
                                      width: 110,
                                    ).round(10).ripple(() {
                                      Get.to(() => LiveTVStreaming(
                                            tvModel: tvModel,
                                          ));
                                    });
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return const SizedBox(width: 10);
                                  },
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (ctx, index) {
                          return const SizedBox(
                            height: 40,
                          );
                        },
                        itemCount: _tvStreamingController.categories.length);
                  }))
        ],
      ),
    );
  }
}
