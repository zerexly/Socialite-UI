import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import '../../controllers/clubs/invite_friends_to_club_controller.dart';

class InviteUsersToClub extends StatefulWidget {
  final int clubId;

  const InviteUsersToClub({Key? key, required this.clubId}) : super(key: key);

  @override
  InviteUsersToClubState createState() => InviteUsersToClubState();
}

class InviteUsersToClubState extends State<InviteUsersToClub> {
  final InviteFriendsToClubController _inviteFriendsToClubController =
      InviteFriendsToClubController();

  @override
  void initState() {
    _inviteFriendsToClubController.getFollowingUsers();
    super.initState();
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
          SizedBox(
            height: 50,
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
                      LocalizationString.invite,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ).ripple(() {
                      _inviteFriendsToClubController
                          .sendClubJoinInvite(widget.clubId);
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
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Obx(() => _inviteFriendsToClubController
                              .selectedFriends.isNotEmpty
                          ? Text(
                              '${_inviteFriendsToClubController.selectedFriends.length} ${LocalizationString.friendsSelected}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.w500),
                            )
                          : Container())
                    ],
                  ),
                )
              ],
            ),
          ).hP16,
          divider(context: context).tP8,
          GetBuilder<InviteFriendsToClubController>(
            init: _inviteFriendsToClubController,
            builder: (ctx) {
              List<UserModel> usersList =
                  _inviteFriendsToClubController.selectedFriends;
              return usersList.isNotEmpty
                  ? SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(
                            top: 20, left: 16, right: 16, bottom: 10),
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Column(
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
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  ],
                                ),
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
                                  _inviteFriendsToClubController
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
                    _inviteFriendsToClubController.searchTextChanged(value);
                  },
                  onSearchStarted: () {
                    //controller.startSearch();
                  },
                  onSearchCompleted: (searchTerm) {})
              .p16,
          divider(context: context).tP16,
          Expanded(
            child: GetBuilder<InviteFriendsToClubController>(
                init: _inviteFriendsToClubController,
                builder: (ctx) {
                  ScrollController scrollController = ScrollController();
                  scrollController.addListener(() {
                    if (scrollController.position.maxScrollExtent ==
                        scrollController.position.pixels) {
                      if (!_inviteFriendsToClubController.isLoading.value) {
                        _inviteFriendsToClubController.getFollowingUsers();
                      }
                    }
                  });

                  List<UserModel> usersList =
                      _inviteFriendsToClubController.following;
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
                        isSelected: _inviteFriendsToClubController
                            .selectedFriends
                            .contains(usersList[index]),
                        selectionHandler: () {
                          _inviteFriendsToClubController
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
