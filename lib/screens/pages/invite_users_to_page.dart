import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class InviteUsersToPage extends StatefulWidget {
  const InviteUsersToPage({Key? key}) : super(key: key);

  @override
  InviteUsersToPageState createState() => InviteUsersToPageState();
}

class InviteUsersToPageState extends State<InviteUsersToPage> {
  final SelectUserForGroupChatController selectUserForGroupChatController =
  Get.find();

  @override
  void initState() {
    selectUserForGroupChatController.getFriends();
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
          SizedBox(
            height: 40,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ThemeIconWidget(
                      ThemeIcon.close,
                      size: 20,
                    ).ripple(() {
                      Navigator.of(context).pop();
                    }),
                    Text(
                      LocalizationString.create,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).ripple(() {

                    }),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocalizationString.invite,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Obx(() => selectUserForGroupChatController
                          .selectedFriends.isNotEmpty
                          ? Text(
                        '${selectUserForGroupChatController.selectedFriends.length} ${LocalizationString.friendsSelected}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w900),
                      )
                          : Container())
                    ],
                  ),
                )
              ],
            ),
          ).hP16,
          divider(context: context).tP8,
          GetBuilder<SelectUserForGroupChatController>(
            init: selectUserForGroupChatController,
            builder: (ctx) {
              List<UserModel> usersList =
                  selectUserForGroupChatController.selectedFriends;
              return usersList.isNotEmpty
                  ? SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(
                        top: 20, left: 16, right: 16, bottom: 10),
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Column(
                            children: [
                              UserAvatarView(
                                user: usersList[index],
                                size: 50,
                              ).circular,
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                usersList[index].userName,
                                style:
                                Theme.of(context).textTheme.titleSmall,
                              )
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                                height: 25,
                                width: 25,
                                color: Theme.of(context).cardColor,
                                child: const ThemeIconWidget(
                                  ThemeIcon.close,
                                  size: 20,
                                )).circular.ripple(() {
                              selectUserForGroupChatController
                                  .selectFriend(usersList[index]);
                            }),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 15,
                      );
                    },
                  ))
                  : Container();
            },
          ),
          SearchBar(
              showSearchIcon: true,
              iconColor: Theme.of(context).primaryColor,
              onSearchChanged: (value) {
                selectUserForGroupChatController.searchTextChanged(value);
              },
              onSearchStarted: () {
                //controller.startSearch();
              },
              onSearchCompleted: (searchTerm) {})
              .p16,
          divider(context: context).tP16,
          Expanded(
            child: GetBuilder<SelectUserForGroupChatController>(
                init: selectUserForGroupChatController,
                builder: (ctx) {
                  ScrollController scrollController = ScrollController();
                  scrollController.addListener(() {
                    if (scrollController.position.maxScrollExtent ==
                        scrollController.position.pixels) {
                      if (!selectUserForGroupChatController.isLoading) {
                        selectUserForGroupChatController.getFriends();
                      }
                    }
                  });

                  List<UserModel> usersList =
                      selectUserForGroupChatController.friends;
                  return GridView.builder(
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.8),
                    padding: const EdgeInsets.only(top: 25, left: 8, right: 8),
                    itemCount: usersList.length,
                    itemBuilder: (context, index) {
                      return SelectableUserCard(
                        model: usersList[index],
                        isSelected: selectUserForGroupChatController
                            .selectedFriends
                            .contains(usersList[index]),
                        selectionHandler: () {
                          selectUserForGroupChatController
                              .selectFriend(usersList[index]);
                        },
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
