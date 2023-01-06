import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class PodcastListDashboard extends StatefulWidget {
  const PodcastListDashboard({Key? key}) : super(key: key);

  @override
  State<PodcastListDashboard> createState() => _PodcastListDashboardState();
}

class _PodcastListDashboardState extends State<PodcastListDashboard> {
  final PodcastStreamingController _podcastStreamingController = Get.find();
  final CarouselController _controller = CarouselController();
  int _current = 0;

  @override
  void initState() {
    _podcastStreamingController.getPodcastCategories();
    _podcastStreamingController.getPodcastBanners();
    super.initState();
  }

  @override
  void dispose() {
    _podcastStreamingController.clearCategories();
    _podcastStreamingController.clearBanners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            backNavigationBar(
                    context: context, title: LocalizationString.podcast)
                .tp(50),
            divider(context: context).tP8,
            Expanded(
                child: GetBuilder<PodcastStreamingController>(
                    init: _podcastStreamingController,
                    builder: (ctx) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                            _podcastStreamingController.categories.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if(index == 0) {
                            return  _podcastStreamingController.banners.length == 1
                                ? CachedNetworkImage(
                              imageUrl:
                              _podcastStreamingController.banners[0].coverImageUrl ??
                                  "",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                            )
                                .round(10)
                                .setPadding(top: 10, bottom: 15, left: 15, right: 15)
                                : Stack(children: [
                              CarouselSlider(
                                items: [
                                  for (PodcastBannerModel image
                                  in _podcastStreamingController.banners)
                                    CachedNetworkImage(
                                      imageUrl: image.coverImageUrl ?? "",
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                    ).round(10).setPadding(
                                        top: 10, bottom: 0, left: 10, right: 10)
                                ],
                                options: CarouselOptions(
                                  autoPlayInterval: const Duration(seconds: 4),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _podcastStreamingController.banners
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () => _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey)
                                                .withOpacity(
                                                _current == entry.key ? 0.9 : 0.4)),
                                      ),
                                    );
                                  }).toList(),
                                ).alignBottomCenter,
                              ),
                            ]);
                          } else {
                            return podcastByCategory(
                                _podcastStreamingController.categories[index-1]);
                          }
                        }
                      );
                    })),
          ],
        ));
  }

  podcastByCategory(PodcastCategoryModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Text(
            model.name,
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
            Get.to(() => PodcastListByCategory(category: model));
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
          itemCount: model.podcasts.length,
          itemBuilder: (BuildContext context, int index) => CachedNetworkImage(
            imageUrl: model.podcasts[index].image,
            fit: BoxFit.cover,
            height: 170,
            width: 180,
          ).round(10).ripple(() {
            Get.to(() => PodcastShowDetail(
                  podcastModel: model.podcasts[index],
                ));
          }),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(width: 8);
          },
        ),
      ).setPadding(top: 8, bottom: 22),
    ]);
  }
}
