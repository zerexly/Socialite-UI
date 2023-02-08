import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

import '../screens/login_sign_up/set_profile_category_type.dart';

class LoginController extends GetxController {
  final SettingsController _settingsController = Get.find();
  bool passwordReset = false;
  int userNameCheckStatus = -1;
  RxBool canResendOTP = true.obs;

  RxString passwordStrengthText = ''.obs;
  RxDouble passwordStrength = 0.toDouble().obs;

  int pinLength = 4;
  RxBool hasError = false.obs;
  RxBool otpFilled = false.obs;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  void login(String email, String password, BuildContext context) {
    if (FormValidator().isTextEmpty(email)) {
      showErrorMessage(LocalizationString.pleaseEnterValidEmail, context);
    } else if (FormValidator().isTextEmpty(password)) {
      showErrorMessage(LocalizationString.pleaseEnterPassword, context);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController().login(email, password).then((response) async {
            if (response.success) {
              EasyLoading.dismiss();
              await SharedPrefs().setAuthorizationKey(response.authKey!);
              await getIt<UserProfileManager>().refreshProfile();
              await _settingsController.getSettings();
              getIt<SocketManager>().connect();

              // ask for location
              getIt<LocationManager>().postLocation();
              if (response.isLoginFirstTime) {
                Get.offAll(() => const SetProfileCategoryType(
                      isFromSignup: false,
                    ));
              } else {
                SharedPrefs().setUserLoggedIn(true);
                Get.offAll(() => const DashboardScreen());
              }
            } else {
              EasyLoading.dismiss();
              if (response.token != null) {
                Get.to(() => VerifyOTPScreen(
                      isVerifyingEmail: true,
                      token: response.token!,
                    ));
              } else {
                EasyLoading.dismiss();
                showErrorMessage(response.message, context);
              }
            }
          });
        } else {
          showErrorMessage(LocalizationString.noInternet, context);
        }
      });
    }
  }

  checkPassword(String password) {
    password = password.trim();

    if (password.isEmpty) {
      passwordStrength.value = 0;
      passwordStrengthText.value = 'Please enter you password';
    } else if (password.length < 6) {
      passwordStrength.value = 1 / 4;
      passwordStrengthText.value = 'Your password is too short';
    } else if (password.length < 8) {
      passwordStrength.value = 2 / 4;
      passwordStrengthText.value = 'Your password is acceptable but not strong';
    } else {
      if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
        // Password length >= 8
        // But doesn't contain both letter and digit characters
        passwordStrength.value = 3 / 4;
        passwordStrengthText.value =
            'Your password must contain letter and number';
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        passwordStrength.value = 1;
        passwordStrengthText.value = 'Your password is great';
      }
    }
  }

  void register(
      {required String email,
      required String name,
      required String password,
      required String confirmPassword,
      required BuildContext context}) {
    if (FormValidator().isTextEmpty(name) || userNameCheckStatus != 1) {
      showErrorMessage(LocalizationString.pleaseEnterValidUserName, context);
    }
    if (name.contains(' ')) {
      showErrorMessage(LocalizationString.userNameCanNotHaveSpace, context);
    } else if (FormValidator().isTextEmpty(email)) {
      showErrorMessage(LocalizationString.pleaseEnterValidEmail, context);
    } else if (FormValidator().isNotValidEmail(email)) {
      showErrorMessage(LocalizationString.pleaseEnterValidEmail, context);
    } else if (FormValidator().isTextEmpty(password)) {
      showErrorMessage(LocalizationString.pleaseEnterPassword, context);
    } else if (FormValidator().isTextEmpty(confirmPassword)) {
      showErrorMessage(LocalizationString.pleaseEnterConfirmPassword, context);
    } else if (password != confirmPassword) {
      showErrorMessage(LocalizationString.passwordsDoesNotMatched, context);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);

          ApiController()
              .registerUser(name, email, password)
              .then((response) async {
            if (response.success) {
              EasyLoading.dismiss();
              Get.to(() => VerifyOTPScreen(
                    isVerifyingEmail: true,
                    token: response.token!,
                  ));
            } else {
              EasyLoading.dismiss();
              showErrorMessage(response.message, context);
            }
          });
        } else {
          showErrorMessage(LocalizationString.noInternet, context);
        }
      });
    }
  }

  void resetPassword(
      {required String newPassword,
      required String confirmPassword,
      required String token,
      required BuildContext context}) {
    if (FormValidator().isTextEmpty(newPassword)) {
      showErrorMessage(LocalizationString.pleaseEnterPassword, context);
    } else if (FormValidator().isTextEmpty(confirmPassword)) {
      showErrorMessage(LocalizationString.pleaseEnterConfirmPassword, context);
    } else if (newPassword != confirmPassword) {
      showErrorMessage(LocalizationString.passwordsDoesNotMatched, context);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          ApiController()
              .resetPassword(newPassword, token)
              .then((response) async {
            if (response.success) {
              passwordReset = true;
              update();
            } else {
              showErrorMessage(response.message, context);
            }
          });
        } else {
          showErrorMessage(LocalizationString.noInternet, context);
        }
      });
    }
  }

  void verifyUsername(String userName) {
    if (userName.contains(' ')) {
      userNameCheckStatus = 0;
      return;
    }
    print('correct');
    AppUtil.checkInternet().then((value) {
      if (value) {
        // AppUtil.showLoader(context);
        ApiController().checkUsername(userName).then((response) async {
          // Navigator.of(context).pop();
          if (response.success) {
            userNameCheckStatus = 1;
          } else {
            userNameCheckStatus = 0;
          }
          update();
        });
      } else {
        userNameCheckStatus = 0;
      }
    });
  }

  otpTextFilled(String otp) {
    otpFilled.value = otp.length == pinLength;
    hasError.value = false;

    update();
  }

  otpCompleted() {
    otpFilled.value = true;
    hasError.value = false;

    update();
  }

  void resendOTP({required String token, required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().resendOTP(token).then((response) async {
          EasyLoading.dismiss();
          showSuccessMessage(response.message, context);
          canResendOTP.value = false;

          update();
        });
      } else {
        showErrorMessage(LocalizationString.noInternet, context);
      }
    });
  }

  void callVerifyOTP(
      {required bool isVerifyingEmail,
      required String otp,
      required String token,
      required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController()
            .verifyOTP(isVerifyingEmail, otp, token)
            .then((response) async {
          EasyLoading.dismiss();

          if (response.success) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (isVerifyingEmail == true) {
                AppUtil.showToast(
                    context: context,
                    message: LocalizationString.registeredSuccessFully,
                    isSuccess: true);
                Get.to(() => const LoginScreen());
              } else {
                Get.to(() => ResetPasswordScreen(token: response.token!));
              }
            });
          } else {
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: false);
          }
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

  void callVerifyOTPForChangePhone(
      {required String otp,
      required String token,
      required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().verifyChangePhoneOTP(otp, token).then((response) async {
          EasyLoading.dismiss();
          AppUtil.showToast(
              context: context, message: response.message, isSuccess: true);
          if (response.success) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.back();
            });
          }
        });
      } else {
        AppUtil.showToast(
            context: context,
            message: LocalizationString.noInternet,
            isSuccess: false);
      }
    });
  }

  void forgotPassword({required String email, required BuildContext context}) {
    if (FormValidator().isTextEmpty(email)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterEmail,
          isSuccess: false);
    } else if (FormValidator().isNotValidEmail(email)) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.pleaseEnterValidEmail,
          isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController().forgotPassword(email).then((response) async {
            EasyLoading.dismiss();
            AppUtil.showToast(
                context: context, message: response.message, isSuccess: true);
            if (response.success) {
              Get.to(() => VerifyOTPScreen(
                    isVerifyingEmail: false,
                    token: response.token!,
                  ));
            }
          });
        } else {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.noInternet,
              isSuccess: false);
        }
      });
    }
  }

  Future<void> launchUrlInBrowser(String url) async {
    await launchUrl(Uri.parse(url));
  }

  showSuccessMessage(String message, BuildContext context) {
    AppUtil.showToast(context: context, message: message, isSuccess: true);
  }

  showErrorMessage(String message, BuildContext context) {
    AppUtil.showToast(context: context, message: message, isSuccess: false);
  }
}
