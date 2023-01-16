import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

import '../../model/club_join_request.dart';

class ClubJoinRequests extends StatefulWidget {
  final ClubModel club;

  const ClubJoinRequests({Key? key, required this.club}) : super(key: key);

  @override
  ClubJoinRequestsState createState() => ClubJoinRequestsState();
}

class ClubJoinRequestsState extends State<ClubJoinRequests> {
  final ClubDetailController _clubDetailController = Get.find();

  @override
  void initState() {
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
            child: GetBuilder<ClubDetailController>(
                init: _clubDetailController,
                builder: (ctx) {
                  ScrollController scrollController = ScrollController();
                  scrollController.addListener(() {
                    if (scrollController.position.maxScrollExtent ==
                        scrollController.position.pixels) {
                      if (!_clubDetailController.isLoading.value) {
                        _clubDetailController.getClubJoinRequests(
                            clubId: widget.club.id!);
                      }
                    }
                  });

                  List<ClubJoinRequest> requestsList =
                      _clubDetailController.joinRequests;
                  return ListView.separated(
                      padding: const EdgeInsets.only(
                          top: 25, left: 16, right: 16, bottom: 100),
                      itemCount: requestsList.length,
                      itemBuilder: (context, index) {
                        return ClubJoinRequestTile(
                          request: requestsList[index],
                          viewCallback: () {
                            Get.to(() => OtherUserProfile(
                                userId: requestsList[index].user!.id));
                          },
                          acceptBtnClicked: () {
                            _clubDetailController
                                .acceptClubJoinRequest(requestsList[index]);
                          },
                          declineBtnClicked: () {
                            _clubDetailController
                                .declineClubJoinRequest(requestsList[index]);
                          },
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
