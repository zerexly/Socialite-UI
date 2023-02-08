import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';
import 'add_profesional_details.dart';

class AddInterests extends StatefulWidget {
  const AddInterests({Key? key}) : super(key: key);

  @override
  State<AddInterests> createState() => AddInterestsState();
}

class AddInterestsState extends State<AddInterests> {
  int smoke = 0;

  TextEditingController drinkHabitController = TextEditingController();
  List<String> drinkHabitList = ['Regular', 'Planning to quit', 'Socially'];

  final DatingController datingController = Get.find();
  TextEditingController interestsController = TextEditingController();
  List<InterestModel> selectedInterests = [];

  TextEditingController languageController = TextEditingController();
  List<LanguageModel> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    datingController.getInterests();
    datingController.getLanguages();
  }

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
            DropdownBorderedField(
              hintText: 'Select',
              controller: drinkHabitController,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              onTap: () {
                openDrinkHabitListPopup();
              },
            ),
            addHeader('Interests').paddingOnly(top: 30, bottom: 8),
            DropdownBorderedField(
              hintText: 'Select',
              controller: interestsController,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              onTap: () {
                openInterestsPopup();
              },
            ),
            addHeader('Language').paddingOnly(top: 30, bottom: 8),
            DropdownBorderedField(
              hintText: 'Select',
              controller: languageController,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              onTap: () {
                openLanguagePopup();
              },
            ),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        getIt<AddPreferenceManager>().preferenceModel?.smoke =
                            smoke + 1;

                        if (drinkHabitController.text.isNotEmpty) {
                          int drink =
                              drinkHabitList.indexOf(drinkHabitController.text);
                          getIt<AddPreferenceManager>().preferenceModel?.drink =
                              drink + 1;
                        }

                        if (selectedInterests.isNotEmpty) {
                          String result =
                              selectedInterests.map((val) => val.id).join(',');
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.interests = result;
                        }

                        if (selectedLanguages.isNotEmpty) {
                          String result =
                              selectedLanguages.map((val) => val.id).join(',');
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.languages = result;
                        }

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

  void openDrinkHabitListPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(// this is new
                builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                  itemCount: drinkHabitList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    return ListTile(
                        title: Text(drinkHabitList[index]),
                        onTap: () {
                          setState(() {
                            drinkHabitController.text = drinkHabitList[index];
                          });
                        },
                        trailing: ThemeIconWidget(
                            drinkHabitList[index] == drinkHabitController.text
                                ? ThemeIcon.selectedCheckbox
                                : ThemeIcon.emptyCheckbox,
                            color: Theme.of(context).iconTheme.color)
                        // Icon(
                        //     drinkHabitList[index] == drinkHabitController.text
                        //         ? Icons.check_box
                        //         : Icons.check_box_outline_blank,
                        //     color: Theme.of(context).iconTheme.color)
                        );
                  }).paddingOnly(top: 30);
            }));
  }

  void openInterestsPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(// this is new
                builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                  itemCount: datingController.interests.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    InterestModel model =
                        datingController.interests.value[index];
                    var anySelection = selectedInterests
                        .where((element) => element.id == model.id);
                    bool isAdded = anySelection.isNotEmpty;

                    return ListTile(
                        title: Text(model.name),
                        onTap: () {
                          isAdded
                              ? selectedInterests.remove(model)
                              : selectedInterests.add(model);

                          String result = selectedInterests
                              .map((val) => val.name)
                              .join(', ');
                          interestsController.text = result;
                          setState(() {});
                        },
                        trailing: ThemeIconWidget(
                            isAdded
                                ? ThemeIcon.selectedCheckbox
                                : ThemeIcon.emptyCheckbox,
                            color: Theme.of(context).iconTheme.color));
                  }).paddingOnly(top: 30);
            }));
  }

  void openLanguagePopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(// this is new
                builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                  itemCount: datingController.languages.value.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    LanguageModel model = datingController.languages.value[index];
                    var anySelection = selectedLanguages
                        .where((element) => element.id == model.id);
                    bool isAdded = anySelection.isNotEmpty;

                    return ListTile(
                        title: Text(model.name ?? ''),
                        onTap: () {
                          isAdded
                              ? selectedLanguages.remove(model)
                              : selectedLanguages.add(model);

                          String result = selectedLanguages
                              .map((val) => val.name)
                              .join(', ');
                          languageController.text = result;
                          setState(() {});
                        },
                        trailing: ThemeIconWidget(
                            isAdded
                                ? ThemeIcon.selectedCheckbox
                                : ThemeIcon.emptyCheckbox,
                            color: Theme.of(context).iconTheme.color));
                  }).paddingOnly(top: 30);
            }));
  }
}
