import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ClubSettings extends StatefulWidget {
  final ClubModel club;
  final Function(ClubModel) deleteClubCallback;

  // final Function(ClubModel) updateClubCallback;
  const ClubSettings({
    Key? key,
    required this.club,
    required this.deleteClubCallback,
    // required this.updateClubCallback
  }) : super(key: key);

  @override
  State<ClubSettings> createState() => _ClubSettingsState();
}

class _ClubSettingsState extends State<ClubSettings> {
  final ClubsController _clubsController = Get.find();

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
              context: context, title: LocalizationString.clubSettings),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 25),
              children: [
                Row(
                  children: [
                    Text(
                      LocalizationString.editClubInfo,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    const ThemeIconWidget(
                      ThemeIcon.nextArrow,
                      size: 20,
                    )
                  ],
                ).ripple(() {
                  Get.to(() => CreateClub(
                        club: widget.club,
                        // submittedCallback: (club) {
                        //   widget.updateClubCallback(club!);
                        //   Get.back();
                        // },
                      ));
                }),
                divider(context: context).vP16,
                Row(
                  children: [
                    Text(
                      LocalizationString.editClubImage,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    const ThemeIconWidget(
                      ThemeIcon.nextArrow,
                      size: 20,
                    )
                  ],
                ).ripple(() {
                  Get.to(() => ChooseClubCoverPhoto(
                        club: widget.club,
                        // submittedCallback: (club) {
                        //   widget.updateClubCallback(club!);
                        //   Get.back();
                        // },
                      ));
                }),
                divider(context: context).vP16,
                Row(
                  children: [
                    Text(
                      LocalizationString.deleteClub,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).errorColor),
                    ),
                  ],
                ).ripple(() {
                  AppUtil.showConfirmationAlert(
                      title: LocalizationString.deleteClub,
                      subTitle: LocalizationString.areYouSureToDeleteClub,
                      cxt: context,
                      okHandler: () {
                        _clubsController.deleteClub(
                            club: widget.club,
                            callback: () {
                              widget.deleteClubCallback(widget.club);
                            });
                      });
                }),
                divider(context: context).vP16,
              ],
            ).hP16,
          )
        ],
      ),
    );
  }
}
