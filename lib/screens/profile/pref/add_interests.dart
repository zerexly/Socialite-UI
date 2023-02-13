import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../components/segmented_control.dart';
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
  List<String> drinkHabitList = DatingProfileConstants.drinkHabits;

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

    if (!isLoginFirstTime) {
      if (getIt<UserProfileManager>().user?.smoke != null) {
        smoke = (getIt<UserProfileManager>().user?.smoke ?? 1) - 1;
      }
      if (getIt<UserProfileManager>().user?.drink != null) {
        int drink =
            int.parse(getIt<UserProfileManager>().user?.drink ?? '1') - 1;
        drinkHabitController.text = drinkHabitList[drink];
      }
      if (getIt<UserProfileManager>().user?.interests != null) {
        selectedInterests = getIt<UserProfileManager>().user!.interests!;
        String result = selectedInterests.map((val) => val.name).join(', ');
        interestsController.text = result;
      }
      if (getIt<UserProfileManager>().user?.languages != null) {
        selectedLanguages = getIt<UserProfileManager>().user!.languages!;
        String result = selectedLanguages.map((val) => val.name).join(', ');
        languageController.text = result;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(children: [
          const SizedBox(height: 50),
          profileScreensNavigationBar(
              context: context,
              rightBtnTitle: isLoginFirstTime ? LocalizationString.skip : null,
              title: LocalizationString.addInterestsHeader,
              completion: () {
                Get.to(() => const AddProfessionalDetails());
              }),
          divider(context: context).tP8,
          Expanded(
              child: SingleChildScrollView(
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
                ).setPadding(top: 20),
                Text(
                  LocalizationString.addInterestsSubHeader,
                  style: Theme.of(context).textTheme.titleSmall,
                ).setPadding(top: 20),
                addHeader('Do you smoke?').setPadding(top: 30, bottom: 8),
                SegmentedControl(
                    segments: [LocalizationString.yes, LocalizationString.no],
                    value: smoke,
                    onValueChanged: (value) {
                      setState(() => smoke = value);
                    }),
                addHeader(LocalizationString.drinkingHabit).setPadding(top: 30, bottom: 8),
                DropdownBorderedField(
                  hintText: LocalizationString.select,
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
                addHeader(LocalizationString.interests).setPadding(top: 30, bottom: 8),
                DropdownBorderedField(
                  hintText: LocalizationString.select,
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
                addHeader(LocalizationString.language).setPadding(top: 30, bottom: 8),
                DropdownBorderedField(
                  hintText: LocalizationString.select,
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
                          text: LocalizationString.send,
                          onPress: () {
                            AddDatingDataModel dataModel = AddDatingDataModel();
                            dataModel.smoke = smoke + 1;
                            getIt<UserProfileManager>().user?.smoke =
                                dataModel.smoke;

                            if (drinkHabitController.text.isNotEmpty) {
                              int drink = drinkHabitList
                                  .indexOf(drinkHabitController.text);
                              dataModel.drink = drink + 1;
                              getIt<UserProfileManager>().user?.drink =
                                  dataModel.drink.toString();
                            }
                            if (selectedInterests.isNotEmpty) {
                              dataModel.interests = selectedInterests;
                              getIt<UserProfileManager>().user?.interests =
                                  selectedInterests;
                            }
                            if (selectedLanguages.isNotEmpty) {
                              dataModel.languages = selectedLanguages;
                              getIt<UserProfileManager>().user?.languages =
                                  selectedLanguages;
                            }
                            datingController.updateDatingProfile(dataModel,
                                (msg) {
                              if (msg != '' &&
                                  !isLoginFirstTime) {
                                AppUtil.showToast(
                                    context: context,
                                    message: msg,
                                    isSuccess: true);
                              }
                            });
                            if (isLoginFirstTime) {
                              Get.to(() => const AddProfessionalDetails());
                            }
                          })),
                ).setPadding(top: 100),
              ],
            ).paddingAll(25),
          )),
        ]));
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

  void openDrinkHabitListPopup() {
    Get.bottomSheet(Container(
            color: Theme.of(context).cardColor.darken(0.07),
            child: ListView.builder(
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
                          color: Theme.of(context).iconTheme.color));
                }).p16)
        .topRounded(40));
  }

  void openInterestsPopup() {
    Get.bottomSheet(Container(
            color: Theme.of(context).cardColor.darken(0.07),
            child: ListView.builder(
                itemCount: datingController.interests.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, int index) {
                  InterestModel model = datingController.interests.value[index];
                  var anySelection = selectedInterests
                      .where((element) => element.id == model.id);
                  bool isAdded = anySelection.isNotEmpty;

                  return ListTile(
                      title: Text(model.name),
                      onTap: () {
                        isAdded
                            ? selectedInterests.remove(model)
                            : selectedInterests.add(model);

                        String result =
                            selectedInterests.map((val) => val.name).join(', ');
                        interestsController.text = result;
                        setState(() {});
                      },
                      trailing: ThemeIconWidget(
                          isAdded
                              ? ThemeIcon.selectedCheckbox
                              : ThemeIcon.emptyCheckbox,
                          color: Theme.of(context).iconTheme.color));
                }).p16)
        .topRounded(40));
  }

  void openLanguagePopup() {
    Get.bottomSheet(Container(
            color: Theme.of(context).cardColor.darken(0.07),
            child: ListView.builder(
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

                        String result =
                            selectedLanguages.map((val) => val.name).join(', ');
                        languageController.text = result;
                        setState(() {});
                      },
                      trailing: ThemeIconWidget(
                          isAdded
                              ? ThemeIcon.selectedCheckbox
                              : ThemeIcon.emptyCheckbox,
                          color: Theme.of(context).iconTheme.color));
                }).p16)
        .topRounded(40));
  }
}
