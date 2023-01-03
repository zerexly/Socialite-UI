import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class TvListByCategory extends StatefulWidget {
  final TvCategoryModel category;

  const TvListByCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<TvListByCategory> createState() => _TvListByCategoryState();
}

class _TvListByCategoryState extends State<TvListByCategory> {
  final TvStreamingController _tvStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tvStreamingController.getLiveTvs(categoryId: widget.category.id);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        // CustomScrollView.
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                  handle:
                  NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        sliver : SliverAppBar(
                          backgroundColor: Theme.of(context).backgroundColor,
                          expandedHeight: 200.0,
                          floating: true,
                          pinned: true,
                          forceElevated: true,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: Text(
                                widget.category.name,
                                textScaleFactor: 1,
                                style: TextStyle(color: Colors.white),
                              ),
                              background: CachedNetworkImage(
                                imageUrl: widget.category.coverImage,
                                fit: BoxFit.cover,
                                height: 170,
                                width: 180,
                              )),
                        )),
                  ) ),
            ];
          },
          body:
          CustomScrollView(
            slivers: [
              // Add the app bar to the CustomScrollView.

              // Next, create a SliverList
              GetBuilder<TvStreamingController>(
                  init: _tvStreamingController,
                  builder: (ctx) {
                    return
                      _tvStreamingController.liveTvs.isEmpty
                          ?
                      SliverToBoxAdapter(
                          child:
                          Container(
                              height: (MediaQuery.of(context).size.height/1.5),
                              width: (MediaQuery.of(context).size.width),
                              child:const Center(
                                  child :CircularProgressIndicator()))) :
                      SliverGrid(
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
                            _tvStreamingController.liveTvs[index];
                            return Card(
                                margin: const EdgeInsets.all(1),
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: tvModel.image,
                                  fit: BoxFit.fitHeight,
                                  height: 230,
                                ).round(10).ripple(() {
                                  Get.to(() => TVShowDetail(
                                    tvModel: tvModel,
                                  ));
                                }));
                          },
                          childCount: _tvStreamingController.liveTvs.length,
                        ),
                      );
                  })
            ],
          ),
        ));
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
//         Expanded(
//             child: GetBuilder<TvStreamingController>(
//                 init: _tvStreamingController,
//                 builder: (ctx) {
//                   return GridView.builder(
//                       padding: const EdgeInsets.only(
//                           left: 16, right: 16, top: 25, bottom: 25),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               crossAxisSpacing: 10.0,
//                               mainAxisSpacing: 10.0,
//                               childAspectRatio: 1),
//                       itemCount: _tvStreamingController.liveTvs.length,
//                       itemBuilder: (ctx, index) {
//                         TvModel tvModel =
//                             _tvStreamingController.liveTvs[index];
//
//                         return CachedNetworkImage(
//                           imageUrl: tvModel.image,
//                           fit: BoxFit.cover,
//                           height: 130,
//                           width: 110,
//                         ).round(10).ripple(() {
//                           Get.to(() =>  LiveTVStreaming(tvModel: tvModel,));
//                         });
//                       });
//                 }))
//       ],
//     ),
//   );
// }
}
