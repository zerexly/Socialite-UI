import 'package:foap/helper/common_import.dart';

class CallHistoryTile extends StatelessWidget {
  final CallHistoryModel model;

  const CallHistoryTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatarView(size: 45, user: model.opponent),
        // AvatarView(size: 45, url: model.opponent.picture,name: model.opponent.userName,),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.opponent.userName,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                ThemeIconWidget(
                  model.callType == 1
                      ? ThemeIcon.mobile
                      : ThemeIcon.videoCamera,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  model.isMissedCall
                      ? LocalizationString.missed
                      : model.isOutgoing
                          ? LocalizationString.outgoing
                          : LocalizationString.incoming,
                  style: model.isMissedCall
                      ? Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).errorColor)
                      : Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            )
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              model.timeOfCall,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const ThemeIconWidget(
                  ThemeIcon.clock,
                  size: 12,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  model.duration,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
        // const SizedBox(
        //   width: 5,
        // ),
        // const ThemeIconWidget(
        //   ThemeIcon.info,
        //   size: 20,
        // ),
      ],
    );
  }
}
