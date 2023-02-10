import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/dating_controller.dart';

class MatchedList extends StatefulWidget {
  const MatchedList({Key? key}) : super(key: key);

  @override
  State<MatchedList> createState() => MatchedListState();
}

class MatchedListState extends State<MatchedList> {
  final DatingController datingController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();

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
                        ? const ShimmerMatchedList()
                        : datingController.matchedUsers.isEmpty
                            ? emptyData(
                                title:
                                    LocalizationString.noMatchedProfilesFound,
                                subTitle:
                                    LocalizationString.datingExploreForMatched,
                                context: context)
                            : GridView.builder(
                                itemCount: datingController.matchedUsers.length,
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 30, right: 30),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15.0,
                                        mainAxisSpacing: 15.0,
                                        mainAxisExtent: 210),
                                itemBuilder: (ctx, index) {
                                  return matchedGrid(index);
                                });
                  })),
        ],
      ),
    );
  }

  Widget matchedGrid(int index) {
    UserModel profile = datingController.matchedUsers[index];
    String? yearStr;
    if (profile.dob != null && profile.dob != '') {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(profile.dob!);
      Duration diff = DateTime.now().difference(birthDate);
      int years = diff.inDays ~/ 365;
      yearStr = years.toString();
    }

    return Stack(children: [
      Container(
              height: double.infinity,
              width: double.infinity,
              foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                    stops: [0.0, 1.0]),
              ),
              child: profile.picture != null
                  ? CachedNetworkImage(
                      imageUrl: profile.picture!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SizedBox(
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator().p16),
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          profile.getInitials,
                          style: TextStyle(
                              fontSize: profile.getInitials.length == 1
                                  ? (60 / 2)
                                  : (60 / 3),
                              fontWeight: FontWeight.w600),
                        ).bP16,
                      ),
                    )
                  : Center(
                      child: Text(
                        profile.getInitials,
                        style: TextStyle(
                            fontSize: profile.getInitials.length == 1
                                ? (60 / 2)
                                : (60 / 3),
                            fontWeight: FontWeight.w600),
                      ).bP16,
                    ))
          .borderWithRadius(
              context: context,
              value: 1,
              radius: 10,
              color: Theme.of(context).primaryColor)
          .ripple(() {
        Get.to(() => OtherUserProfile(userId: profile.id));
      }),
      Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (profile.name == null ? profile.userName : profile.name ?? '') +
                    (yearStr != null ? ', $yearStr' : ''),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ).paddingOnly(left: 15, bottom: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                    child: Container(
                  height: 40,
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                      child: ThemeIconWidget(
                    ThemeIcon.close,
                    size: 18,
                    color: Colors.white,
                  )),
                ).rp(1).leftRounded(10).ripple(() {
                  datingController.likeUnlikeProfile(
                      DatingActions.undoLiked, profile.id.toString());
                  setState(() {
                    datingController.matchedUsers.removeAt(index);
                  });
                })),
                Flexible(
                    child: Container(
                  height: 40,
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                      child: ThemeIconWidget(
                    ThemeIcon.chatBordered,
                    size: 18,
                    color: Colors.white,
                  )),
                ).lp(1).rightRounded(10).ripple(() {
                  EasyLoading.show(status: LocalizationString.loading);
                  _chatDetailController.getChatRoomWithUser(
                      userId: profile.id,
                      callback: (room) {
                        EasyLoading.dismiss();
                        Get.to(() => ChatDetail(
                              chatRoom: room,
                            ));
                      });
                }))
              ]).paddingOnly(left: 4, right: 4, bottom: 4)
            ]),
      ))
    ]);
  }

  Widget userPictureView(UserModel user, double size) {
    return user.picture != null
        ? CachedNetworkImage(
            imageUrl: user.picture!,
            fit: BoxFit.cover,
            height: size,
            width: size,
            placeholder: (context, url) => SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator().p16),
            errorWidget: (context, url, error) => SizedBox(
                height: size,
                width: size,
                child: Icon(
                  Icons.error,
                  size: size / 2,
                )),
          ).borderWithRadius(
            context: context,
            value: 1,
            radius: size / 3,
            color: Theme.of(context).primaryColor)
        : SizedBox(
            height: size,
            width: size,
            child: Center(
              child: Text(
                user.getInitials,
                style: TextStyle(
                    fontSize:
                        user.getInitials.length == 1 ? (size / 2) : (size / 3),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ).borderWithRadius(
            context: context,
            value: 1,
            radius: size / 3,
            color: Theme.of(context).primaryColor);
  }
}
