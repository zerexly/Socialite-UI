import 'package:flutter/cupertino.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../controllers/dating_controller.dart';
import '../../model/preference_model.dart';

class SetDatingPreference extends StatefulWidget {
  const SetDatingPreference({Key? key}) : super(key: key);

  @override
  State<SetDatingPreference> createState() => SetDatingPreferenceState();
}

class SetDatingPreferenceState extends State<SetDatingPreference> {
  int? selectedGender;

  SfRangeValues _valuesForAge = const SfRangeValues(16.0, 50.0);
  SfRangeValues _valuesForHeight = const SfRangeValues(165.0, 182.0);

  final DatingController datingController = Get.find();
  TextEditingController interestsController = TextEditingController();
  List<InterestModel> selectedInterests = [];

  List<String> colors = ["Black", "White", "Brown"];
  int? selectedColor;

  List<String> religions = ["Hindu", "Christian", "Muslim"];
  TextEditingController religionController = TextEditingController();

  List<String> status = ["Single", "Married", "Divorced"];
  int? selectedStatus;

  TextEditingController languageController = TextEditingController();
  List<LanguageModel> languagesList = [
    LanguageModel('Hindi', 1),
    LanguageModel('English', 2),
    LanguageModel('Arabic', 3),
    LanguageModel('Turkish', 4),
    LanguageModel('Russian', 5),
    LanguageModel('Spanish', 6),
    LanguageModel('French', 7)
  ];
  List<LanguageModel> selectedLanguages = [];

  int smoke = 0;

  TextEditingController drinkHabitController = TextEditingController();
  List<String> drinkHabitList = ['Regular', 'Planning to quit', 'Socially'];

  @override
  void initState() {
    super.initState();
    datingController.getInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          backNavigationBar(
            context: context,
            title: LocalizationString.preferences,
          ),
          divider(context: context).tP8,
          GetBuilder<DatingController>(
              init: datingController,
              builder: (ctx) {
                return Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        addHeader('Gender').paddingOnly(bottom: 8),
                        addSegmentedBar(
                            ["Male", "Female", "Other"], selectedGender,
                            (value) {
                          setState(() => selectedGender = value);
                        }),
                        addHeader('Age').paddingOnly(top: 30),
                        SfRangeSlider(
                          min: 16.0,
                          max: 100.0,
                          inactiveColor: Theme.of(context).cardColor,
                          activeColor: Theme.of(context).primaryColor,
                          showLabels: true,
                          enableTooltip: true,
                          values: _valuesForAge,
                          onChanged: (dynamic values) {
                            setState(() {
                              _valuesForAge = values;
                            });
                          },
                          tooltipTextFormatterCallback:
                              (dynamic actualValue, String formattedText) {
                            return '${actualValue.round()}';
                          },
                          labelFormatterCallback:
                              (dynamic actualValue, String formattedText) {
                            return '${actualValue.round()}Y';
                          },
                        ),
                        addHeader('Height').paddingOnly(top: 30),
                        SfRangeSlider(
                          min: 121.0,
                          max: 243.0,
                          inactiveColor: Theme.of(context).cardColor,
                          activeColor: Theme.of(context).primaryColor,
                          showLabels: true,
                          enableTooltip: true,
                          values: _valuesForHeight,
                          onChanged: (dynamic values) {
                            setState(() {
                              _valuesForHeight = values;
                            });
                          },
                          tooltipTextFormatterCallback:
                              (dynamic actualValue, String formattedText) {
                            return '${actualValue.round()}';
                          },
                          labelFormatterCallback:
                              (dynamic actualValue, String formattedText) {
                            return '${actualValue.round()} cm';
                          },
                        ),
                        addHeader('Interests').paddingOnly(top: 30, bottom: 8),
                        addInputField(
                            interestsController, () => openInterestsPopup()),
                        addHeader('Color').paddingOnly(top: 30, bottom: 8),
                        addSegmentedBar(colors, selectedColor, (sel) {
                          setState(() => selectedColor = sel);
                        }),
                        addHeader('Religion').paddingOnly(top: 30, bottom: 8),
                        addInputField(
                            religionController, () => openReligionPopup()),
                        addHeader('Status').paddingOnly(top: 30, bottom: 8),
                        addSegmentedBar(status, selectedStatus, (sel) {
                          setState(() => selectedStatus = sel);
                        }),
                        addHeader('Language').paddingOnly(top: 30, bottom: 8),
                        addInputField(
                            languageController, () => openLanguagePopup()),
                        addHeader('Do you smoke')
                            .paddingOnly(top: 30, bottom: 8),
                        addSegmentedBar(["Yes", "No"], smoke, (sel) {
                          setState(() => smoke = sel);
                        }),
                        addHeader('Drinking habit')
                            .paddingOnly(top: 30, bottom: 8),
                        addInputField(drinkHabitController,
                            () => openDrinkHabitListPopup()),
                        Center(
                          child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 50,
                              child: FilledButtonType1(
                                  cornerRadius: 25,
                                  text: LocalizationString.set,
                                  onPress: () {
                                    if (selectedGender != null) {
                                      getIt<AddPreferenceManager>()
                                          .preferenceModel
                                          ?.gender = selectedGender! + 1;
                                    }

                                    getIt<AddPreferenceManager>()
                                        .preferenceModel
                                        ?.ageFrom = _valuesForAge.start.toInt();

                                    getIt<AddPreferenceManager>()
                                        .preferenceModel
                                        ?.ageTo = _valuesForAge.end.toInt();

                                    getIt<AddPreferenceManager>()
                                        .preferenceModel
                                        ?.heightFrom = _valuesForHeight.start.toInt();

                                    getIt<AddPreferenceManager>()
                                        .preferenceModel
                                        ?.heightTo = _valuesForHeight.end.toInt();

                                    if (selectedInterests.isNotEmpty) {
                                      String result = selectedInterests
                                          .map((val) => val.id)
                                          .join(',');
                                      getIt<AddPreferenceManager>()
                                          .preferenceModel
                                          ?.interests = result;
                                    }

                                    if (selectedColor != null) {
                                      getIt<AddPreferenceManager>()
                                              .preferenceModel
                                              ?.selectedColor =
                                          colors[selectedColor!];
                                    }

                                    if (religionController.text.isNotEmpty) {
                                      getIt<AddPreferenceManager>()
                                          .preferenceModel
                                          ?.religion = religionController.text;
                                    }

                                    if (selectedStatus != null) {
                                      getIt<AddPreferenceManager>()
                                          .preferenceModel
                                          ?.status = selectedStatus! + 1;
                                    }

                                    if (selectedLanguages.isNotEmpty) {
                                      String result = selectedLanguages
                                          .map((val) => val.id)
                                          .join(',');
                                      getIt<AddPreferenceManager>()
                                          .preferenceModel
                                          ?.languages = result;
                                    }

                                    getIt<AddPreferenceManager>()
                                        .preferenceModel
                                        ?.smoke = smoke + 1;

                                    if (drinkHabitController.text.isNotEmpty) {
                                      int drink = drinkHabitList
                                          .indexOf(drinkHabitController.text);
                                      getIt<AddPreferenceManager>()
                                          .preferenceModel
                                          ?.drink = drink + 1;
                                    }
                                    datingController.setPreferencesApi();
                                  })),
                        ).paddingOnly(top: 30),
                      ]).paddingAll(20)),
                );
              }),
        ],
      ),
    );
  }

  Text addHeader(String header) {
    return Text(header,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.w500));
  }

  addSegmentedBar(
      List<String> segments, int? value, ValueChanged<int> onValueChanged) {
    return CupertinoSegmentedControl<int>(
      padding: EdgeInsets.zero,
      selectedColor: Theme.of(context).primaryColor,
      unselectedColor: Theme.of(context).backgroundColor,
      borderColor: Theme.of(context).disabledColor,
      children: addSegmentedChips(segments),
      groupValue: value,
      onValueChanged: (value) {
        onValueChanged(value);
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

  addInputField(TextEditingController controller, VoidCallback? onTap) {
    return DropdownBorderedField(
      hintText: 'Select',
      controller: controller,
      showBorder: true,
      borderColor: Theme.of(context).disabledColor,
      cornerRadius: 10,
      iconOnRightSide: true,
      icon: ThemeIcon.downArrow,
      iconColor: Theme.of(context).disabledColor,
      onTap: () => onTap!(),
    );
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
                        trailing: Icon(
                            isAdded
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Theme.of(context).iconTheme.color));
                  }).paddingOnly(top: 30);
            }));
  }

  void openReligionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(// this is new
                builder: (BuildContext context, StateSetter setState) {
              return ListView.builder(
                  itemCount: religions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    return ListTile(
                        title: Text(religions[index]),
                        onTap: () {
                          setState(() {
                            religionController.text = religions[index];
                          });
                        },
                        trailing: Icon(
                            religions[index] == religionController.text
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
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
                  itemCount: languagesList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) {
                    LanguageModel model = languagesList[index];
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
                        trailing: Icon(
                            isAdded
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Theme.of(context).iconTheme.color));
                  }).paddingOnly(top: 30);
            }));
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
                        trailing: Icon(
                            drinkHabitList[index] == drinkHabitController.text
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Theme.of(context).iconTheme.color));
                  }).paddingOnly(top: 30);
            }));
  }
}
