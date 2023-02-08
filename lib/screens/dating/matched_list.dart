import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../../controllers/dating_controller.dart';
import 'dating_card.dart';

class MatchedList extends StatefulWidget {
  const MatchedList({Key? key}) : super(key: key);

  @override
  State<MatchedList> createState() => MatchedListState();
}

class MatchedListState extends State<MatchedList> {
  final DatingController datingController = Get.find();

  @override
  void initState() {
    super.initState();
    datingController.getMatchedProfilesApi();
  }

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
              child: GetBuilder<DatingController>(
                  init: datingController,
                  builder: (ctx) {
                    return datingController.isLoading.value
                        ? const CardsStackShimmerWidget()
                        : datingController.matchedUsers.isEmpty
                            ? emptyData(
                                title:
                                    LocalizationString.noMatchedProfilesFound,
                                subTitle:
                                    LocalizationString.datingExploreForMatched,
                                context: context)
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                shrinkWrap: true,
                                itemCount: datingController.matchedUsers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return matchedTile(
                                      datingController.matchedUsers[index]);
                                });
                  })),
        ],
      ),
    );
  }

  Widget matchedTile(UserModel profile) {
    return Container(
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    profile.picture != null
                        ? CachedNetworkImage(
                            imageUrl: profile.picture!,
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                            placeholder: (context, url) => SizedBox(
                                height: 40,
                                width: 40,
                                child: const CircularProgressIndicator().p16),
                            errorWidget: (context, url, error) =>
                                const SizedBox(
                                    child: Icon(
                              Icons.error,
                              // size: size / 2,
                            )),
                          ).circular
                        : Image.asset(
                            'assets/images/avatar_1.jpg',
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
                            profile.userName,
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
