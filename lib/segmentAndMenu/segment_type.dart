
import 'package:foap/helper/common_import.dart';

enum SegmentType { segmnetType1, segmnetType2, segmnetType3, segmnetType4 }

class SegmentTab extends StatefulWidget {
  final ThemeIcon? icon;
  final String? image;

  final String title;
  final SegmentType? type;

  final bool isSelected;
  final double? cornerRadius;

  final Color? inActiveBgColor;
  final Color? activeBgColor;

  final Color? inActiveIconColor;
  final Color? activeIconColor;

  final TextStyle? inActiveTextStyle;
  final TextStyle? activeTextStyle;

  final Color? borderColor;

  const SegmentTab({
    Key? key,
    this.icon,
    this.image,
    this.type,
    required this.title,
    required this.isSelected,

    this.inActiveBgColor,
    this.cornerRadius,
    this.activeBgColor,
    this.inActiveIconColor,
    this.activeIconColor,
    this.inActiveTextStyle,
    this.activeTextStyle,
    this.borderColor,
  }) : super(key: key);

  @override
  State<SegmentTab> createState() => _SegmentTabState();
}

class _SegmentTabState extends State<SegmentTab> {
  ThemeIcon? icon;
  String? image;

  late String title;
  late bool isSelected;
  late SegmentType type;
  late double cornerRadius;

  @override
  void initState() {
    icon = widget.icon;
    image = widget.image;
    title = widget.title;
    isSelected = widget.isSelected;
    type = widget.type ?? SegmentType.segmnetType1;
    cornerRadius = widget.cornerRadius ?? 5;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SegmentType.segmnetType1:
        return segmentType1();
      case SegmentType.segmnetType2:
        return segmentType2();
      case SegmentType.segmnetType3:
        return segmentType3();
      default:
        segmentType1();
    }
    return segmentType1();
  }

  Widget segmentType1() {
    return Container(
      child: icon != null
          ? Row(
              children: [
                icon != null
                    ? ThemeIconWidget(
                        icon!,
                        color: isSelected == true
                            ? widget.activeIconColor ?? Theme.of(context).backgroundColor
                            : widget.inActiveIconColor ??
                                Theme.of(context).primaryColor,
                        size: 15,
                      )
                    : Container(
                        width: 1,
                      ),
                Text(title,
                        style: isSelected == true
                            ? widget.activeTextStyle ??
                            Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900)
                            : widget.inActiveTextStyle ??
                                Theme.of(context).textTheme.bodyMedium)
                    .hP8
              ],
            ).hP8
          : Center(
              child: Text(title,
                      style: isSelected == true
                          ? widget.activeTextStyle ??
                              Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900)
                          : widget.inActiveTextStyle ?? Theme.of(context).textTheme.bodyMedium)
                  .hP16),
    ).shadow(context:context ,
        radius: cornerRadius,
        fillColor: isSelected == true
            ? widget.activeBgColor ?? Theme.of(context).primaryColor
            : widget.inActiveBgColor).vP4;
  }

  Widget segmentType2() {
    return Container(
      child: icon != null
          ? Row(
              children: [
                icon != null
                    ? ThemeIconWidget(
                        icon!,
                        color: isSelected == true
                            ? widget.activeIconColor ?? Theme.of(context).backgroundColor
                            : widget.inActiveIconColor ??
                                Theme.of(context).primaryColor,
                        size: 15,
                      )
                    : Container(
                        width: 1,
                      ),
                Text(title,
                        style: isSelected == true
                            ? widget.activeTextStyle ?? Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w900)
                            : widget.inActiveTextStyle ?? Theme.of(context).textTheme.displayMedium)
                    .hP8
              ],
            ).hP8
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                        style: isSelected == true
                            ? widget.activeTextStyle ?? Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w900)
                            : widget.inActiveTextStyle ?? Theme.of(context).textTheme.displayMedium)
                    .bp(12),
                Container(
                  height: 5,
                  color: isSelected == true
                      ? widget.activeBgColor ?? Theme.of(context).primaryColor
                      : widget.inActiveBgColor,
                  width: 50,
                ).round(5)
              ],
            ),
    );
  }

  Widget segmentType3() {
    return Container(
        child: Column(
      children: [
        Container(
          height: 45,
          width: 50,
          color: isSelected == true
              ? widget.activeBgColor ?? Theme.of(context).primaryColor
              : widget.inActiveBgColor ?? Theme.of(context).disabledColor.withOpacity(0.1),
          child: Image.asset(
            image!,
            color: Theme.of(context).backgroundColor,
          ).p8,
        ).round(18).bP16,
        Text(title,
            style: isSelected == true
                ? widget.activeTextStyle ?? Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w900)
                : widget.inActiveTextStyle ?? Theme.of(context).textTheme.bodyMedium)
      ],
    ).hP8);
  }
}
