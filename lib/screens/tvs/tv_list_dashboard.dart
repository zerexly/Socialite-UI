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
    _tvStreamingController.getBannersTvs();
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
          const SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              SizedBox(
                height: 250,
                child: GetBuilder<TvStreamingController>(
                    init: _tvStreamingController,
                    builder: (ctx) {
                      return CarouselSlider(
                        items: [
                          for (TvModel tv in _tvStreamingController.banners)
                            CachedNetworkImage(
                              imageUrl: tv.image,
                              fit: BoxFit.cover,
                              width: Get.width,
                            ).ripple(() {
                              Get.to(() => LiveTVStreaming(
                                    tvModel: tv,
                                  ));
                            })
                        ],
                        options: CarouselOptions(
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            height: double.infinity,
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              _tvStreamingController.updateBannerSlider(index);
                            },
                            autoPlay: true),
                      );
                    }),
              ),
              if (_tvStreamingController.banners.isNotEmpty)
                Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Obx(
                        () {
                          return DotsIndicator(
                            dotsCount: _tvStreamingController.banners.length,
                            position:
                                (_tvStreamingController.currentBannerIndex)
                                    .toDouble(),
                            decorator: DotsDecorator(
                                activeColor: Theme.of(context).primaryColor),
                          );
                        },
                      ),
                    ))
            ],
          ),
          const SizedBox(
            height: 15,
          ),
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
