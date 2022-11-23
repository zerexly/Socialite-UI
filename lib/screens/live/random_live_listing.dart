import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class RandomLiveListing extends StatefulWidget {
  const RandomLiveListing({Key? key}) : super(key: key);

  @override
  State<RandomLiveListing> createState() => _RandomLiveListingState();
}

class _RandomLiveListingState extends State<RandomLiveListing> {
  final RandomLivesController _randomLivesController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    _randomLivesController.getAllRandomLives();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _randomLivesController.clear();
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
          backNavigationBar(context: context, title: LocalizationString.live),
          divider(context: context).tP8,
          Expanded(child: liveList())
        ],
      ),
    );
  }

  Widget liveList() {
    return Obx(() {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            childAspectRatio: 0.8),
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 50),
        itemCount: _randomLivesController.randomUsers.length,
        itemBuilder: (context, index) {
          UserModel liveUser = _randomLivesController.randomUsers[index];
          return Stack(
            children: [
              CachedNetworkImage(
  imageUrl:
                liveUser.picture!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ).round(5),
              Positioned(
                  left: 8,
                  top: 8,
                  child: Row(
                    children: [
                      const ThemeIconWidget(
                        ThemeIcon.eye,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '5.5k',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )),

              Positioned(
                left: 8,
                bottom: 8,
                child: Row(
                  children: [
                    const AvatarView(
                        url:
                            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGZhY2V8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                        size: 25),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adam',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            const ThemeIconWidget(
                              ThemeIcon.diamond,
                              size: 10,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '5.5k',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
