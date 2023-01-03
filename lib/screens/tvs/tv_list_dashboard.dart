import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../../model/tv_banner_model.dart';

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
    // TODO: implement dispose
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
            AppBar(
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: Icon(Icons.arrow_back,),
              ),
              title: const Text(
                "Categories",
                style: TextStyle(fontWeight:FontWeight.normal ),
              ),
            ),
            divider(context: context).tP8,
            Stack(children: [
              CarouselSlider(
                items: [
                  for (TVBannersModel image in _tvStreamingController.banners)
                    CachedNetworkImage(
                      imageUrl:image.coverImageUrl ?? "",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 230,
                    )
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
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _tvStreamingController.banners.asMap().entries.map((entry) {
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
                    )),
              ),
            ]),
            Expanded(
                child: GetBuilder<TvStreamingController>(
                    init: _tvStreamingController,
                    builder: (ctx) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _tvStreamingController.categories.length,
                        itemBuilder: (BuildContext context, int index) =>
                            tvChannelsByCategory(
                                _tvStreamingController.categories[index]),
                      );
                    })),
          ],
        ));
  }

  tvChannelsByCategory(TvCategoryModel model) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 8.0),
            child: Text(
              model.name,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w500),
            ).lP16,
          ),
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
          itemBuilder: (BuildContext context, int index) => ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: model.tvs[index].image,
                fit: BoxFit.cover,
                height: 170,
                width: 180,
              ).ripple(() {
                Get.to(() => LiveTVStreaming(
                  tvModel: model.tvs[index],
                ));
              })),
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: 8,
            );
          },
        ),
      ),
    ]);
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: Theme.of(context).backgroundColor,
//     body: Column(
//       children: [
//         const SizedBox(
//           height: 50,
//         ),
//         backNavigationBar(
//           context: context,
//           title: LocalizationString.tvs,
//         ),
//         divider(context: context).tP8,
//         const SizedBox(
//           height: 20,
//         ),
//         Stack(
//           children: [
//             SizedBox(
//               height: 250,
//               child: GetBuilder<TvStreamingController>(
//                   init: _tvStreamingController,
//                   builder: (ctx) {
//                     return CarouselSlider(
//                       items: [
//                         for (TvModel tv in _tvStreamingController.banners)
//                           CachedNetworkImage(
//                             imageUrl: tv.image,
//                             fit: BoxFit.cover,
//                             width: Get.width,
//                           ).ripple(() {
//                             Get.to(() => LiveTVStreaming(
//                                   tvModel: tv,
//                                 ));
//                           })
//                       ],
//                       options: CarouselOptions(
//                           enlargeCenterPage: true,
//                           enableInfiniteScroll: false,
//                           height: double.infinity,
//                           viewportFraction: 0.8,
//                           onPageChanged: (index, reason) {
//                             _tvStreamingController.updateBannerSlider(index);
//                           },
//                           autoPlay: true),
//                     );
//                   }),
//             ),
//             if (_tvStreamingController.banners.isNotEmpty)
//               Positioned(
//                   bottom: 10,
//                   left: 0,
//                   right: 0,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Obx(
//                       () {
//                         return DotsIndicator(
//                           dotsCount: _tvStreamingController.banners.length,
//                           position:
//                               (_tvStreamingController.currentBannerIndex)
//                                   .toDouble(),
//                           decorator: DotsDecorator(
//                               activeColor: Theme.of(context).primaryColor),
//                         );
//                       },
//                     ),
//                   ))
//           ],
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         Expanded(
//             child: GetBuilder<TvStreamingController>(
//                 init: _tvStreamingController,
//                 builder: (ctx) {
//                   return ListView.separated(
//                       padding: const EdgeInsets.only(top: 25, bottom: 50),
//                       itemBuilder: (ctx, categoryGroupIndex) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   _tvStreamingController
//                                       .categories[categoryGroupIndex].name,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleSmall!
//                                       .copyWith(fontWeight: FontWeight.w500),
//                                 ).lP16,
//                                 const Spacer(),
//                                 const ThemeIconWidget(
//                                   ThemeIcon.nextArrow,
//                                   size: 15,
//                                 ).rP16.ripple(() {
//                                   Get.to(() => TvListByCategory(
//                                       category: _tvStreamingController
//                                           .categories[categoryGroupIndex]));
//                                 }),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             SizedBox(
//                               height: 130,
//                               child: ListView.separated(
//                                 padding: const EdgeInsets.only(
//                                     left: 16, right: 16),
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: _tvStreamingController
//                                     .categories[categoryGroupIndex]
//                                     .tvs
//                                     .length,
//                                 itemBuilder: (ctx, tvIndex) {
//                                   TvModel tvModel = _tvStreamingController
//                                       .categories[categoryGroupIndex]
//                                       .tvs[tvIndex];
//                                   return CachedNetworkImage(
//                                     imageUrl: tvModel.image,
//                                     fit: BoxFit.cover,
//                                     height: 130,
//                                     width: 110,
//                                   ).round(10).ripple(() {
//                                     Get.to(() => LiveTVStreaming(
//                                           tvModel: tvModel,
//                                         ));
//                                   });
//                                 },
//                                 separatorBuilder: (ctx, index) {
//                                   return const SizedBox(width: 10);
//                                 },
//                               ),
//                             )
//                           ],
//                         );
//                       },
//                       separatorBuilder: (ctx, index) {
//                         return const SizedBox(
//                           height: 40,
//                         );
//                       },
//                       itemCount: _tvStreamingController.categories.length);
//                 }))
//       ],
//     ),
//   );
// }
}
