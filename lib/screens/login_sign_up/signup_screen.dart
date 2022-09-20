import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  String countryCode = '+1';
  final LoginController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Text(LocalizationString.hi,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).primaryColor)
                  .copyWith(fontWeight: FontWeight.w900)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(LocalizationString.signUpMessage,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GetBuilder<LoginController>(
              init: controller,
              builder: (ctx) {
                return Stack(children: [
                  Container(
                    color: Colors.transparent,
                    height: 50,
                    child: InputField(
                      controller: name,
                      showDivider: true,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColor),
                      hintText: LocalizationString.userName,
                      onChanged: (value) {
                        if (value.length > 3) {
                          controller.verifyUsername(value);
                        }
                      },
                    ),
                  ),
                  Positioned(
                      right: 10,
                      bottom: 15,
                      child: controller.userNameCheckStatus != -1
                          ? controller.userNameCheckStatus == 1
                              ? ThemeIconWidget(
                                  ThemeIcon.checkMark,
                                  color: Theme.of(context).primaryColor,
                                )
                              : ThemeIconWidget(
                                  ThemeIcon.close,
                                  color: Theme.of(context).errorColor,
                                )
                          : Container()),
                  const SizedBox(
                    width: 20,
                  )
                ]);
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          addTextField(email, LocalizationString.email),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          PasswordField(
            showDivider: true,
            cornerRadius: 5,
            onChanged: (value) {},
            controller: password,
            hintText: LocalizationString.password,
            showRevealPasswordIcon: true,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          PasswordField(
            showDivider: true,
            cornerRadius: 5,
            onChanged: (value) {},
            controller: confirmPassword,
            hintText: LocalizationString.confirmPassword,
            showRevealPasswordIcon: true,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            children: [
              Text(LocalizationString.signingInTerms,
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(LocalizationString.termsOfService,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).primaryColor)),
              Text(LocalizationString.and,
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(LocalizationString.privacyPolicy,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).primaryColor)),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          addSignUpBtn(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.35,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                LocalizationString.or,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.35,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          const SocialLogin().setPadding(left: 65, right: 65),
          const Spacer(),
          Row(
            children: [
              Text(
                LocalizationString.alreadyHaveAcc,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(LocalizationString.signIn,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600))
                  .ripple(() {
                Get.to(() => const LoginScreen());
              })
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ]),
      ).setPadding(left: 25, right: 25),
    );
  }

  Widget addTextField(TextEditingController controller, String hintText) {
    return InputField(
      controller: controller,
      showDivider: true,
      textStyle: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Theme.of(context).backgroundColor),
      hintText: hintText,
      cornerRadius: 5,
    );
  }

  addSignUpBtn() {
    return FilledButtonType1(
      onPress: () {
        FocusScope.of(context).requestFocus(FocusNode());
        controller.register(
            name: name.text,
            email: email.text,
            password: password.text,
            confirmPassword: confirmPassword.text,
            context: context);
      },
      text: LocalizationString.signUp,
      enabledTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
      isEnabled: true,
    );
  }
}