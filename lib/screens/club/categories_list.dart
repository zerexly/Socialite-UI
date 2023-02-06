import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  final ClubsController _clubsController = Get.find();

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
              child: GetBuilder<ClubsController>(
                  init: _clubsController,
                  builder: (ctx) {
                    return GridView.builder(
                        itemCount: _clubsController.categories.length,
                        padding: const EdgeInsets.only(
                            top: 20, left: 16, right: 16, bottom: 50),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                childAspectRatio: 1),
                        itemBuilder: (ctx, index) {
                          CategoryModel category =
                              _clubsController.categories[index];
                          return CategoryAvatarType1(category: category)
                              .ripple(() {
                            ClubModel club = ClubModel();
                            club.categoryId = category.id;
                            Get.to(() => CreateClub(
                                  club: club,

                                ));
                          });
                        });
                  }))
        ],
      ),
    );
  }
}
