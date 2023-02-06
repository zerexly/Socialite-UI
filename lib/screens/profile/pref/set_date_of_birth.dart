import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class SetDateOfBirth extends StatefulWidget {
  const SetDateOfBirth({Key? key}) : super(key: key);

  @override
  State<SetDateOfBirth> createState() => _SetDateOfBirthState();
}

class _SetDateOfBirthState extends State<SetDateOfBirth> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            LocalizationString.birthdayHeader,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600),
          ).paddingOnly(top: 100),
          Text(
            LocalizationString.birthdaySubHeader,
            style: Theme.of(context).textTheme.titleSmall,
          ).paddingOnly(top: 10),
          Row(
            children: [
              addTextField('Day', 'dd'),
              const SizedBox(width: 10),
              addTextField('Month', 'MM'),
              const SizedBox(width: 10),
              addTextField('Year', 'YYYY'),
            ],
          ).paddingOnly(top: 50),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    cornerRadius: 25,
                    text: LocalizationString.next,
                    onPress: () {
                      Get.to(() => const SetYourGender());
                    })),
          ).paddingOnly(top: 150),
        ],
      ).hP25,
    );
  }

  Widget addTextField(String header, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600)),
        SizedBox(
          width: 60,
          child: InputField(
            hintText: hint,
            controller: nameController,
            showBorder: true,
            borderColor: Theme.of(context).disabledColor,
            cornerRadius: 10,
          ),
        ).tP8,
      ],
    );
  }
}
