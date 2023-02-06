import 'package:flutter/material.dart';
import 'package:foap/helper/extension.dart';

class FilledButtonType1 extends StatelessWidget {
  final String? text;
  final double? height;
  final double? width;
  final double? cornerRadius;
  final bool? isEnabled;
  final Widget? leading;
  final Widget? trailing;
  final Color? enabledBackgroundColor;
  final Color? disabledBackgroundColor;

  final TextStyle? enabledTextStyle;
  final TextStyle? disabledTextStyle;

  final VoidCallback? onPress;

  const FilledButtonType1({
    Key? key,
    required this.text,
    required this.onPress,
    this.height,
    this.width,
    this.cornerRadius,
    this.leading,
    this.trailing,
    this.enabledBackgroundColor,
    this.disabledBackgroundColor,
    this.enabledTextStyle,
    this.disabledTextStyle,
    this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 50,
      color: isEnabled == false
          ? disabledBackgroundColor ??
              Theme.of(context).disabledColor.withOpacity(0.2)
          : enabledBackgroundColor ?? Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading != null ? leading!.hP8 : Container(),
          Center(
            child: Text(
              text!,
              style: isEnabled == true
                  ? enabledTextStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600)
                  : disabledTextStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
            ).hP8,
          ),
          trailing != null ? trailing!.hP4 : Container()
        ],
      ),
    ).round(cornerRadius ?? 15).ripple(() {
      isEnabled == false ? null : onPress!();
    });
  }
}

class BorderButtonType1 extends StatelessWidget {
  final String? text;
  final VoidCallback? onPress;
  final Color? borderColor;
  final Color? backgroundColor;
  final double? height;
  final double? cornerRadius;
  final TextStyle? textStyle;
  final double? width;

  const BorderButtonType1(
      {Key? key,
      required this.text,
      required this.onPress,
      this.height,
      this.width,
      this.cornerRadius,
      this.borderColor,
      this.backgroundColor,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ,
      height: height ?? 50,
      color: backgroundColor,
      child: Center(
        child: Text(
          text!,
          style: textStyle ??
              Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w600),
        ).hP8,
      ),
    )
        .borderWithRadius(
            context: context,
            value: 1,
            radius: cornerRadius ?? 15,
            color: borderColor ?? Theme.of(context).dividerColor)
        .ripple(onPress!);
  }
}
