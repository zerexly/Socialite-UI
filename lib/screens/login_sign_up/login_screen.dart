import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final LoginController controller = Get.find();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    ),
                    Text(LocalizationString.welcome,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontWeight: FontWeight.w900)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Text(LocalizationString.signInMessage,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w600)),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    InputField(
                      controller: email,
                      showDivider: true,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                      hintText: LocalizationString.emailOrUsername,
                      cornerRadius: 5,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    PasswordField(
                      onChanged: (value) {},
                      showDivider: true,
                      controller: password,
                      cornerRadius: 5,
                      hintText: LocalizationString.password,
                      showRevealPasswordIcon: true,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    addLoginBtn(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: Center(
                        child: Text(LocalizationString.forgotPwd,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).primaryColor)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width * 0.37,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          LocalizationString.or,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width * 0.37,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    const SocialLogin().setPadding(left: 65, right: 65),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          LocalizationString.dontHaveAccount,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(LocalizationString.signUp,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor))
                            .ripple(() {
                          Get.to(() => const SignUpScreen());
                        }),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    // bioMetricView(),
                    // const Spacer(),
                  ]),
            )).setPadding(left: 25, right: 25),
      ),
    );
  }

  Widget addLoginBtn() {
    return FilledButtonType1(
      onPress: () {
        controller.login(email.text.trim(), password.text.trim(), context);
      },
      text: LocalizationString.signIn,
      enabledTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w900, color: Colors.white),
      isEnabled: true,
    );
  }
}
