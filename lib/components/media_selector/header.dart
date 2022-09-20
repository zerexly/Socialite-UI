import 'dart:math';
import 'package:foap/helper/common_import.dart';
import 'widgets/jumping_button.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.selectedAlbum,
    required this.openCamera,
    required this.albumController,
    required this.controller,
    required this.mediaCount,
    required this.onSelectMediaCount,
    this.decoration,
  }) : super(key: key);

  final AssetPathEntity selectedAlbum;
  final VoidCallback openCamera;
  final PanelController albumController;
  final HeaderController controller;
  final MediaCount mediaCount;
  final PickerDecoration? decoration;
  final Function(MediaCount) onSelectMediaCount;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  List<Media> selectedMedia = [];

  late Animation<double> _arrowAnimation;
  AnimationController? _arrowAnimController;

  @override
  void initState() {
    _arrowAnimController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _arrowAnimation =
        Tween<double>(begin: 0, end: 1).animate(_arrowAnimController!);

    widget.controller.updateSelection = (selectedMediaList) {
      if (widget.mediaCount == MediaCount.multiple) {
        setState(() => selectedMedia = selectedMediaList.cast<Media>());
      } else if (selectedMediaList.length == 1) {
        // widget.onDone(selectedMediaList);
      }
    };

    widget.controller.closeAlbumDrawer = () {
      widget.albumController.close();
      _arrowAnimController!.reverse();
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          JumpingButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0.0, -0.5),
                              end: const Offset(0.0, 0.0))
                          .animate(animation),
                      child: child,
                    );
                  },
                  child: Text(
                    widget.selectedAlbum.name,
                    style: widget.decoration!.albumTitleStyle ??
                        Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                    key: ValueKey<String>(widget.selectedAlbum.id),
                  ),
                ),
                AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _arrowAnimation.value * pi,
                    child: Icon(
                      Icons.keyboard_arrow_up_outlined,
                      size: (widget.decoration!.albumTitleStyle?.fontSize) !=
                              null
                          ? widget.decoration!.albumTitleStyle!.fontSize! * 2
                          : 25,
                      color: widget.decoration!.albumTitleStyle?.color ??
                          Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              if (widget.albumController.isPanelOpen) {
                widget.albumController.close();
                _arrowAnimController!.reverse();
              }
              if (widget.albumController.isPanelClosed) {
                widget.albumController.open();
                _arrowAnimController!.forward();
              }
            },
          ),
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                color: widget.mediaCount == MediaCount.multiple
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                child: ThemeIconWidget(
                  ThemeIcon.selectionType,
                  color: Theme.of(context).iconTheme.color,
                  size: 18,
                ),
              ).circular.ripple(() {
                setState(() {
                  widget.onSelectMediaCount(
                      widget.mediaCount == MediaCount.single
                          ? MediaCount.multiple
                          : MediaCount.single);
                });
              }),
              const SizedBox(
                width: 20,
              ),
              ThemeIconWidget(
                ThemeIcon.camera,
                color: Theme.of(context).iconTheme.color,
                size: 18,
              ).circular.ripple(() {
                setState(() {
                  widget.openCamera();
                });
              }),

            ],
          )
        ],
      ).hP16,
    );
  }
}
