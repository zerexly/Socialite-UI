import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/dating_controller.dart';

class LikeList extends StatefulWidget {
  const LikeList({Key? key}) : super(key: key);

  @override
  State<LikeList> createState() => LikeListState();
}

class LikeListState extends State<LikeList> {
  final DatingController datingController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();

  @override
  void initState() {
    super.initState();
    datingController.getLikeProfilesApi();
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
            title: LocalizationString.likedBy,
          ),
          divider(context: context).tP8,
          Expanded(
              child: GetBuilder<DatingController>(
                  init: datingController,
                  builder: (ctx) {
                    return datingController.isLoading.value
                        ? const ShimmerLikeList()
                        : datingController.likeUsers.isEmpty
                            ? emptyData(
                                title: LocalizationString.noLikeProfilesFound,
                                subTitle: LocalizationString.noLikeProfiles,
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                shrinkWrap: true,
                                itemCount: datingController.likeUsers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return matchedTile(index);
                                });
                  })),
        ],
      ),
    );
  }

  Widget matchedTile(int index) {
    UserModel profile = datingController.likeUsers[index];

    String? yearStr;
    if (profile.dob != null && profile.dob != '') {
      DateTime birthDate = DateFormat("yyyy-MM-dd").parse(profile.dob!);
      Duration diff = DateTime.now().difference(birthDate);
      int years = diff.inDays ~/ 365;
      yearStr = years.toString();
    }

    return Container(
            color: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    userPictureView(
                      profile,
                      50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (profile.name == null
                                    ? profile.userName
                                    : profile.name ?? '') +
                                (yearStr != null ? ', $yearStr' : ''),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w900),
                          ).bP4,
                          Text(
                            profile.genderType == GenderType.female
                                ? LocalizationString.female
                                : profile.genderType == GenderType.other
                                    ? LocalizationString.other
                                    : LocalizationString.male,
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ).hP16,
                    ),
                    // const Spacer(),
                  ],
                ).ripple(() {
                  Get.to(() => OtherUserProfile(userId: profile.id));
                }),
                const Spacer(),
                BorderButtonType1(
                    height: 30,
                    borderColor: Theme.of(context).primaryColor,
                    text: LocalizationString.likeBack,
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w600)
                        .copyWith(color: Theme.of(context).primaryColor),
                    onPress: () {
                      datingController.likeUnlikeProfile(
                          DatingActions.liked, profile.id.toString());
                      EasyLoading.show(status: LocalizationString.loading);
                      _chatDetailController.getChatRoomWithUser(
                          userId: profile.id,
                          callback: (room) {
                            EasyLoading.dismiss();
                            Get.to(() => ChatDetail(
                                  chatRoom: room,
                                ));
                            setState(() {
                              datingController.likeUsers.removeAt(index);
                            });
                          });
                    })
              ],
            ).paddingSymmetric(horizontal: 15, vertical: 20))
        .round(10)
        .setPadding(bottom: 15, left: 15, right: 15);
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
