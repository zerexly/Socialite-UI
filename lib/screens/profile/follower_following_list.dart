import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class FollowerFollowingList extends StatefulWidget {
  final bool isFollowersList;
  final int userId;

  const FollowerFollowingList(
      {Key? key, required this.isFollowersList, required this.userId})
      : super(key: key);

  @override
  FollowerFollowingState createState() => FollowerFollowingState();
}

class FollowerFollowingState extends State<FollowerFollowingList> {
  final UserNetworkController _userNetworkController = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    _userNetworkController.clear();
    if (widget.isFollowersList == true) {
      _userNetworkController.getFollowers(widget.userId);
    } else {
      _userNetworkController.getFollowingUsers(widget.userId);
    }
  }

  @override
  void didUpdateWidget(covariant FollowerFollowingList oldWidget) {
    // TODO: implement didUpdateWidget
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userNetworkController.clear();
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
            backNavigationBar(
                context: context,
                title: widget.isFollowersList
                    ? LocalizationString.followers
                    : LocalizationString.following),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<UserNetworkController>(
                  init: _userNetworkController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (widget.isFollowersList == true) {
                          if (!_userNetworkController.isLoading.value) {
                            _userNetworkController.getFollowers(widget.userId);
                          }
                        } else {
                          if (!_userNetworkController.isLoading.value) {
                            _userNetworkController
                                .getFollowingUsers(widget.userId);
                          }
                        }
                      }
                    });

                    List<UserModel> usersList = widget.isFollowersList == true
                        ? _userNetworkController.followers
                        : _userNetworkController.following;
                    return _userNetworkController.isLoading.value
                        ? const ShimmerUsers().hP16
                        : Column(
                            children: [
                              usersList.isEmpty
                                  ? noUserFound(context)
                                  : Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 50),
                                        controller: scrollController,
                                        itemCount: usersList.length,
                                        itemBuilder: (context, index) {
                                          return UserTile(
                                            profile: usersList[index],
                                            viewCallback: () {
                                              Get.to(() => OtherUserProfile(
                                                      userId:
                                                          usersList[index].id))!
                                                  .then(
                                                      (value) => {loadData()});
                                            },
                                            followCallback: () {
                                              _userNetworkController
                                                  .followUser(usersList[index]);
                                            },
                                            unFollowCallback: () {
                                              _userNetworkController
                                                  .unFollowUser(
                                                      usersList[index]);
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
        ));
  }
}
