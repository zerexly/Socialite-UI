import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 55,
          ),
          profileScreensNavigationBar(
              context: context,
              title: LocalizationString.changePwd,
              completion: () {
                profileController.resetPassword(
                    oldPassword: oldPassword.text,
                    newPassword: newPassword.text,
                    confirmPassword: confirmPassword.text,
                    context: context);
              }),
          divider(context: context).vP8,
          const SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocalizationString.oldPwdStr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
              addTextField(oldPassword, 'old_password').tP8,
              Text(LocalizationString.newPwdStr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
              addTextField(newPassword, 'new_password').tP8,
              Text(LocalizationString.confirmPwdStr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600))
                  .vP8,
              addTextField(confirmPassword, 'confirm_password'),
            ],
          ).hP16
        ]),
      ),
    );
  }

  Widget addTextField(TextEditingController controller, String hint) {
    return SizedBox(
      height: 50,
      child: PasswordField(
        textStyle: Theme.of(context).textTheme.titleSmall,
        onChanged: (value) {},
        controller: controller,
        showRevealPasswordIcon: true,
        showDivider: true,
        hintText: '********',
      ),
    ).vP8;
  }


}
