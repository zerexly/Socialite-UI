import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../model/preference_model.dart';

class SetYourGender extends StatefulWidget {
  const SetYourGender({Key? key}) : super(key: key);

  @override
  State<SetYourGender> createState() => _SetYourGenderState();
}

class _SetYourGenderState extends State<SetYourGender> {
  List<String> genders = ['Male', 'Female', 'Other'];
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
              LocalizationString.genderHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            ListView.builder(
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, int index) => addOption(index).paddingOnly(top: 15),
            ).paddingOnly(top: 35),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        if (selectedGender != null) {
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.gender = selectedGender! + 1;
                        }
                        Get.to(() => const ChooseWhomToDate());
                      })),
            ).paddingOnly(top: 150),
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
          selectedGender == index
              ? const Icon(Icons.circle_rounded)
              : const Icon(Icons.circle_outlined),
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
