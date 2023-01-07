import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SelectUserToGiftEventTicket extends StatefulWidget {
  final EventModel event;
  final bool isAlreadyBooked;
  final Function(UserModel)? selectUserCallback;

  const SelectUserToGiftEventTicket(
      {Key? key,
      required this.event,
      required this.isAlreadyBooked,
      this.selectUserCallback})
      : super(key: key);

  @override
  SelectUserToGiftEventTicketState createState() =>
      SelectUserToGiftEventTicketState();
}

class SelectUserToGiftEventTicketState
    extends State<SelectUserToGiftEventTicket> {
  final UserNetworkController _userNetworkController = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    _userNetworkController.clear();
    _userNetworkController
        .getFollowingUsers(getIt<UserProfileManager>().user!.id);
  }

  @override
  void didUpdateWidget(covariant SelectUserToGiftEventTicket oldWidget) {
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
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
              height: 25,
            ),
            backNavigationBar(
                context: context, title: LocalizationString.selectUser),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<UserNetworkController>(
                  init: _userNetworkController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!_userNetworkController.isLoading.value) {
                          _userNetworkController.getFollowingUsers(
                              getIt<UserProfileManager>().user!.id);
                        }
                      }
                    });

                    List<UserModel> usersList =
                        _userNetworkController.following;
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
                                                if (widget.isAlreadyBooked) {
                                                  widget.selectUserCallback!(
                                                      usersList[index]);
                                                  Get.back();
                                                } else {
                                                  Get.to(() => BuyTicket(
                                                        event: widget.event,
                                                        giftToUser:
                                                            usersList[index],
                                                      ));
                                                }
                                              });
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
