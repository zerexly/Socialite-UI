import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // const SizedBox(
            //   height: 70,
            // ),
            // const ThemeIconWidget(
            //   ThemeIcon.backArrow,
            //   size: 25,
            // ).ripple(() {
            //   Get.back();
            // }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Text(
              LocalizationString.forgotPwd,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).primaryColor)
                  .copyWith(fontWeight: FontWeight.w900),
              textAlign: TextAlign.start,
            ),
            Text(
              LocalizationString.helpToGetAccount,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ).setPadding(top: 10, bottom: 80),
            addTextField(),

            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                LocalizationString.loginAnotherAccount,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ).ripple(() {
                Get.back();
              }),
            ),
            const Spacer(),
            addSubmitBtn(),
            const SizedBox(
              height: 55,
            )
          ]),
        ).setPadding(left: 20, right: 20));
  }

  addTextField() {
    return InputField(
      showDivider: true,
      cornerRadius: 5,
      controller: email,
      hintText: LocalizationString.enterEmail,
    );
  }

  addSubmitBtn() {
    return FilledButtonType1(
      onPress: () {
        loginController.forgotPassword(email: email.text, context: context);
      },
      text: LocalizationString.sendOTP,
      enabledTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
      isEnabled: true,
    ).setPadding(top: 25);
  }
}
