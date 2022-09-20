import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChooseStoryViewers extends StatefulWidget {
  final List<Media> images;

  const ChooseStoryViewers({Key? key, required this.images}) : super(key: key);

  @override
  State<ChooseStoryViewers> createState() => _ChooseStoryViewersState();
}

class _ChooseStoryViewersState extends State<ChooseStoryViewers> {
  final HomeController homeController = Get.find();
  List<UserModel> selectedUsers = [];

  final AppStoryController storyController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ThemeIconWidget(
                  ThemeIcon.close,
                  color: Theme.of(context).primaryColor,
                  size: 27,
                ).ripple(() {
                  Get.back();
                }),
                const Spacer(),
                Text(
                  LocalizationString.friends,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor).copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                const SizedBox(
                  width: 27,
                ),
              ],
            ).hp(20),
            Expanded(
              child: GetBuilder<HomeController>(
                  init: homeController,
                  builder: (ctx) {
                    return homeController.followingUsers.isEmpty
                        ? homeController.isLoading == false
                            ? Center(
                                child: Text(LocalizationString.noData,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w900)))
                            : Container()
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 40),
                            itemCount: homeController.followingUsers.length,
                            itemBuilder: (context, index) {
                              return UserCard(
                                model: homeController.followingUsers[index],
                                canSelect: true,
                                isSelected: selectedUsers.contains(
                                    homeController.followingUsers[index]),
                                selectionHandler: () {
                                  if (selectedUsers.contains(
                                      homeController.followingUsers[index])) {
                                    selectedUsers.remove(
                                        homeController.followingUsers[index]);
                                  } else {
                                    selectedUsers.add(
                                        homeController.followingUsers[index]);
                                  }
                                  setState(() {});
                                },
                              ).hp(20);
                            });
                  }),
            ),
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: BorderButtonType1(
                      textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor).copyWith(fontWeight: FontWeight.w900),
                      text: LocalizationString.postToStory,
                      onPress: () {
                        uploadStory();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: FilledButtonType1(
                      isEnabled: selectedUsers.isNotEmpty,
                      disabledTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor).copyWith(fontWeight: FontWeight.w900),
                      enabledTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w900),
                      enabledBackgroundColor: Theme.of(context).primaryColor,
                      disabledBackgroundColor: Theme.of(context).disabledColor,
                      text: selectedUsers.isNotEmpty
                          ? '${LocalizationString.shareTo} (${selectedUsers.length}) ${LocalizationString.friends}'
                          : LocalizationString.share,
                      onPress: () {
                        uploadStory();
                      },
                    ),
                  )
                ],
              ).hp(20),
            )
          ],
        ));
  }

  uploadStory() {
    storyController.uploadAllMedia(items: widget.images,context: context);
  }
}
