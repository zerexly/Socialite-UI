import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import 'dating_card.dart';

class MatchedList extends StatefulWidget {
  const MatchedList({Key? key}) : super(key: key);

  @override
  State<MatchedList> createState() => MatchedListState();
}

class MatchedListState extends State<MatchedList> {
  List<Profile> items = [
    const Profile(
        name: 'Rohini',
        distance: '10 miles away',
        imageAsset: 'assets/images/avatar_1.jpg'),
    const Profile(
        name: 'Rohini',
        distance: '10 miles away',
        imageAsset: 'assets/images/avatar_2.jpg'),
    const Profile(
        name: 'Rohini',
        distance: '10 miles away',
        imageAsset: 'assets/images/avatar_3.jpeg'),
    const Profile(
        name: 'Rohini',
        distance: '10 miles away',
        imageAsset: 'assets/images/avatar_4.jpeg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 50),
          backNavigationBar(
            context: context,
            title: LocalizationString.matched,
          ),
          divider(context: context).tP8,
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return matchedTile(items[index]);
                  })),
        ],
      ),
    );
  }

  Widget matchedTile(Profile profile) {
    return Container(
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      profile.imageAsset,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ).circular,
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rohini',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w900),
                          ).bP4,
                          Text(
                            'Canada',
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ).hP16,
                    ),
                    // const Spacer(),
                  ],
                ).ripple(() {
                  // if (viewCallback == null) {
                  //   profileController.setUser(profile);
                  //   Get.to(() => OtherUserProfile(userId: profile.id));
                  // } else {
                  //   viewCallback!();
                  // }
                }),
                const Spacer(),
                const ThemeIconWidget(
                  ThemeIcon.favFilled,
                  size: 18,
                  color: Colors.red,
                )
              ],
            ).paddingAll(15))
        .round(10)
        .paddingOnly(bottom: 15, left: 15, right: 15);
  }
}
