import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchStarted;
  final ValueChanged<String> onSearchCompleted;

  final Color? iconColor;
  final Color? backgroundColor;
  final double? radius;

  final bool? needBackButton;
  final bool? showSearchIcon;
  final TextStyle? textStyle;
  final double? shadowOpacity;
  final String? hintText;

  const SearchBar({
    Key? key,
    required this.onSearchCompleted,
    this.onSearchStarted,
    this.onSearchChanged,
    this.iconColor,
    this.radius,

    this.backgroundColor,
    this.needBackButton,
    this.showSearchIcon,
    this.textStyle,
    this.shadowOpacity,
    this.hintText,

  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late ValueChanged<String>? onSearchChanged;
  late VoidCallback? onSearchStarted;
  late ValueChanged<String> onSearchCompleted;
  TextEditingController controller = TextEditingController();
  late Color? iconColor;
  String? searchText;
  bool? needBackButton;
  bool? showSearchIcon;
  late TextStyle? textStyle;
  late Color? backgroundColor;
  late double? radius;
  late double? shadowOpacity;
  late String? hintText;

  @override
  void initState() {
    onSearchChanged = widget.onSearchChanged;
    onSearchStarted = widget.onSearchStarted;
    onSearchCompleted = widget.onSearchCompleted;
    iconColor = widget.iconColor;
    needBackButton = widget.needBackButton;
    showSearchIcon = widget.showSearchIcon;
    textStyle = widget.textStyle;
    backgroundColor = widget.backgroundColor;
    radius = widget.radius;
    shadowOpacity = widget.shadowOpacity;
    hintText = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            needBackButton == true
                ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: ThemeIconWidget(
                  ThemeIcon.backArrow,
                  color: Theme.of(context).primaryColor,
                ))
                : Container(),
            showSearchIcon == true
                ? ThemeIconWidget(
              ThemeIcon.search,
              color: iconColor,
              size: 20,
            ).lP16.ripple(() {
              if (searchText != null && searchText!.length > 2) {
                onSearchChanged!(searchText!);
              }
            })
                : Container(),
            Expanded(
              child: TextField(
                  controller: controller,
                  onEditingComplete: () {
                    onSearchCompleted(controller.text);
                  },
                  onChanged: (value) {
                    searchText = value;
                    // controller.text = searchText!;
                    if (onSearchChanged != null) {
                      onSearchChanged!(value);
                    }
                    setState(() {});
                  },
                  onTap: () {
                    if (onSearchStarted != null) {
                      onSearchStarted!();
                    }
                  },
                  style: textStyle,
                  cursorColor: Theme.of(context).iconTheme.color,
                  decoration: InputDecoration(
                    hintStyle: textStyle ?? Theme.of(context).textTheme.bodyMedium,
                    hintText: hintText ?? LocalizationString.searchAnything,
                    border: InputBorder.none,

                  )).setPadding(bottom: 4, left: 8),
            ),
          ],
        ),
      ),
    ).shadow(context:context ,radius: radius ?? 20,fillColor: backgroundColor,shadowOpacity: shadowOpacity);
  }
}