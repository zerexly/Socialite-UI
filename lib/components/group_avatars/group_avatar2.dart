import 'package:flutter/material.dart';
import '../../helper/localization_strings.dart';
import '../../model/club_invitation.dart';
import '../../model/club_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:foap/helper/extension.dart';
import 'package:foap/helper/number_extension.dart';
import '../../universal_components/app_buttons.dart';
import 'package:get/get.dart';

class ClubCard extends StatelessWidget {
  final ClubModel club;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const ClubCard(
      {Key? key,
      required this.club,
      required this.joinBtnClicked,
      required this.leaveBtnClicked,
      required this.previewBtnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: club.image!,
              fit: BoxFit.cover,
            ).topRounded(10).ripple(() {
              previewBtnClicked();
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            club.name!,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w900),
          ).p8,
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${club.totalMembers!.formatNumber} ${LocalizationString.clubMembers}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              if (!club.createdByUser!.isMe)
                SizedBox(
                    height: 40,
                    width: 120,
                    child: FilledButtonType1(
                        text: club.isJoined == true
                            ? LocalizationString.leaveClub
                            : club.isRequested == true
                                ? LocalizationString.requested
                                : club.isRequestBased == true
                                    ? LocalizationString.requestJoin
                                    : LocalizationString.join,
                        onPress: () {
                          if (club.isJoined == true) {
                            leaveBtnClicked();
                          } else {
                            joinBtnClicked();
                          }
                        })),
              // SizedBox(
              //     height: 40,
              //     width: 120,
              //     child: FilledButtonType1(
              //         text: LocalizationString.preview,
              //         onPress: () {
              //           previewBtnClicked();
              //         }))
            ],
          ).setPadding(left: 12, right: 12, bottom: 20)
        ],
      ),
    ).round(15);
  }
}

class ClubInvitationCard extends StatelessWidget {
  final ClubInvitation invitation;
  final VoidCallback acceptBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback declineBtnClicked;

  const ClubInvitationCard(
      {Key? key,
      required this.invitation,
      required this.acceptBtnClicked,
      required this.declineBtnClicked,
      required this.previewBtnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 250,
      height: 300,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: invitation.club!.image!,
              fit: BoxFit.cover,
            ).topRounded(10).ripple(() {
              previewBtnClicked();
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                invitation.club!.name!,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ).vP8,
              Text(
                '${invitation.club!.totalMembers!.formatNumber} ${LocalizationString.clubMembers}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButtonType1(
                          width: Get.width * 0.4,
                          text: LocalizationString.accept,
                          onPress: () {
                            acceptBtnClicked();
                          }),
                      BorderButtonType1(
                          width: Get.width * 0.4,
                          text: LocalizationString.decline,
                          onPress: () {
                            declineBtnClicked();
                          })
                    ],
                  )).vP16,
            ],
          ).hP16,
        ],
      ),
    ).round(15);
  }
}
