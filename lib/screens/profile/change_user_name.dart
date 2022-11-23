import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChangeUserName extends StatefulWidget {
  const ChangeUserName({Key? key}) : super(key: key);

  @override
  State<ChangeUserName> createState() => _ChangeUserNameState();
}

class _ChangeUserNameState extends State<ChangeUserName> {
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
        children: [
          const SizedBox(
            height: 50,
          ),
          profileScreensNavigationBar(
              context: context,
              title: LocalizationString.changeUserName,
              completion: () {
                profileController.updateUserName(
                    userName: userName.text, context: context);
              }),
          divider(context: context).vP8,
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocalizationString.userName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600)),
              Stack(
                children: [
                  InputField(
                    controller: userName,
                    showDivider: true,
                    textStyle: Theme.of(context)
                        .textTheme
                        .titleMedium,
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
                      child: Obx(() =>
                          profileController.userNameCheckStatus.value == true
                              ? ThemeIconWidget(
                                  ThemeIcon.checkMark,
                                  color: Theme.of(context).primaryColor,
                                )
                              : ThemeIconWidget(
                                  ThemeIcon.close,
                                  color: Theme.of(context).errorColor,
                                )),
                    ),
                  ),
                ],
              ).vP8,
              const SizedBox(
                height: 20,
              ),
            ],
          ).hP16,
        ],
      ),
    );
  }
}
