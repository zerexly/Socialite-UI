import 'package:flutter/material.dart';
import 'package:foap/helper/extension.dart';
import 'package:foap/screens/profile/pref/set_your_gender.dart';
import 'package:get/get.dart';

import '../../../helper/localization_strings.dart';
import '../../../manager/service_locator.dart';
import '../../../model/preference_model.dart';
import '../../../universal_components/app_buttons.dart';
import '../../../universal_components/rounded_input_field.dart';

class SetDateOfBirth extends StatefulWidget {
  const SetDateOfBirth({Key? key}) : super(key: key);

  @override
  State<SetDateOfBirth> createState() => _SetDateOfBirthState();
}

class _SetDateOfBirthState extends State<SetDateOfBirth> {
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

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
              addTextField('Day', 'dd', day),
              const SizedBox(width: 10),
              addTextField('Month', 'MM', month),
              const SizedBox(width: 10),
              addTextField('Year', 'YYYY', year),
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
                      if (year.text != '' && month.text != '' && day.text != '') {
                        getIt<AddPreferenceManager>().preferenceModel?.dob = "${year.text}-${month.text}-${day.text}";
                      }
                      Get.to(() => const SetYourGender());
                    })),
          ).paddingOnly(top: 150),
        ],
      ).hP25,
    );
  }

  Widget addTextField(String header, String hint, TextEditingController controller) {
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
            controller: controller,
            showBorder: true,
            borderColor: Theme.of(context).disabledColor,
            cornerRadius: 10,
          ),
        ).tP8,
      ],
    );
  }
}
