import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';

class AddProfessionalDetails extends StatefulWidget {
  const AddProfessionalDetails({Key? key}) : super(key: key);

  @override
  State<AddProfessionalDetails> createState() => AddProfessionalDetailsState();
}

class AddProfessionalDetailsState extends State<AddProfessionalDetails> {
  TextEditingController qualificationController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController industryController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  final DatingController datingController = Get.find();

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
              LocalizationString.addProfessionalHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            addHeader('Qualification').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                controller: qualificationController,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            addHeader('Occupation').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                controller: occupationController,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            addHeader('Work industry').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                controller: industryController,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            addHeader('Work experience').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                controller: experienceController,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.send,
                      onPress: () {
                        if (qualificationController.text.isNotEmpty) {
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.qualification = qualificationController.text;
                        }

                        if (occupationController.text.isNotEmpty) {
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.occupation = occupationController.text;
                        }

                        if (industryController.text.isNotEmpty) {
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.industry = industryController.text;
                        }

                        if (experienceController.text.isNotEmpty) {
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.experience = experienceController.text;
                        }
                        //Hit Api
                        datingController.updateDatingProfile();
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
}