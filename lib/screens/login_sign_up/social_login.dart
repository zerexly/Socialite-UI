import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class SocialLogin extends StatefulWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  State<SocialLogin> createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final SettingsController _settingsController = Get.find();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null) {
        socialLogin(
            'google', account.id, account.displayName ?? '', account.email);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            height: 55,
            width: 55,
            child: Center(
                child: Image.asset(
              'assets/gmailicon.png',
              height: 26,
              width: 26,
            ))).ripple(() {
          signInWithGoogle();
        }),
        Platform.isIOS
            ? SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: Image.asset(
                  'assets/apple.png',
                  height: 26,
                  width: 26,
                  color: Theme.of(context).primaryColor,
                ))).ripple(() {
                //signInWithGoogle();
                _handleAppleSignIn();
                // Get.to(() => const InstagramView());
              })
            : Container(),
        SizedBox(
            height: 55,
            width: 55,
            child: Center(
                child: Image.asset(
              'assets/facebook.png',
              height: 26,
              width: 26,
            ))).ripple(() {
          fbSignInAction();
        }),
      ],
    );
  }

  void signInWithGoogle() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      AppUtil.showToast(
          context: context,
          message: LocalizationString.errorMessage,
          isSuccess: false);
    }
  }

  void fbSignInAction() async {
    FocusScope.of(context).requestFocus(FocusNode());
    final facebookLogin = FacebookLogin();
    facebookLogin.logOut();
    final result = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (result.status) {
      case FacebookLoginStatus.success:
        // Get profile data
        final profile = await facebookLogin.getUserProfile();
        String name = profile?.name ?? '';
        String socialId = profile?.userId ?? '';
        final email = await facebookLogin.getUserEmail();

        AppUtil.checkInternet().then((value) {
          if (value) {
            // EasyLoading.show(status: LocalizationString.loading);

            socialLogin(
                'fb', socialId, name, email!);

            // ApiController()
            //     .socialLogin(name, 'fb', socialId, email!)
            //     .then((response) async {
            //   EasyLoading.dismiss();
            //   if (response.success) {
            //     SharedPrefs().setUserLoggedIn(true);
            //     getIt<UserProfileManager>().refreshProfile();
            //     SharedPrefs().setAuthorizationKey(response.authKey!);
            //
            //     // ask for location
            //     getIt<LocationManager>().postLocation();
            //
            //     Get.offAll(() => const DashboardScreen());
            //     getIt<SocketManager>().connect();
            //   } else {
            //     AppUtil.showToast(
            //         context: context,
            //         message: response.message,
            //         isSuccess: false);
            //   }
            // });
          } else {
            AppUtil.showToast(
                context: context,
                message: LocalizationString.noInternet,
                isSuccess: false);
          }
        });

        break;
      case FacebookLoginStatus.cancel:
        AppUtil.showToast(
            context: context,
            message: LocalizationString.cancelledByUser,
            isSuccess: false);
        break;
      case FacebookLoginStatus.error:
        AppUtil.showToast(
            context: context,
            message: result.error!.localizedDescription!,
            isSuccess: false);
        break;
    }
  }

  void socialLogin(String type, String userId, String name, String email) {
    AppUtil.checkInternet().then((value) {
      if (value) {
        EasyLoading.show(status: LocalizationString.loading);
        ApiController()
            .socialLogin(name, type, userId, email)
            .then((response) async {
          EasyLoading.dismiss();
          if (response.success) {
            SharedPrefs().setUserLoggedIn(true);
            await SharedPrefs().setAuthorizationKey(response.authKey!);
            await getIt<UserProfileManager>().refreshProfile();
            await _settingsController.getSettings();

            if (getIt<UserProfileManager>().user != null) {
              // ask for location
              getIt<LocationManager>().postLocation();

              Get.offAll(() => const DashboardScreen());
              getIt<SocketManager>().connect();
            }
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

  Future<void> _handleAppleSignIn() async {
    EasyLoading.show(status: 'loading...');

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    if (appleCredential.userIdentifier != null) {
      AppUtil.checkInternet().then((value) {
        if (value) {
          // EasyLoading.show(status: LocalizationString.loading);
          socialLogin(
              'apple', appleCredential.userIdentifier!, '', appleCredential.email ?? '');

          // ApiController()
          //     .socialLogin('', 'apple', appleCredential.userIdentifier!,
          //         appleCredential.email ?? '')
          //     .then((response) async {
          //   EasyLoading.dismiss();
          //   if (response.success) {
          //     SharedPrefs().setUserLoggedIn(true);
          //     getIt<UserProfileManager>().refreshProfile();
          //     SharedPrefs().setAuthorizationKey(response.authKey!);
          //
          //     // ask for location
          //     getIt<LocationManager>().postLocation();
          //
          //     Get.offAll(() => const DashboardScreen());
          //     getIt<SocketManager>().connect();
          //   } else {
          //     AppUtil.showToast(
          //         context: context,
          //         message: response.message,
          //         isSuccess: false);
          //   }
          // });
        } else {
          AppUtil.showToast(
              context: context,
              message: LocalizationString.noInternet,
              isSuccess: false);
        }
      });
    }
  }
}
