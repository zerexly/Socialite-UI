import 'package:foap/helper/common_import.dart';

Widget divider({double? height, Color? color, required BuildContext context}) {
  return Container(
    height: height ?? 0.1,
    color: color ?? Theme.of(context).dividerColor,
  );
}