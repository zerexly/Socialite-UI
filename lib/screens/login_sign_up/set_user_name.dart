import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SetUserName extends StatefulWidget {
  const SetUserName({Key? key}) : super(key: key);

  @override
  State<SetUserName> createState() => _SetUserNameState();
}

class _SetUserNameState extends State<SetUserName> {
  TextEditingController userName = TextEditingController();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
    userName.text = getIt<UserProfileManager>().user!.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocalizationString.setUserName,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 20,
          ),
          Text(LocalizationString.setUserNameSubHeading,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              InputField(
                controller: userName,
                showDivider: true,
                textStyle: Theme.of(context).textTheme.titleMedium,
                onChanged: (value) {
                  if (value.length > 3) {
                    profileController.verifyUsername(userName: value);
                  }
                },
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Center(
                  child:
                      Obx(() => profileController.userNameCheckStatus.value == 1
                          ? ThemeIconWidget(
                              ThemeIcon.checkMark,
                              color: Theme.of(context).primaryColor,
                            )
                          : profileController.userNameCheckStatus.value == 0
                              ? ThemeIconWidget(
                                  ThemeIcon.close,
                                  color: Theme.of(context).errorColor,
                                )
                              : Container()),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          FilledButtonType1(
              text: LocalizationString.submit,
              onPress: () {
                profileController.updateUserName(
                    userName: userName.text,
                    isSigningUp: true,
                    context: context);
              })
        ],
      ).hP16,
    );
  }
}
