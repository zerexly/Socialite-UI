import 'package:foap/helper/common_import.dart';

Widget noUserFound(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        'assets/nouser.png',
        height: 200,
        width: 200,
      ),
      const SizedBox(
        height: 50,
      ),
      Text(
        LocalizationString.noUserFound,
        style: Theme.of(context).textTheme.displaySmall!
            .copyWith(fontWeight: FontWeight.w900),
      )
    ],
  );
}
