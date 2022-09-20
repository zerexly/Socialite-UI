import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class LoginController extends GetxController {
  late bool haveBiometricLogin = false;
  var localAuth = LocalAuthentication();
  late int bioMetricType = -1;

  bool passwordReset = false;
  int userNameCheckStatus = -1;
  RxBool canResendOTP = true.obs;

  int pinLength = 6;
  RxBool hasError = false.obs;
  RxBool otpFilled = false.obs;

  void checkBiometric() async {
    bool bioMetricAuthStatus = await SharedPrefs().getBioMetricAuthStatus();
    if (getIt<UserProfileManager>().isLogin == true &&
        bioMetricAuthStatus == true) {
      haveBiometricLogin = await localAuth.canCheckBiometrics;

      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      // if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        bioMetricType = 1;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        bioMetricType = 2;
      }
    }
    update();
  }

  void biometricLogin() async {
    try {
      bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Please authenticate to login into app');

      if (didAuthenticate == true) {
        Get.offAll(() => const DashboardScreen());
        getIt<SocketManager>().connect();
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Handle this exception here.
      }
    }
  }

  void login(String email, String password, BuildContext context) {
    if (FormValidator().isTextEmpty(email)) {
      showErrorMessage(LocalizationString.pleaseEnterValidEmail,context);
    } else if (FormValidator().isTextEmpty(password)) {
      showErrorMessage(LocalizationString.pleaseEnterPassword,context);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          ApiController().login(email, password).then((response) async {
            if (response.success) {
              SharedPrefs().setUserLoggedIn(true);
              await SharedPrefs().setAuthorizationKey(response.authKey!);
              await getIt<UserProfileManager>().refreshProfile();
              Get.offAll(() => const DashboardScreen());
              getIt<SocketManager>().connect();
            } else {
              if (response.token != null) {
                Get.to(() => VerifyOTPScreen(
                      isVerifyingEmail: true,
                      token: response.token!,
                    ));
              } else {
                showErrorMessage(response.message,context);
              }
            }
          });
        } else {
          showErrorMessage(LocalizationString.noInternet,context);
        }
      });
    }
  }

  void register(
      {required String email,
      required String name,
      required String password,
      required String confirmPassword,required BuildContext context}) {
    if (FormValidator().isTextEmpty(name)) {
      showErrorMessage(LocalizationString.pleaseEnterName,context);
    } else if (FormValidator().isTextEmpty(email)) {
      showErrorMessage(LocalizationString.pleaseEnterValidEmail,context);
    } else if (FormValidator().isNotValidEmail(email)) {
      showErrorMessage(LocalizationString.pleaseEnterValidEmail,context);
    } else if (FormValidator().isTextEmpty(password)) {
      showErrorMessage(LocalizationString.pleaseEnterPassword,context);
    } else if (password != confirmPassword) {
      showErrorMessage(LocalizationString.passwordsDoesNotMatched,context);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          ApiController()
              .registerUser(name, email, password)
              .then((response) async {
            if (response.success) {
              Get.to(() => VerifyOTPScreen(
                    isVerifyingEmail: true,
                    token: response.token!,
                  ));
            } else {
              showErrorMessage(response.message,context);
            }
          });
        } else {
          showErrorMessage(LocalizationString.noInternet,context);
        }
      });
    }
  }

  void resetPassword(
      {required String newPassword,
      required String confirmPassword,
      required String token,required BuildContext context}) {
    if (FormValidator().isTextEmpty(newPassword)) {
      showErrorMessage(LocalizationString.pleaseEnterPassword,context);
    } else if (FormValidator().isTextEmpty(confirmPassword)) {
      showErrorMessage(LocalizationString.pleaseEnterConfirmPassword,context);
    } else if (newPassword != confirmPassword) {
      showErrorMessage(LocalizationString.passwordsDoesNotMatched,context);
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
              showErrorMessage(response.message,context);
            }
          });
        } else {
          showErrorMessage(LocalizationString.noInternet,context);
        }
      });
    }
  }

  void verifyUsername(String userName) {
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

  void resendOTP({required String token,required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().resendOTP(token).then((response) async {
          EasyLoading.dismiss();
          showSuccessMessage(response.message,context);
          canResendOTP.value = false;

          update();
        });
      } else {
        showErrorMessage(LocalizationString.noInternet,context);
      }
    });
  }

  void callVerifyOTP(
      {required bool isVerifyingEmail,
      required String otp,
      required String token,required BuildContext context}) {
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
                AppUtil.showToast(context: context,message: response.message, isSuccess: true);
                Get.to(() => const LoginScreen());
              } else {
                Get.to(() => ResetPasswordScreen(token: response.token!));
              }
            });
          }
        });
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: false);
      }
    });
  }

  void callVerifyOTPForChangePhone(
      {required String otp, required String token,required BuildContext context}) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController().verifyChangePhoneOTP(otp, token).then((response) async {
          EasyLoading.dismiss();
          AppUtil.showToast(context: context,message: response.message, isSuccess: true);
          if (response.success) {
            Future.delayed(const Duration(milliseconds: 500), () {
              Get.back();
            });
          }
        });
      } else {
        AppUtil.showToast(context: context,
            message: LocalizationString.noInternet, isSuccess: false);
      }
    });
  }

  void forgotPassword({required String email,required BuildContext context}) {
    if (FormValidator().isTextEmpty(email)) {
      AppUtil.showToast(context: context,
          message: LocalizationString.pleaseEnterEmail, isSuccess: false);
    } else if (FormValidator().isNotValidEmail(email)) {
      AppUtil.showToast(context: context,
          message: LocalizationString.pleaseEnterValidEmail, isSuccess: false);
    } else {
      AppUtil.checkInternet().then((value) {
        if (value) {
          EasyLoading.show(status: LocalizationString.loading);
          ApiController().forgotPassword(email).then((response) async {
            EasyLoading.dismiss();
            AppUtil.showToast(context: context,message: response.message, isSuccess: true);
            if (response.success) {
              Get.to(() => VerifyOTPScreen(
                    isVerifyingEmail: false,
                    token: response.token!,
                  ));
            }
          });
        } else {
          AppUtil.showToast(context: context,
              message: LocalizationString.noInternet, isSuccess: false);
        }
      });
    }
  }

  showSuccessMessage(String message,BuildContext context) {
    AppUtil.showToast(context: context,message: message, isSuccess: false);
  }

  showErrorMessage(String message,BuildContext context) {
    AppUtil.showToast(context: context,message: message, isSuccess: true);
  }
}
