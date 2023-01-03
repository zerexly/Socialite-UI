import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foap/helper/common_import.dart';
import 'dart:math' as math;

extension RoundedHelper on Widget {
  ClipRRect round(double value) => ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(value)),
        child: this,
      );
}

extension Trnasform on Widget {
  Transform rotate(double value) => Transform.rotate(
        angle: value * math.pi / 180,
        child: this,
      );
}

extension PaddingHelper on Widget {
  Padding get p25 => Padding(padding: const EdgeInsets.all(25), child: this);

  Padding get p16 => Padding(padding: const EdgeInsets.all(16), child: this);

  Padding get p8 => Padding(padding: const EdgeInsets.all(8), child: this);

  Padding get p4 => Padding(padding: const EdgeInsets.all(4), child: this);

  /// Set padding according to `value`
  Padding p(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// Horizontal Padding 16
  Padding get hP4 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: this);

  Padding get hP8 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: this);

  Padding get hP16 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: this);

  Padding get hP25 =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: this);

  Padding hp(double value) =>
      Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Padding get rP4 =>
      Padding(padding: const EdgeInsets.only(right: 4), child: this);

  Padding get rP8 =>
      Padding(padding: const EdgeInsets.only(right: 8), child: this);

  Padding get rP16 =>
      Padding(padding: const EdgeInsets.only(right: 16), child: this);

  Padding get rP25 =>
      Padding(padding: const EdgeInsets.only(right: 25), child: this);

  Padding rp(double value) =>
      Padding(padding: EdgeInsets.only(right: value), child: this);

  Padding get lP4 =>
      Padding(padding: const EdgeInsets.only(left: 4), child: this);

  Padding get lP8 =>
      Padding(padding: const EdgeInsets.only(left: 8), child: this);

  Padding get lP16 =>
      Padding(padding: const EdgeInsets.only(left: 16), child: this);

  Padding get lP25 =>
      Padding(padding: const EdgeInsets.only(left: 25), child: this);

  Padding lp(double value) =>
      Padding(padding: EdgeInsets.only(left: value), child: this);

  Padding get tP4 =>
      Padding(padding: const EdgeInsets.only(top: 4), child: this);

  Padding get tP8 =>
      Padding(padding: const EdgeInsets.only(top: 8), child: this);

  Padding get tP16 =>
      Padding(padding: const EdgeInsets.only(top: 16), child: this);

  Padding get tP25 =>
      Padding(padding: const EdgeInsets.only(top: 25), child: this);

  Padding tp(double value) =>
      Padding(padding: EdgeInsets.only(top: value), child: this);

  Padding get bP4 =>
      Padding(padding: const EdgeInsets.only(bottom: 4), child: this);

  Padding get bP8 =>
      Padding(padding: const EdgeInsets.only(bottom: 8), child: this);

  Padding get bP16 =>
      Padding(padding: const EdgeInsets.only(bottom: 16), child: this);

  Padding get bP25 =>
      Padding(padding: const EdgeInsets.only(bottom: 25), child: this);

  Padding bp(double value) =>
      Padding(padding: EdgeInsets.only(bottom: value), child: this);

  Padding get vP25 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 25), child: this);

  Padding get vP16 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: this);

  Padding get vP8 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: this);

  Padding get vP4 =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: this);

  Padding vp(double value) =>
      Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  Padding setPadding(
          {double top = 0,
          double bottom = 0,
          double left = 0,
          double right = 0}) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, bottom: bottom, right: right, left: left),
          child: this);
}

extension Extented on Widget {
  Expanded get extended => Expanded(
        child: this,
      );
}

extension CornerRadius on Widget {
  ClipRRect get circular => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        child: this,
      );
}

extension SideCornerRadius on Widget {
  ClipRRect rightRounded(double value) => ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(value),
          bottomRight: Radius.circular(value),
        ),
        child: this,
      );

  ClipRRect leftRounded(double value) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(value),
          bottomLeft: Radius.circular(value),
        ),
        child: this,
      );

  ClipRRect topRounded(double value) => ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(value),
          topLeft: Radius.circular(value),
        ),
        child: this,
      );

  ClipRRect bottomRounded(double value) => ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(value),
          bottomLeft: Radius.circular(value),
        ),
        child: this,
      );

  ClipRRect topLeftDiognalRounded(double value) => ClipRRect(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(value),
          topLeft: Radius.circular(value),
        ),
        child: this,
      );

  ClipRRect topRightDiognalRounded(double value) => ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(value),
          bottomLeft: Radius.circular(value),
        ),
        child: this,
      );
}

extension ShadowView on Widget {
  Container shadow(
          {required BuildContext context,
          double? radius = 10,
          Color? fillColor,
          double? shadowOpacity}) =>
      Container(
        decoration: BoxDecoration(
          color: fillColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(Radius.circular(radius!)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(1, 1),
              blurRadius: radius,
              color: Theme.of(context)
                  .shadowColor
                  .withOpacity(shadowOpacity ?? 0.15),
            ),
          ],
        ),
        child: this,
      );

  Container shadowWithoutRadius(
          {required BuildContext context, Color? foregroundColor}) =>
      Container(
          decoration: BoxDecoration(
            color: foregroundColor ??
                Theme.of(context).backgroundColor.lighten(0.02),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(4, 4),
                blurRadius: 10,
                color: Theme.of(context).disabledColor.withOpacity(.2),
              ),
              BoxShadow(
                offset: const Offset(-3, 0),
                blurRadius: 15,
                color: Theme.of(context).disabledColor.withOpacity(.1),
              )
            ],
          ),
          child: this);

  Container shadowWithBorder(
          {required BuildContext context,
          double? radius = 15,
          Color? fillColor,
          Color? borderColor,
          double? borderWidth = 0.5,
          double? shadowOpacity}) =>
      Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: borderWidth ?? 0.5,
                color: borderColor ?? Theme.of(context).primaryColor),
            color: fillColor,
            borderRadius: BorderRadius.all(Radius.circular(radius!)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(1, 1),
                blurRadius: radius,
                color: fillColor != null
                    ? fillColor.withOpacity(.2)
                    : Theme.of(context)
                        .disabledColor
                        .withOpacity(shadowOpacity ?? 0.25),
              ),
              BoxShadow(
                offset: const Offset(-1, 0),
                blurRadius: radius,
                color: fillColor != null
                    ? fillColor.withOpacity(.2)
                    : Theme.of(context)
                        .disabledColor
                        .withOpacity(shadowOpacity ?? 0.25),
              )
            ],
          ),
          child: round(radius - (borderWidth ?? 0.5)));
}

extension FixedHeightBox on Widget {
  SizedBox height({required double value}) => SizedBox(
        height: value,
        child: this,
      );
}

extension FixedWidthBox on Widget {
  SizedBox width({required double value}) => SizedBox(
        width: value,
        child: this,
      );
}

extension BorderView on Widget {
  Container border(
          {required BuildContext context,
          required double value,
          Color? color}) =>
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(
              width: value, color: color ?? Theme.of(context).disabledColor),
        ),
        child: this,
      );

  Widget borderWithRadius({
    required BuildContext context,
    required double value,
    required double radius,
    Color? color,
  }) =>
      Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: value, color: color ?? Theme.of(context).dividerColor),
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: round(radius - 1));
}

extension ShimmerView on Widget {
  Shimmer addShimmer(BuildContext context) => Shimmer.fromColors(
        enabled: true,
        baseColor: Theme.of(context).highlightColor.withOpacity(0.1),
        highlightColor: Theme.of(context).highlightColor.withOpacity(0.2),
        child: this,
      );
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      InkWell(
        onTap: () {
          onPressed();
        },
        child: this,
      );
}

extension ExAlignment on Widget {
  Widget get alignTopCenter => Align(
        alignment: Alignment.topCenter,
        child: this,
      );

  Widget get alignCenter => Align(
        alignment: Alignment.center,
        child: this,
      );

  Widget get alignBottomCenter => Align(
        alignment: Alignment.bottomCenter,
        child: this,
      );

  Widget get alignBottomLeft => Align(
        alignment: Alignment.bottomLeft,
        child: this,
      );
}

extension StringAddOn on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

extension PulltoRefresh on Widget {
  Widget addPullToRefresh({
    required RefreshController refreshController,
    required VoidCallback onRefresh,
    required VoidCallback onLoading,
    required bool enablePullUp,
  }) =>
      SmartRefresher(
        enablePullDown: true,
        enablePullUp: enablePullUp,
        header: const WaterDropHeader(),
        controller: refreshController,
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: this,
      );
}

extension GradietBackground on Widget {
  Widget addGradientBackground() => Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff6f0000),
          Color(0xff200122),
        ],
      )),
      child: this);
}

extension PinchZoomImage on Widget {
  Widget addPinchAndZoom() => PinchZoom(
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: () {},
        onZoomEnd: () {},
        child: this,
      );

  Widget overlay(Color color) => Stack(
        fit: StackFit.expand,
        children: [
          this,
          Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(-1.0, -2.0),
              end: const Alignment(1.0, 2.0),
              colors: [
                color.darken(0.10),
                color.darken(0.50),
              ],
            ),
          ))
        ],
      );
}
