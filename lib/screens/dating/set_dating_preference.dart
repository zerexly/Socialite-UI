import 'package:flutter/cupertino.dart';
import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../controllers/dating_controller.dart';

class SetDatingPreference extends StatefulWidget {
  const SetDatingPreference({Key? key}) : super(key: key);

  @override
  State<SetDatingPreference> createState() => SetDatingPreferenceState();
}

class SetDatingPreferenceState extends State<SetDatingPreference> {
  PreferenceModel? model;
  SfRangeValues _values = const SfRangeValues(16.0, 50.0);
  SfRangeValues _valuesForHeight = const SfRangeValues(165.0, 182.0);
  final DatingController datingController = Get.find();

  @override
  void initState() {
    super.initState();
    model = PreferenceModel();
    model?.gender = 0;
    model?.ageFrom = 16.0;
    model?.ageTo = 50.0;

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
                        addSegmentedBar(["Male", "Female", "Other"]),
                        addHeader('Age').paddingOnly(top: 30),
                        SfRangeSlider(
                          min: 16.0,
                          max: 100.0,
                          inactiveColor: Theme.of(context).cardColor,
                          activeColor: Theme.of(context).primaryColor,
                          showLabels: true,
                          enableTooltip: true,
                          values: _values,
                          onChanged: (dynamic values) {
                            setState(() {
                              _values = values;
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
                        addHeader('Color').paddingOnly(top: 30, bottom: 8),
                        addSegmentedBar(["Black", "White", "Brown"]),
                        addHeader('Religion').paddingOnly(top: 30, bottom: 8),
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
                        addHeader('Status').paddingOnly(top: 30, bottom: 8),
                        addSegmentedBar(["Married", "Divorced", "Single"]),
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
                        addHeader('Do you smoke')
                            .paddingOnly(top: 30, bottom: 8),
                        addSegmentedBar(["Yes", "No"]),
                        addHeader('Drinking habit')
                            .paddingOnly(top: 30, bottom: 8),
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
                        )
                      ]).paddingAll(20)),
                );
              }),
        ],
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
      groupValue: model?.gender,
      onValueChanged: (value) {
        setState(() => model?.gender = value);
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

class PreferenceModel {
  late int gender;
  late double ageFrom;
  late double ageTo;
}
