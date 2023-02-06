import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import 'add_profesional_details.dart';

class AddInterests extends StatefulWidget {
  const AddInterests({Key? key}) : super(key: key);

  @override
  State<AddInterests> createState() => AddInterestsState();
}

class AddInterestsState extends State<AddInterests> {
  int smoke = 0;

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
              LocalizationString.addInterestsHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            Text(
              LocalizationString.addInterestsSubHeader,
              style: Theme.of(context).textTheme.titleSmall,
            ).paddingOnly(top: 20),
            addHeader('Do you smoke?').paddingOnly(top: 30, bottom: 8),
            addSegmentedBar(["Yes", "No"]),
            addHeader('Drinking habit').paddingOnly(top: 30, bottom: 8),
            InputField(
              hintText: 'Select',
              // controller: _requestVerificationController
              //     .messageTf.value,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              isDisabled: true,
            ),
            addHeader('Interests').paddingOnly(top: 30, bottom: 8),
            InputField(
              hintText: 'Select',
              // controller: _requestVerificationController
              //     .messageTf.value,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              isDisabled: true,
            ),
            addHeader('Language').paddingOnly(top: 30, bottom: 8),
            InputField(
              hintText: 'Select',
              // controller: _requestVerificationController
              //     .messageTf.value,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              isDisabled: true,
            ),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        Get.to(() => const AddProfessionalDetails());
                      })),
            ).paddingOnly(top: 100),
          ],
        ).paddingAll(25),
      ),
    );
  }

  Text addHeader(String header) {
    return Text(
      header,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w500),
    );
  }

  addSegmentedBar(List<String> segments) {
    return CupertinoSegmentedControl<int>(
      padding: EdgeInsets.zero,
      selectedColor: Theme.of(context).primaryColor,
      unselectedColor: Theme.of(context).backgroundColor,
      borderColor: Theme.of(context).disabledColor,
      children: addSegmentedChips(segments),
      groupValue: smoke,
      onValueChanged: (value) {
        setState(() => smoke = value);
      },
    );
  }

  addSegmentedChips(List<String> segments) {
    Map<int, Widget> hashmap = {};
    for (int i = 0; i < segments.length; i++) {
      hashmap[i] = SizedBox(
          width: (MediaQuery.of(context).size.width - 40) / segments.length,
          height: 36,
          child: Text(
            segments[i],
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w300),
          ).alignCenter);
    }
    return hashmap;
  }
}
