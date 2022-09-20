import 'package:flutter/material.dart';
import 'package:foap/segmentAndMenu/triangle_shape.dart';
import 'package:foap/helper/extension.dart';

class HorizontalMenuBar extends StatefulWidget {
  final Function(int) onSegmentChange;
  final List<Widget> childs;

  final double? height;
  final EdgeInsets? padding;

  const HorizontalMenuBar(
      {Key? key,
      required this.onSegmentChange,
      required this.childs,

      this.height,
      this.padding})
      : super(key: key);

  @override
  State<HorizontalMenuBar> createState() => _HorizontalMenuBarState();
}

class _HorizontalMenuBarState extends State<HorizontalMenuBar> {
  List<Widget> childs = [];
  String selectedMenu = 'Sports';
  Widget? selectedChild;
  late double? height;
  late EdgeInsets? padding;

  @override
  void initState() {
    childs = widget.childs;
    height = widget.height;
    padding = widget.padding;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 28,
      child: Center(
        child: ListView.builder(
            padding: padding ?? EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, index) {
              return childs[index].hP4.ripple(() {
                setState(() {
                  // selectedMenu = menus[index];
                  widget.onSegmentChange(index);
                });
              });
            },
            itemCount: childs.length),
      ),
    );
  }
}

class StaggeredMenuBar extends StatefulWidget {
  final String? title;
  final Function(int) onSegmentChange;
  final List<Widget> childs;

  const StaggeredMenuBar(
      {Key? key,
      this.title,
      required this.childs,
      required this.onSegmentChange,
      })
      : super(key: key);

  @override
  State<StaggeredMenuBar> createState() => _StaggeredMenuBarState();
}

class _StaggeredMenuBarState extends State<StaggeredMenuBar> {
  List<Widget> childs = [];
  String selectedMenu = 'Sports';
  Widget? selectedChild;
  late String? title;


  @override
  void initState() {
    childs = widget.childs;
    title = widget.title;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Text(title!, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600))
                .bP16
            : Container(),
        Wrap(
          spacing: 5,
          runSpacing: 10,
          children: <Widget>[for (int i = 0; i < childs.length; i++) childs[i]],
        ),
      ],
    ).vP16;
  }
}

class HorizontalSegmentBar extends StatefulWidget {
  final List<String> segments;
  final Function(int) onSegmentChange;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double? width;

  const HorizontalSegmentBar({
    Key? key,
    required this.onSegmentChange,
    required this.segments,

    this.textStyle,
    this.selectedTextStyle,
    this.width,
  }) : super(key: key);

  @override
  State<HorizontalSegmentBar> createState() => _HorizontalSegmentBarState();
}

class _HorizontalSegmentBarState extends State<HorizontalSegmentBar> {
  int selectedMenuIndex = 0;
  late double width;

  @override
  void initState() {
    super.initState();

    width = 0;
    Future.delayed(Duration.zero, () {
      setState(() {
        width = widget.width ?? MediaQuery.of(context).size.width - 40;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedMenuIndex = index;
                  widget.onSegmentChange(index);
                });
              },
              child: SizedBox(
                width: width / widget.segments.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    Text(widget.segments[index],
                        style: index == selectedMenuIndex
                            ? widget.selectedTextStyle ??
                                Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor).copyWith(fontWeight: FontWeight.w900)
                            : widget.textStyle ?? Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
                    index == selectedMenuIndex
                        ? Container(
                            height: 2,
                            width: width / widget.segments.length,
                            color: Theme.of(context).primaryColor,
                          ).round(10)
                        : Container(
                            height: 0.5,
                            width: width / widget.segments.length,
                            color: Theme.of(context).disabledColor.withOpacity(0.5),
                          )
                  ],
                ),
              ),
            );
          },
          itemCount: widget.segments.length),
    );
  }
}

class LargeHorizontalMenuBar extends StatefulWidget {
  final Function(int) onSegmentChange;
  final List<Widget> childs;

  const LargeHorizontalMenuBar(
      {Key? key,
      required this.onSegmentChange,
      required this.childs,
      })
      : super(key: key);

  @override
  State<LargeHorizontalMenuBar> createState() => _LargeHorizontalMenuBarState();
}

class _LargeHorizontalMenuBarState extends State<LargeHorizontalMenuBar> {
  List<Widget> childs = [];
  Widget? selectedChild;

  @override
  void initState() {
    childs = widget.childs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return Align(
                alignment: Alignment.centerLeft,
                child: childs[index].rp(25).ripple(() {
                  setState(() {
                    // selectedMenu = menus[index];
                    widget.onSegmentChange(index);
                  });
                }));
          },
          itemCount: childs.length),
    );
  }
}

class HorizontalSegmentBarWithPointer extends StatefulWidget {
  final List<String> segments;
  final Function(int) onSegmentChange;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double? width;
  final int? selectedMenuIndex;

  const HorizontalSegmentBarWithPointer({
    Key? key,
    required this.onSegmentChange,
    required this.segments,

    this.textStyle,
    this.selectedTextStyle,
    this.width,
    this.selectedMenuIndex
  }) : super(key: key);

  @override
  State<HorizontalSegmentBarWithPointer> createState() =>
      _HorizontalSegmentBarWithPointerState();
}

class _HorizontalSegmentBarWithPointerState
    extends State<HorizontalSegmentBarWithPointer> {
  List<String> menus = ['Detail', 'Related'];
  int selectedMenuIndex = 0;
  late TextStyle? textStyle;
  late TextStyle? selectedTextStyle;
  late double width;

  @override
  void initState() {
    super.initState();

    menus = widget.segments;
    textStyle = widget.textStyle;
    selectedTextStyle = widget.selectedTextStyle;
    width = 0;
    selectedMenuIndex = widget.selectedMenuIndex ?? 0;

    Future.delayed(Duration.zero, () {
      setState(() {
        width = widget.width ?? MediaQuery.of(context).size.width - 40;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedMenuIndex = index;
                  widget.onSegmentChange(index);
                });
              },
              child: SizedBox(
                width: width / menus.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    Text(menus[index],
                        style: index == selectedMenuIndex
                            ? selectedTextStyle ??
                                Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).primaryColor).copyWith(fontWeight: FontWeight.w900)
                            : textStyle ?? Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),


                    index == selectedMenuIndex
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomPaint(
                                  size: const Size(5, 5),
                                  painter: TopPointingTriangle(color: Theme.of(context).primaryColor)),
                              Container(
                                height: 2,
                                width: width / menus.length,
                                color: Theme.of(context).primaryColor,
                              ).round(10),
                            ],
                          )
                        : Container(
                            height: 2,
                            width: width / menus.length,
                            color: Theme.of(context).disabledColor.withOpacity(0.5),
                          )
                  ],
                ),
              ),
            );
          },
          itemCount: menus.length),
    );
  }
}
