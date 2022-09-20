import 'package:foap/helper/common_import.dart';

class PasswordChangedPopup extends StatelessWidget {
  final VoidCallback dismissHandler;

  const PasswordChangedPopup({Key? key, required this.dismissHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            color: Theme.of(context).disabledColor.withOpacity(0.2),
          ).ripple(() {
            dismissHandler();
          }),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 360,
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  Text(
                    'Password changed successfully!',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).backgroundColor)
                        .copyWith(fontWeight: FontWeight.w900),
                  ).bp(20),
                  SizedBox(
                    height: 92,
                    width: 92,
                    child: Container(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      height: 92,
                      width: 92,
                      child: ThemeIconWidget(ThemeIcon.checkMark,
                          size: 45, color: Theme.of(context).primaryColor),
                    ).circular.p(10),
                  )
                      .borderWithRadius(
                          context: context,
                          value: 1,
                          radius: 46,
                          color:
                              Theme.of(context).disabledColor.withOpacity(0.1))
                      .vP25,
                  Text(
                    'Your password has been changed successfully',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).backgroundColor),
                  ).ripple(() {}).bp(10),
                  FilledButtonType1(
                    isEnabled: true,
                    enabledTextStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(
                            fontWeight: FontWeight.w900, color: Colors.white),
                    text: 'Back to login',
                    onPress: () {
                      getIt<UserProfileManager>().logout();
                    },
                  ).hP16
                ],
              ).setPadding(top: 40).hP16,
            ).topRounded(40),
          ),
        ],
      ),
    );
  }
}
