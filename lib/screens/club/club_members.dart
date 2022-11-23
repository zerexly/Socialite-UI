import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ClubMembers extends StatefulWidget {
  final ClubModel club;

  const ClubMembers({Key? key, required this.club}) : super(key: key);

  @override
  ClubMembersState createState() => ClubMembersState();
}

class ClubMembersState extends State<ClubMembers> {
  final ClubsController _clubsController = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    _clubsController.getMembers(clubId: widget.club.id);
  }

  @override
  void didUpdateWidget(covariant ClubMembers oldWidget) {
    loadData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _clubsController.clearMembers();
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
                context: context, title: LocalizationString.clubMembers),
            divider(context: context).tP8,
            Expanded(
              child: GetBuilder<ClubsController>(
                  init: _clubsController,
                  builder: (ctx) {
                    ScrollController scrollController = ScrollController();
                    scrollController.addListener(() {
                      if (scrollController.position.maxScrollExtent ==
                          scrollController.position.pixels) {
                        if (!_clubsController.isLoadingMembers) {
                          _clubsController.getMembers(clubId: widget.club.id!);
                        }
                      }
                    });

                    List<ClubMemberModel> membersList = _clubsController.members;
                    return _clubsController.isLoadingMembers
                        ? const ShimmerUsers().hP16
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              membersList.isEmpty
                                  ? noUserFound(context)
                                  : Expanded(
                                      child: ListView.separated(
                                        padding: const EdgeInsets.only(
                                            top: 20, bottom: 50),
                                        controller: scrollController,
                                        itemCount: membersList.length,
                                        itemBuilder: (context, index) {
                                          return widget.club.amIAdmin
                                              ? ClubMemberTile(
                                                  member: membersList[index],
                                                  viewCallback: () {
                                                    Get.to(() => OtherUserProfile(
                                                            userId:
                                                                membersList[index]
                                                                    .id))!
                                                        .then((value) =>
                                                            {loadData()});
                                                  },
                                                  removeBtnCallback: () {
                                                    removeMemberBtnClicked(
                                                        membersList[index]);
                                                  },
                                                )
                                              : ClubMemberTile(
                                                  member: membersList[index],
                                                  viewCallback: () {
                                                    Get.to(() => OtherUserProfile(
                                                            userId:
                                                                membersList[index]
                                                                    .id))!
                                                        .then((value) =>
                                                            {loadData()});
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

  removeMemberBtnClicked(ClubMemberModel member) {
    _clubsController.removeMemberFromClub(widget.club, member);
  }
}
