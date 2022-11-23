import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class BlockedUsersList extends StatefulWidget {
  const BlockedUsersList({Key? key}) : super(key: key);

  @override
  BlockedUsersListState createState() => BlockedUsersListState();
}

class BlockedUsersListState extends State<BlockedUsersList> {
  final BlockedUsersController blockedUsersController = Get.find();

  @override
  void initState() {
    blockedUsersController.getBlockedUsers();
    super.initState();
  }

  @override
  void dispose() {
    blockedUsersController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          backNavigationBar(context:context, title:LocalizationString.blockedUser),
          divider(context: context).vP8,
          Expanded(
            child: GetBuilder<BlockedUsersController>(
                init: blockedUsersController,
                builder: (ctx) {
                  ScrollController scrollController = ScrollController();
                  scrollController.addListener(() {
                    if (scrollController.position.maxScrollExtent ==
                        scrollController.position.pixels) {
                      if (!blockedUsersController.isLoading) {
                        blockedUsersController.getBlockedUsers();
                      }
                    }
                  });

                  return blockedUsersController.isLoading
                      ? const ShimmerUsers().hP16
                      : Column(
                          mainAxisAlignment:
                              blockedUsersController.usersList.isEmpty &&
                                      blockedUsersController.isLoading == false
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.start,
                          children: [
                            blockedUsersController.usersList.isEmpty
                                ? blockedUsersController.isLoading == false
                                    ? noUserFound(context)
                                    : Container()
                                : Expanded(
                                    child: ListView.separated(
                                      padding: const EdgeInsets.only(top: 20),
                                      controller: scrollController,
                                      itemCount: blockedUsersController
                                          .usersList.length,
                                      itemBuilder: (context, index) {
                                        return BlockedUserTile(
                                          profile: blockedUsersController
                                              .usersList[index],
                                          unBlockCallback: () {
                                            blockedUsersController.unBlockUser(
                                                blockedUsersController
                                                    .usersList[index].id);
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 20,
                                        );
                                      },
                                    ).hP16,
                                  ),
                          ],
                        );
                }),
          ),
        ],
      ),
    );
  }
}
