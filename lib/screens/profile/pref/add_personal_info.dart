import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../../model/preference_model.dart';
import 'add_interests.dart';

class AddPersonalInfo extends StatefulWidget {
  const AddPersonalInfo({Key? key}) : super(key: key);

  @override
  State<AddPersonalInfo> createState() => AddPersonalInfoState();
}

class AddPersonalInfoState extends State<AddPersonalInfo> {
  List<String> colors = ["Black", "White", "Brown"];
  int? selectedColor;

  SfRangeValues _valuesForHeight = const SfRangeValues(165.0, 182.0);

  List<String> religions = ["Hindu", "Christian", "Muslim"];
  TextEditingController religionController = TextEditingController();

  List<String> status = ["Single", "Married", "Divorced"];
  int? selectedStatus;

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
              LocalizationString.personalInfoHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 80),
            Text(
              LocalizationString.personalInfoSubHeader,
              style: Theme.of(context).textTheme.titleSmall,
            ).paddingOnly(top: 20),
            addHeader('Color').paddingOnly(top: 30, bottom: 8),
            addSegmentedBar(colors, selectedColor, (sel) {
              setState(() => selectedColor = sel);
            }),
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
            addHeader('Religion').paddingOnly(top: 30, bottom: 8),
            DropdownBorderedField(
              hintText: 'Select',
              controller: religionController,
              showBorder: true,
              borderColor: Theme.of(context).disabledColor,
              cornerRadius: 10,
              iconOnRightSide: true,
              icon: ThemeIcon.downArrow,
              iconColor: Theme.of(context).disabledColor,
              onTap: () {
                openReligionPopup();
              },
            ),
            addHeader('Status').paddingOnly(top: 30, bottom: 8),
            addSegmentedBar(status, selectedStatus, (sel) {
              setState(() => selectedStatus = sel);
            }),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.next,
                      onPress: () {
                        if (selectedColor != null) {
                          getIt<AddPreferenceManager>()
                              .preferenceModel
                              ?.selectedColor = colors[selectedColor!];
                        }

                        getIt<AddPreferenceManager>().preferenceModel?.height =
                            _valuesForHeight.end.toInt();

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

                        Get.to(() => const AddInterests());
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

  addSegmentedBar(
      List<String> segments, int? selection, ValueChanged<int> onValueChanged) {
    return CupertinoSegmentedControl<int>(
      padding: EdgeInsets.zero,
      selectedColor: Theme.of(context).primaryColor,
      unselectedColor: Theme.of(context).backgroundColor,
      borderColor: Theme.of(context).disabledColor,
      children: addSegmentedChips(segments),
      groupValue: selection ?? 0,
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
                        trailing: ThemeIconWidget(
                            religions[index] == religionController.text
                                ? ThemeIcon.selectedCheckbox
                                : ThemeIcon.emptyCheckbox,
                            color: Theme.of(context).iconTheme.color));
                  }).paddingOnly(top: 30);
            }));
  }
}
