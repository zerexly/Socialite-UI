import 'package:foap/helper/common_import.dart';

class CallHistoryTile extends StatelessWidget {
  final CallHistoryModel model;

  const CallHistoryTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarView(size: 50, url: model.opponent.picture),
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
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w900),
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
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).errorColor)
                      : Theme.of(context).textTheme.bodyLarge,
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
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const ThemeIconWidget(
                  ThemeIcon.clock,
                  size: 15,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  model.duration,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
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
