import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  late String token;

  final LoginController controller = Get.find();

  @override
  void initState() {
    super.initState();
    token = widget.token;
  }

  @override
  void dispose() {
    controller.passwordReset = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 120,
              ),
              // Center(
              //     child: Image.asset(
              //   'assets/logo.png',
              //   width: 80,
              //   height: 25,
              // )),

              Text(
                LocalizationString.resetPwd,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Theme.of(context).primaryColor)
                    .copyWith(fontWeight: FontWeight.w900),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 40,
              ),
              // Text(
              //   LocalizationString.helpToGetAccount,
              //   style: Theme.of(context)
              //       .textTheme
              //       .headlineSmall!
              //       .copyWith(fontWeight: FontWeight.w600),
              //   textAlign: TextAlign.start,
              // ).setPadding(top: 10, bottom: 80),
              addTextField(newPassword, LocalizationString.newPassword),
              addTextField(confirmPassword, LocalizationString.confirmPassword)
                  .tP25,
              const Spacer(),
              addSubmitBtn(),
              const SizedBox(
                height: 55,
              )
            ]).setPadding(left: 25, right: 25),
            GetBuilder<LoginController>(
                init: controller,
                builder: (ctx) {
                  return controller.passwordReset == true
                      ? Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: PasswordChangedPopup(dismissHandler: () {
                            controller.passwordReset = false;
                            getIt<UserProfileManager>().logout();
                          }))
                      : Container();
                })
          ],
        ),
      ),
    );
  }

  Widget addTextField(TextEditingController controller, String hint) {
    return SizedBox(
      height: 48,
      child: PasswordField(
        onChanged: (value) {},
        controller: controller,
        showRevealPasswordIcon: true,
        hintText: hint,
      ),
    ).vP8.borderWithRadius(
          context: context,
          value: 1,
          radius: 5,
          color: Theme.of(context).dividerColor,
        );
  }

  addSubmitBtn() {
    return FilledButtonType1(
      onPress: () {
        controller.resetPassword(
          context: context,
          newPassword: newPassword.text.trim(),
          confirmPassword: confirmPassword.text.trim(),
          token: token,
        );
      },
      text: LocalizationString.changePwd,
      enabledTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900)
          .copyWith(color: Colors.white70),
      isEnabled: true,
    );
  }
}
