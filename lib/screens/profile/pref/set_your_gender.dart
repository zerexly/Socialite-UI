import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';
import 'add_personal_info.dart';

class SetYourGender extends StatefulWidget {
  const SetYourGender({Key? key}) : super(key: key);

  @override
  State<SetYourGender> createState() => _SetYourGenderState();
}

class _SetYourGenderState extends State<SetYourGender> {
  final DatingController datingController = Get.find();
  List<String> genders = DatingProfileConstants.genders;
  int? selectedGender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!isLoginFirstTime && getIt<UserProfileManager>().user?.gender != null) {
      selectedGender = int.parse(getIt<UserProfileManager>().user?.gender ?? '1') - 1;
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
              title: LocalizationString.genderMainHeader,
              completion: () {
                Get.to(() => const AddPersonalInfo());
              }),
          divider(context: context).tP8,
        Expanded(
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  LocalizationString.genderHeader,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ).setPadding(top: 20),
                ListView.builder(
                  itemCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (_, int index) =>
                      addOption(index).setPadding(top: 15),
                ).setPadding(top: 35),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      child: FilledButtonType1(
                          cornerRadius: 25,
                          text: LocalizationString.send,
                          onPress: () {
                            if (selectedGender != null) {
                              AddDatingDataModel dataModel =
                                  AddDatingDataModel();
                              dataModel.gender = selectedGender! + 1;
                              getIt<UserProfileManager>().user?.gender =
                                  dataModel.gender.toString();

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
                            }
                            if (isLoginFirstTime) {
                              Get.to(() => const AddPersonalInfo());
                            }
                          })),
                ).setPadding(top: 150),
              ],
            ).hP25,
          )),
        ]));
  }

  Widget addOption(int index) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(genders[index],
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
          ThemeIconWidget(
              selectedGender == index
                  ? ThemeIcon.circle
                  : ThemeIcon.circleOutline,
              color: Theme.of(context).iconTheme.color)
        ],
      ).hP25.ripple(() {
        setState(() {
          selectedGender = index;
        });
      }),
    ).borderWithRadius(
        context: context,
        color: Theme.of(context).disabledColor,
        radius: 15,
        value: 1);
  }
}
