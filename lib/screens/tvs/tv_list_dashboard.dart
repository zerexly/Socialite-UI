import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class TvListDashboard extends StatefulWidget {
  const TvListDashboard({Key? key}) : super(key: key);

  @override
  State<TvListDashboard> createState() => _TvListDashboardState();
}

class _TvListDashboardState extends State<TvListDashboard> {
  final TvStreamingController _tvStreamingController = Get.find();
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  void initState() {
    _tvStreamingController.getTvCategories();
    _tvStreamingController.getTvBanners();
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
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            backNavigationBar(context: context, title: LocalizationString.tvs)
                .tp(50),
            divider(context: context).tP8,
            Expanded(
                child: GetBuilder<TvStreamingController>(
                    init: _tvStreamingController,
                    builder: (ctx) {
                      return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount:
                              _tvStreamingController.categories.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return _tvStreamingController.banners.length == 1
                                  ? CachedNetworkImage(
                                      imageUrl: _tvStreamingController
                                              .banners[0].coverImageUrl ??
                                          "",
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 230,
                                    ).round(10).setPadding(
                                      top: 10, bottom: 0, left: 15, right: 15)
                                  : Stack(children: [
                                      CarouselSlider(
                                        items: [
                                          for (TVBannersModel image
                                              in _tvStreamingController.banners)
                                            CachedNetworkImage(
                                              imageUrl:
                                                  image.coverImageUrl ?? "",
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 230,
                                            ).round(10).setPadding(
                                                top: 10,
                                                bottom: 0,
                                                left: 10,
                                                right: 10)
                                        ],
                                        options: CarouselOptions(
                                          autoPlayInterval:
                                              const Duration(seconds: 4),
                                          autoPlay: true,
                                          enlargeCenterPage: false,
                                          enableInfiniteScroll: true,
                                          height: 200,
                                          viewportFraction: 1,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          },
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: _tvStreamingController
                                              .banners
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return Container(
                                              width: 12.0,
                                              height: 12.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Colors.grey)
                                                      .withOpacity(
                                                          _current == entry.key
                                                              ? 0.9
                                                              : 0.4)),
                                            ).ripple(() {
                                              _controller
                                                  .animateToPage(entry.key);
                                            });
                                          }).toList(),
                                        ).alignBottomCenter,
                                      ),
                                    ]);
                            } else {
                              return tvChannelsByCategory(
                                  _tvStreamingController.categories[index - 1]);
                            }
                          });
                    })),
          ],
        ));
  }

  tvChannelsByCategory(TvCategoryModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text(
            model.name,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w500),
          ).setPadding(top: 20, bottom: 8, left: 16, right: 0),
          const Spacer(),
          const ThemeIconWidget(
            ThemeIcon.nextArrow,
            size: 15,
          ).rP16.ripple(() {
            Get.to(() => TvListByCategory(category: model));
          }),
        ],
      ),
      SizedBox(
        height: 170,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: model.tvs.length,
          itemBuilder: (BuildContext context, int index) => CachedNetworkImage(
            imageUrl: model.tvs[index].image,
            fit: BoxFit.cover,
            height: 170,
            width: 180,
          ).round(10).ripple(() {
            Get.to(() => TVShowDetail(
                  tvModel: model.tvs[index],
                ));
          }),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 8);
          },
        ),
      ),
    ]);
  }
}
