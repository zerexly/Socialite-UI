import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

Widget noUserFound(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Lottie.asset(
        'assets/lottie/no_record.json',
        height: 200,
        // width: 200,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        LocalizationString.noUserFound,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(fontWeight: FontWeight.w600),
      )
    ],
  );
}

Widget emptyPost(
    {required String title,
    required String subTitle,
    required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(
        'assets/lottie/no_record.json',
        height: 200,
        // width: 200,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}

Widget emptyUser(
    {required String title,
    required String subTitle,
    required BuildContext context}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(
        'assets/lottie/no_record.json',
        height: 200,
        // width: 200,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subTitle,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  );
}

Widget emptyData({required String title, required String subTitle}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(
        'assets/lottie/no_record.json',
        height: 200,
        // width: 200,
      ),
      const SizedBox(
        height: 20,
      ),
      Text(
        title,
        style: Theme.of(Get.context!)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.w900),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        subTitle,
        style: Theme.of(Get.context!).textTheme.bodyLarge,
      ),
    ],
  );
}
