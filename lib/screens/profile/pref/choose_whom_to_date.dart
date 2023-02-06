import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import 'add_personal_info.dart';

class ChooseWhomToDate extends StatefulWidget {
  const ChooseWhomToDate({Key? key}) : super(key: key);

  @override
  State<ChooseWhomToDate> createState() => _ChooseWhomToDateState();
}

class _ChooseWhomToDateState extends State<ChooseWhomToDate> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              LocalizationString.likeToDateHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            Text(
              LocalizationString.likeToDateSubHeader,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 20),
            addOption('Open to all').paddingOnly(top: 50),
            addOption('Male').paddingOnly(top: 10),
            addOption('Female').paddingOnly(top: 10),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        Get.to(() => const AddPersonalInfo());
                        // Get.to(() => const ChooseGoal());
                      })),
            ).paddingOnly(top: 110),
          ],
        ).hP25,
      ),
    );
  }

  Widget addOption(String option) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(option,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
          const Icon(Icons.circle_outlined),
        ],
      ).hP25,
    ).borderWithRadius(
        context: context,
        color: Theme.of(context).disabledColor,
        radius: 15,
        value: 1);
  }
}