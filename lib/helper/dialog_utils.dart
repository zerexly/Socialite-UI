import 'package:foap/helper/common_import.dart';
import 'package:flutter/cupertino.dart';

class DialogUtils {
  static void showOkCancelAlertDialog({
    required BuildContext context,
    required String message,
    required String okButtonTitle,
    required String cancelButtonTitle,
    required Function cancelButtonAction,
    required Function okButtonAction,
    bool? isCancelEnable = true,
  }) {
    showDialog(
      barrierDismissible: isCancelEnable == true,
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return WillPopScope(
            onWillPop: () async => false,
            child: _showOkCancelCupertinoAlertDialog(
                context,
                message,
                okButtonTitle,
                cancelButtonTitle,
                okButtonAction,
                isCancelEnable == true,
                cancelButtonAction),
          );
        } else {
          return WillPopScope(
            onWillPop: () async => false,
            child: _showOkCancelMaterialAlertDialog(
                context,
                message,
                okButtonTitle,
                cancelButtonTitle,
                okButtonAction,
                isCancelEnable == true,
                cancelButtonAction),
          );
        }
      },
    );
  }

  static void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return WillPopScope(
              onWillPop: () async => false,
              child: _showCupertinoAlertDialog(context, message));
        } else {
          return WillPopScope(
              onWillPop: () async => false,
              child: _showMaterialAlertDialog(context, message));
        }
      },
    );
  }

  static CupertinoAlertDialog _showCupertinoAlertDialog(
      BuildContext context, String message) {
    return CupertinoAlertDialog(
      title: Text(AppConfigConstants.appName),
      content: Text(message),
      actions: _actions(context),
    );
  }

  static AlertDialog _showMaterialAlertDialog(
      BuildContext context, String message) {
    return AlertDialog(
      title: Text(AppConfigConstants.appName),
      content: Text(message),
      actions: _actions(context),
    );
  }

  static AlertDialog _showOkCancelMaterialAlertDialog(
      BuildContext context,
      String message,
      String okButtonTitle,
      String cancelButtonTitle,
      Function okButtonAction,
      bool isCancelEnable,
      Function cancelButtonAction) {
    return AlertDialog(
      title: Text(AppConfigConstants.appName),
      content: Text(message),
      actions: _okCancelActions(
        context: context,
        okButtonTitle: okButtonTitle,
        cancelButtonTitle: cancelButtonTitle,
        okButtonAction: okButtonAction,
        isCancelEnable: isCancelEnable,
        cancelButtonAction: cancelButtonAction,
      ),
    );
  }

  static CupertinoAlertDialog _showOkCancelCupertinoAlertDialog(
    BuildContext context,
    String message,
    String okButtonTitle,
    String cancelButtonTitle,
    Function okButtonAction,
    bool isCancelEnable,
    Function cancelButtonAction,{String? title}
  ) {
    return CupertinoAlertDialog(
        title: Text(title??AppConfigConstants.appName),
        content: Text(message),
        actions: isCancelEnable
            ? _okCancelActions(
                context: context,
                okButtonTitle: okButtonTitle,
                cancelButtonTitle: cancelButtonTitle,
                okButtonAction: okButtonAction,
                isCancelEnable: isCancelEnable,
                cancelButtonAction: cancelButtonAction,
              )
            : _okAction(
                context: context,
                okButtonAction: okButtonAction,
                okButtonTitle: okButtonTitle));
  }

  static List<Widget> _actions(BuildContext context) {
    return <Widget>[
      Platform.isIOS
          ? CupertinoDialogAction(
              child: Text(LocalizationString.ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : Text(LocalizationString.ok).ripple(() {
              Navigator.of(context).pop();
            }),
    ];
  }

  static List<Widget> _okCancelActions({
    required BuildContext context,
    required String okButtonTitle,
    required String cancelButtonTitle,
    required Function okButtonAction,
    required bool isCancelEnable,
    required Function cancelButtonAction,
  }) {
    return <Widget>[
      Platform.isIOS
          ? CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(cancelButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
              })
          : Text(cancelButtonTitle).ripple(() {
              Navigator.of(context).pop();
            }),
      Platform.isIOS
          ? CupertinoDialogAction(
              child: Text(okButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonAction();
              },
            )
          : Text(okButtonTitle).ripple(() {
              Navigator.of(context).pop();
              okButtonAction();
            }),
    ];
  }

  static List<Widget> _okAction(
      {required BuildContext context,
      required String okButtonTitle,
      required Function okButtonAction}) {
    return <Widget>[
      Platform.isIOS
          ? CupertinoDialogAction(
              child: Text(okButtonTitle),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonAction();
              },
            )
          : Text(okButtonTitle).ripple(() {
              Navigator.of(context).pop();
              okButtonAction();
            }),
    ];
  }
}
