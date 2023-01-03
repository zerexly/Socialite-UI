import 'package:foap/helper/common_import.dart';

class NotificationTileType4 extends StatelessWidget {
  final NotificationModel notification;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;
  final TextStyle? dateTextStyle;
  final Color? borderColor;

  const NotificationTileType4(
      {Key? key,
      required this.notification,
      this.backgroundColor,
      this.titleTextStyle,
      this.subTitleTextStyle,
      this.dateTextStyle,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(notification.title,
                  style: subTitleTextStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w700)),
            ),
            Text(notification.notificationTime(),
                style: dateTextStyle ?? Theme.of(context).textTheme.bodySmall),
          ],
        ).bP8,
        Text(notification.message,
            style: titleTextStyle ?? Theme.of(context).textTheme.bodyMedium),
      ],
    ).setPadding(top: 16, bottom: 16, left: 8, right: 8).shadowWithBorder(
        context: context,
        borderWidth: 0.2,
        shadowOpacity: 0.5,
        borderColor: borderColor,
        radius: 10,
        fillColor: backgroundColor ?? Theme.of(context).backgroundColor);
  }
}
