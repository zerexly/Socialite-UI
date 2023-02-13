import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';

class AddName extends StatefulWidget {
  const AddName({Key? key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  final DatingController datingController = Get.find();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!isLoginFirstTime && getIt<UserProfileManager>().user?.name != null) {
      nameController.text = getIt<UserProfileManager>().user?.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 50),
          profileScreensNavigationBar(
              context: context,
              rightBtnTitle: isLoginFirstTime ? LocalizationString.skip : null,
              title: LocalizationString.nameMainHeader,
              completion: () {
                Get.to(() => const SetDateOfBirth());
              }),
          divider(context: context).tP8,
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  LocalizationString.nameHeader,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ).setPadding(top: 100),
                Text(
                  LocalizationString.nameSubHeader,
                  style: Theme.of(context).textTheme.titleSmall,
                ).setPadding(top: 20),
                InputField(
                  hintText: 'e.g Alex',
                  controller: nameController,
                  showBorder: true,
                  borderColor: Theme.of(context).disabledColor,
                  cornerRadius: 10,
                ).setPadding(top: 20),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      child: FilledButtonType1(
                          cornerRadius: 25,
                          text: LocalizationString.send,
                          onPress: () {
                            if (nameController.text != '') {
                              AddDatingDataModel dataModel =
                                  AddDatingDataModel();
                              dataModel.name = nameController.text;
                              getIt<UserProfileManager>().user?.name =
                                  dataModel.name;
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
                            }
                            if (isLoginFirstTime) {
                              Get.to(() => const SetDateOfBirth());
                            }
                          })),
                ).setPadding(top: 150),
              ]).hP25
        ],
      ),
    );
  }
}
