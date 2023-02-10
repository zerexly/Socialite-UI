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
  TextEditingController experienceMonthController = TextEditingController();
  TextEditingController experienceYearController = TextEditingController();
  final DatingController datingController = Get.find();

  @override
  void initState() {
    super.initState();
    if (!isLoginFirstTime) {
      if (getIt<UserProfileManager>().user?.qualification != null) {
        qualificationController.text =
            getIt<UserProfileManager>().user?.qualification ?? '';
      }
      if (getIt<UserProfileManager>().user?.occupation != null) {
        occupationController.text =
            getIt<UserProfileManager>().user?.occupation ?? '';
      }
      if (getIt<UserProfileManager>().user?.experienceMonth != null) {
        experienceMonthController.text =
            getIt<UserProfileManager>().user!.experienceMonth!.toString();
      }
      if (getIt<UserProfileManager>().user?.experienceYear != null) {
        experienceYearController.text =
            getIt<UserProfileManager>().user!.experienceYear!.toString();
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
              title: LocalizationString.professional,
              completion: () {
                isLoginFirstTime = false;
                Get.offAll(() => const DashboardScreen());
                getIt<SocketManager>().connect();
              }),
          divider(context: context).tP8,
          Expanded(
              child: SingleChildScrollView(
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
                ).paddingOnly(top: 20),
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
                addHeader('Work experience').paddingOnly(top: 30, bottom: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: InputField(
                                hintText: 'Month',
                                controller: experienceMonthController,
                                showBorder: true,
                                borderColor: Theme.of(context).disabledColor,
                                cornerRadius: 10)
                            .rp(4),
                      ),
                      Flexible(
                        child: InputField(
                                hintText: 'Year',
                                controller: experienceYearController,
                                showBorder: true,
                                borderColor: Theme.of(context).disabledColor,
                                cornerRadius: 10)
                            .lp(4),
                      ),
                    ]),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      child: FilledButtonType1(
                          cornerRadius: 25,
                          text: LocalizationString.send,
                          onPress: () {
                            AddDatingDataModel dataModel = AddDatingDataModel();
                            if (qualificationController.text.isNotEmpty) {
                              dataModel.qualification =
                                  qualificationController.text;
                              getIt<UserProfileManager>().user?.qualification =
                                  dataModel.qualification;
                            }
                            if (occupationController.text.isNotEmpty) {
                              dataModel.occupation = occupationController.text;
                              getIt<UserProfileManager>().user?.occupation =
                                  dataModel.occupation;
                            }
                            if (experienceMonthController.text.isNotEmpty) {
                              dataModel.experienceMonth =
                                  experienceMonthController.text;
                              getIt<UserProfileManager>()
                                      .user
                                      ?.experienceMonth =
                                  int.parse(dataModel.experienceMonth ?? '0');
                            }
                            if (experienceYearController.text.isNotEmpty) {
                              dataModel.experienceYear =
                                  experienceYearController.text;
                              getIt<UserProfileManager>().user?.experienceYear =
                                  int.parse(dataModel.experienceYear ?? '0');
                            }

                            if (qualificationController.text.isNotEmpty ||
                                occupationController.text.isNotEmpty ||
                                experienceMonthController.text.isNotEmpty ||
                                experienceYearController.text.isNotEmpty) {
                              datingController.updateDatingProfile(dataModel,
                                  (msg) {
                                if (msg != '' && !isLoginFirstTime) {
                                  AppUtil.showToast(
                                      context: context,
                                      message: msg,
                                      isSuccess: true);
                                }
                              });
                            }
                            if (isLoginFirstTime) {
                              isLoginFirstTime = false;
                              Get.offAll(() => const DashboardScreen());
                              getIt<SocketManager>().connect();
                            }
                          })),
                ).paddingOnly(top: 50),
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
}
