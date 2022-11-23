import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class LiveTVCategoriesList extends StatefulWidget {
  const LiveTVCategoriesList({Key? key}) : super(key: key);

  @override
  State<LiveTVCategoriesList> createState() => _LiveTVCategoriesListState();
}

class _LiveTVCategoriesListState extends State<LiveTVCategoriesList> {
  final TvStreamingController _liveTvStreamingController = Get.find();

  @override
  void initState() {
    _liveTvStreamingController.getTvCategories();
    super.initState();
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
            title: LocalizationString.categories,
          ),
          divider(context: context).tP8,
          Expanded(
              child: GetBuilder<TvStreamingController>(
                  init: _liveTvStreamingController,
                  builder: (ctx) {
                    return GridView.builder(
                        itemCount: _liveTvStreamingController.categories.length,
                        padding: const EdgeInsets.only(
                            top: 20, left: 16, right: 16, bottom: 50),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1),
                        itemBuilder: (ctx, index) {
                          TvCategoryModel category =
                              _liveTvStreamingController.categories[index];
                          return CategoryAvatarType1(category: category)
                              .ripple(() {});
                        });
                  }))
        ],
      ),
    );
  }
}
