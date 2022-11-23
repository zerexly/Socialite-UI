import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class VerifyOTPPhoneNumberChange extends StatefulWidget {
  final String token;

  const VerifyOTPPhoneNumberChange({Key? key, required this.token})
      : super(key: key);

  @override
  VerifyOTPPhoneNumberChangeState createState() =>
      VerifyOTPPhoneNumberChangeState();
}

class VerifyOTPPhoneNumberChangeState
    extends State<VerifyOTPPhoneNumberChange> {
  TextEditingController controller = TextEditingController(text: "");
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeIconWidget(
                ThemeIcon.backArrow,
                size: 20,
              ).ripple(() {
                Get.back();
              }),
              // Image.asset(
              //   'assets/logo.png',
              //   width: 80,
              //   height: 25,
              // ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          const SizedBox(
            height: 105,
          ),
          Text(
            LocalizationString.helpToChangePhoneNumber,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor).copyWith(fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          Text(LocalizationString.pleaseEnterOtpSentToYourPhone,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor))
              .setPadding(top: 43, bottom: 35),
          Obx(() => PinCodeTextField(
                autofocus: true,
                controller: controller,
                // hideCharacter: true,
                // highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: Colors.transparent,
                hasTextBorderColor: Colors.transparent,
                pinBoxColor: Theme.of(context).errorColor.withOpacity(0.2),
                highlightPinBoxColor: Theme.of(context).primaryColor.withOpacity(0.2),
                // highlightPinBoxColor: Colors.orange,
                maxLength: loginController.pinLength,
                hasError: loginController.hasError.value,
                // maskCharacter: "😎",
                onTextChanged: (text) {
                  loginController.otpTextFilled(text);
                },
                onDone: (text) {
                  loginController.otpCompleted();
                },
                pinBoxWidth: 50,
                pinBoxHeight: 50,
                // hasUnderline: true,
                wrapAlignment: WrapAlignment.spaceAround,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                pinTextStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
                pinTextAnimatedSwitcherDuration:
                    const Duration(milliseconds: 300),
                highlightAnimationBeginColor: Colors.black,
                highlightAnimationEndColor: Colors.white12,
                keyboardType: TextInputType.number,
              )),
          Obx(() => Row(
                children: [
                  Text(LocalizationString.didntReceivedCode,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor)),
                  Text(LocalizationString.resendOTP,
                          style: loginController.canResendOTP.value == false
                              ? Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).disabledColor)
                              : Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600))
                      .ripple(() {
                    if (loginController.canResendOTP.value == true) {
                      loginController.resendOTP(token: widget.token,context: context);
                    }
                  }),

                  loginController.canResendOTP.value == false
                      ? TweenAnimationBuilder<Duration>(
                          duration: const Duration(minutes: 2),
                          tween: Tween(
                              begin: const Duration(minutes: 2),
                              end: Duration.zero),
                          onEnd: () {
                            loginController.canResendOTP.value = true;
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            final minutes = value.inMinutes;
                            final seconds = value.inSeconds % 60;
                            return Text(' ($minutes:$seconds)',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor));
                          })
                      : Container()
                  // Text(' in (1:20) ', style: Theme.of(context).textTheme.bodyLarge.headingColor),
                ],
              )).setPadding(top: 20, bottom: 25),
          const Spacer(),
          Obx(() => loginController.otpFilled.value == true
              ? addSubmitBtn()
              : Container()),
          const SizedBox(
            height: 55,
          )
        ]),
      ).setPadding(left: 25, right: 25),
    );
  }

  addSubmitBtn() {
    return FilledButtonType1(
      onPress: () {
        loginController.callVerifyOTPForChangePhone(context: context,
            otp: controller.text, token: widget.token);
      },
      text: LocalizationString.verify,
      enabledTextStyle: Theme.of(context).textTheme.bodyLarge!
          .copyWith(fontWeight: FontWeight.w900,color: Colors.white),
      isEnabled: true,
    );
  }
}
