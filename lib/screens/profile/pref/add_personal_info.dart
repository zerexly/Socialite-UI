import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import '../../../components/segmented_control.dart';
import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';
import 'add_interests.dart';

class AddPersonalInfo extends StatefulWidget {
  const AddPersonalInfo({Key? key}) : super(key: key);

  @override
  State<AddPersonalInfo> createState() => AddPersonalInfoState();
}

class AddPersonalInfoState extends State<AddPersonalInfo> {
  final DatingController datingController = Get.find();
  List<String> colors = ["Black", "White", "Brown"];
  int? selectedColor;

  double _valueForHeight = 176.0;

  List<String> religions = ["Hindu", "Christian", "Muslim"];
  TextEditingController religionController = TextEditingController();

  List<String> status = ["Single", "Married", "Divorced"];
  int? selectedStatus;

  @override
  void initState() {
    super.initState();
    if (!isLoginFirstTime) {
      if (getIt<UserProfileManager>().user?.name != null) {
        int index =
            colors.indexOf(getIt<UserProfileManager>().user?.color ?? '');
        selectedColor = index != -1 ? index : null;
      }
      if (getIt<UserProfileManager>().user?.height != null) {
        _valueForHeight =
            double.parse(getIt<UserProfileManager>().user?.height ?? '');
      }
      if (getIt<UserProfileManager>().user?.religion != null) {
        religionController.text =
            getIt<UserProfileManager>().user?.religion ?? '';
      }
      if (getIt<UserProfileManager>().user?.maritalStatus != null) {
        selectedStatus = (getIt<UserProfileManager>().user?.maritalStatus ?? 1) - 1;
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
              title: LocalizationString.personalDetails,
              completion: () {
                Get.to(() => const AddInterests());
              }),
          divider(context: context).tP8,
          Expanded(
            child: SingleChildScrollView(
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
                  ).paddingOnly(top: 20),
                  Text(
                    LocalizationString.personalInfoSubHeader,
                    style: Theme.of(context).textTheme.titleSmall,
                  ).paddingOnly(top: 20),
                  addHeader('Color').paddingOnly(top: 30, bottom: 8),
                  SegmentedControl(
                      segments: colors,
                      value: selectedColor,
                      onValueChanged: (value) {
                        setState(() => selectedColor = value);
                      }),
                  addHeader('Height (cm)').paddingOnly(top: 30),
                  Slider(
                    min: 121.0,
                    max: 243.0,
                    value: _valueForHeight,
                    inactiveColor: Theme.of(context).cardColor,
                    activeColor: Theme.of(context).primaryColor,
                    label: '${_valueForHeight.round()}',
                    divisions: 243,
                    onChanged: (dynamic value) {
                      setState(() {
                        _valueForHeight = value;
                      });
                    },
                  ),
                  addHeader('Religion').paddingOnly(top: 15, bottom: 8),
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
                  SegmentedControl(
                      segments: status,
                      value: selectedStatus,
                      onValueChanged: (value) {
                        setState(() => selectedStatus = value);
                      }),
                  Center(
                    child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 50,
                        child: FilledButtonType1(
                            cornerRadius: 25,
                            text: LocalizationString.send,
                            onPress: () {
                              AddDatingDataModel dataModel =
                                  AddDatingDataModel();

                              if (selectedColor != null) {
                                dataModel.selectedColor =
                                    colors[selectedColor!];
                                getIt<UserProfileManager>().user?.color = dataModel.selectedColor;
                              }

                              dataModel.height = _valueForHeight.toInt();
                              getIt<UserProfileManager>().user?.height = dataModel.height.toString();

                              if (religionController.text.isNotEmpty) {
                                dataModel.religion = religionController.text;
                                getIt<UserProfileManager>().user?.religion = religionController.text;
                              }

                              if (selectedStatus != null) {
                                dataModel.status = selectedStatus! + 1;
                                getIt<UserProfileManager>().user?.maritalStatus = dataModel.status;
                              }
                              datingController.updateDatingProfile(dataModel,
                                  (msg) {
                                if (msg != null &&
                                    msg != '' &&
                                    !isLoginFirstTime) {
                                  AppUtil.showToast(
                                      context: context,
                                      message: msg,
                                      isSuccess: true);
                                }
                              });
                              if (isLoginFirstTime) {
                                Get.to(() => const AddInterests());
                              }
                            })),
                  ).paddingOnly(top: 100),
                ],
              ).paddingAll(25),
            ),
          ),
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
