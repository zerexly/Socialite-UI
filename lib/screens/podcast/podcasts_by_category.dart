import 'package:foap/helper/common_import.dart';
import 'package:foap/screens/podcast/podcast_host_detail.dart';
import 'package:get/get.dart';

import '../../controllers/podcast_streaming_controller.dart';
import '../../model/podcast_model.dart';

class PodcastListByCategory extends StatefulWidget {
  final PodcastCategoryModel category;

  const PodcastListByCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<PodcastListByCategory> createState() => _PodcastListByCategoryState();
}

class _PodcastListByCategoryState extends State<PodcastListByCategory> {
  final PodcastStreamingController _podcastStreamingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _podcastStreamingController.getPodCastList(categoryId: widget.category.id);
    });
    super.initState();
  }

  @override
  void dispose() {
    _podcastStreamingController.clearPodcast();
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
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverPadding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        sliver : SliverAppBar(
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
                        )),
                  ) ),
            ];
          },
          body:
          CustomScrollView(
            slivers: [
              // Next, create a SliverList
              GetBuilder<PodcastStreamingController>(
                  init: _podcastStreamingController,
                  builder: (ctx) {
                    return
                      _podcastStreamingController.podcasts.isEmpty
                          ?
                      SliverToBoxAdapter(
                          child:
                          SizedBox(
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
                            PodcastModel podcastModel =
                            _podcastStreamingController.podcasts[index];
                            return Card(
                                margin: const EdgeInsets.all(1),
                                child: CachedNetworkImage(
                                  imageUrl: podcastModel.image,
                                  fit: BoxFit.fitHeight,
                                  height: 230,
                                ).round(10).ripple(() {
                                  Get.to(() => PodcastHostDetail(
                                    podcastModel: podcastModel,
                                  ));
                                })).round(5);
                          },
                          childCount: _podcastStreamingController.podcasts.length,
                        ),
                      );
                  })
            ],
          ),
        ));
  }
}
