import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ClubJoinRequests extends StatefulWidget {
  final ClubModel club;

  const ClubJoinRequests({Key? key, required this.club}) : super(key: key);

  @override
  ClubJoinRequestsState createState() => ClubJoinRequestsState();
}

class ClubJoinRequestsState extends State<ClubJoinRequests> {
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
          backNavigationBar(
              context: context, title: LocalizationString.joinRequests),
          divider(context: context).tP8,
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
                  return ListView.separated(
                      padding:
                          const EdgeInsets.only(top: 25, left: 16, right: 16),
                      itemCount: usersList.length,
                      itemBuilder: (context, index) {
                        return ClubJoinRequestTile(
                          profile: usersList[index],
                          viewCallback: () {
                            Get.to(() =>
                                OtherUserProfile(userId: usersList[index].id));
                          },
                          acceptBtnClicked: () {},
                          declineBtnClicked: () {},
                        );
                      },
                      separatorBuilder: (context, index) {
                        return divider(context: context).vP16;
                      });
                }),
          ),
        ],
      ),
    );
  }
}
