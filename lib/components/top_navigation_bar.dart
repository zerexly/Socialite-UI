import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

Widget backNavigationBar(BuildContext context, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ThemeIconWidget(
        ThemeIcon.backArrow,
        size: 20,
        color: Theme.of(context).iconTheme.color,
      ).ripple(() {
        Get.back();
      }),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      const SizedBox(
        width: 20,
      )
    ],
  ).setPadding(left: 16, right: 16, top: 8, bottom: 16);
}

Widget profileScreensNavigationBar(
    {required BuildContext context,
    required String title,
    required VoidCallback completion}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ThemeIconWidget(
        ThemeIcon.backArrow,
        size: 20,
        color: Theme.of(context).iconTheme.color,
      ).ripple(() {
        Get.back();
      }),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      Text(
        LocalizationString.done,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ).ripple(() {
        completion();
      }),
    ],
  ).setPadding(left: 16, right: 16, top: 8, bottom: 16);
}

Widget titleNavigationBarWithIcon(
    {required BuildContext context,
    required String title,
    required ThemeIcon icon,
    required VoidCallback completion}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const SizedBox(
        width: 25,
      ),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      ThemeIconWidget(
        icon,
        color: Theme.of(context).iconTheme.color,
        size: 25,
      ).ripple(() {
        completion();
      }),
    ],
  ).setPadding(left: 16, right: 16, top: 8, bottom: 16);
}

Widget titleNavigationBar({
  required BuildContext context,
  required String title,
}) {
  return Text(
    title,
    style: Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.w600),
  ).setPadding(left: 16, right: 16, top: 8, bottom: 16);
}
