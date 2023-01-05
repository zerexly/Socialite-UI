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
                      expandedHeight: 200.0,
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
                          title: Text(
                            widget.category.name,
                            textScaleFactor: 1,
                            style: const TextStyle(color: Colors.white),
                          ),
                          background: CachedNetworkImage(
                            imageUrl: widget.category.coverImage,
                            fit: BoxFit.cover,
                            height: 170,
                            width: 180,
                          )),
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
                    return _tvStreamingController.liveTvs.isEmpty
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
                                    _tvStreamingController.liveTvs[index];
                                return Card(
                                    margin: const EdgeInsets.all(1),
                                    child: CachedNetworkImage(
                                      imageUrl: tvModel.image,
                                      fit: BoxFit.fitHeight,
                                      height: 230,
                                    ).round(10).ripple(() {
                                      Get.to(() => TVShowDetail(
                                            tvModel: tvModel,
                                          ));
                                    })).round(5);
                              },
                              childCount: _tvStreamingController.liveTvs.length,
                            ),
                          );
                  })
            ],
          ),
        ));
  }
}
