import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class SetYourGender extends StatefulWidget {
  const SetYourGender({Key? key}) : super(key: key);

  @override
  State<SetYourGender> createState() => _SetYourGenderState();
}

class _SetYourGenderState extends State<SetYourGender> {
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
            Text(LocalizationString.genderHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            addOption('Male').paddingOnly(top: 50),
            addOption('Female').paddingOnly(top: 10),
            addOption('Other').paddingOnly(top: 10),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        Get.to(() => const ChooseWhomToDate());
                      })),
            ).paddingOnly(top: 150),
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
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.white)),
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
