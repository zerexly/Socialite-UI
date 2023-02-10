import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';

class SetDateOfBirth extends StatefulWidget {
  const SetDateOfBirth({Key? key}) : super(key: key);

  @override
  State<SetDateOfBirth> createState() => _SetDateOfBirthState();
}

class _SetDateOfBirthState extends State<SetDateOfBirth> {
  final DatingController datingController = Get.find();
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!isLoginFirstTime && getIt<UserProfileManager>().user?.dob != null) {
      String dob = getIt<UserProfileManager>().user?.dob ?? '';
      var arr = dob.split('-');
      year.text = arr[0];
      month.text = arr[1];
      day.text = arr[2];
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
              title: LocalizationString.birthdayMainHeader,
              completion: () {
                Get.to(() => const SetYourGender());
              }),
          divider(context: context).tP8,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                LocalizationString.birthdayHeader,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ).paddingOnly(top: 20),
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
                        text: LocalizationString.send,
                        onPress: () {
                          if (year.text != '' &&
                              month.text != '' &&
                              day.text != '') {
                            AddDatingDataModel dataModel = AddDatingDataModel();
                            dataModel.dob =
                                "${year.text}-${month.text}-${day.text}";
                            getIt<UserProfileManager>().user?.dob =
                                dataModel.dob;
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
                            Get.to(() => const SetYourGender());
                          }
                        })),
              ).paddingOnly(top: 150),
            ],
          ).hP25,
        ]));
  }

  Widget addTextField(
      String header, String hint, TextEditingController controller) {
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
