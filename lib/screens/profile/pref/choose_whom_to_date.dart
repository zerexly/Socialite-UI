import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../model/preference_model.dart';
import 'add_personal_info.dart';

class ChooseWhomToDate extends StatefulWidget {
  const ChooseWhomToDate({Key? key}) : super(key: key);

  @override
  State<ChooseWhomToDate> createState() => _ChooseWhomToDateState();
}

class _ChooseWhomToDateState extends State<ChooseWhomToDate> {
  List<String> genders = ['Open to all', 'Male', 'Female'];
  int? selectedGender;

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
            ListView.builder(
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, int index) =>
                  addOption(index).paddingOnly(top: 15),
            ).paddingOnly(top: 30),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        Get.to(() => const AddPersonalInfo());
                      })),
            ).paddingOnly(top: 100),
          ],
        ).hP25,
      ),
    );
  }

  Widget addOption(int index) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(genders[index],
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
          ThemeIconWidget(
              selectedGender == index
                  ? ThemeIcon.circle
                  : ThemeIcon.circleOutline,
              color: Theme.of(context).iconTheme.color),
        ],
      ).hP25.ripple(() {
        setState(() {
          selectedGender = index;
        });
      }),
    ).borderWithRadius(
        context: context,
        color: Theme.of(context).disabledColor,
        radius: 15,
        value: 1);
  }
}
