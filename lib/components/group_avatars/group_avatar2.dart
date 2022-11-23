import 'package:foap/helper/common_import.dart';

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
      // width: 250,
      height: 270,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CachedNetworkImage(
  imageUrl:
              club.image!,
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
                        text: club.isJoined == 1
                            ? LocalizationString.leaveClub
                            : LocalizationString.join,
                        onPress: () {
                          if (club.isJoined == 1) {
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
