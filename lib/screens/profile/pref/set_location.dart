import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import 'package:geocoding/geocoding.dart';

import '../../../controllers/dating_controller.dart';
import '../../../model/preference_model.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({Key? key}) : super(key: key);

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  final DatingController datingController = Get.find();

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
              title: LocalizationString.locationMainHeader,
              completion: () {
                Get.to(() => const AddName());
              }),
          divider(context: context).tP8,
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  color: Theme.of(context).cardColor,
                  child: ThemeIconWidget(ThemeIcon.location,
                      size: 20, color: Theme.of(context).primaryColor),
                ).round(30).tP25,
                Text(
                  LocalizationString.locationHeader,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ).setPadding(top: 40),
                Text(
                  LocalizationString.locationSubHeader,
                  style: Theme.of(context).textTheme.titleSmall,
                ).setPadding(top: 20),
                Center(
                  child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 50,
                      child: FilledButtonType1(
                          cornerRadius: 25,
                          text: LocalizationString.locationService,
                          onPress: () {
                            LocationManager().getLocation((location) async {
                              try {
                                AddDatingDataModel dataModel =
                                    AddDatingDataModel();
                                dataModel.latitude =
                                    location.latitude.toString();
                                dataModel.longitude =
                                    location.longitude.toString();
                                getIt<UserProfileManager>().user?.latitude = location.latitude.toString();
                                getIt<UserProfileManager>().user?.longitude = location.longitude.toString();
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
                              } catch (err) {}
                            });

                            if (isLoginFirstTime) {
                              Get.to(() => const AddName());
                            }
                          })),
                ).setPadding(top: 150),
              ]).hP25,
        ],
      ),
    );
  }
}
