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
                    return GridView.builder(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 25, bottom: 25),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1),
                        itemCount: _tvStreamingController.liveTvs.length,
                        itemBuilder: (ctx, index) {
                          TvModel tvModel =
                              _tvStreamingController.liveTvs[index];

                          return CachedNetworkImage(
                            imageUrl: tvModel.image,
                            fit: BoxFit.cover,
                            height: 130,
                            width: 110,
                          ).round(10).ripple(() {
                            Get.to(() =>  LiveTVStreaming(tvModel: tvModel,));
                          });
                        });
                  }))
        ],
      ),
    );
  }
}
