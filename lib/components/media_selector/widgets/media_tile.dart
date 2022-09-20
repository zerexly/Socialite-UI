import 'jumping_button.dart';
import 'package:foap/helper/common_import.dart';

//ignore: must_be_immutable
class MediaTile extends StatefulWidget {
  MediaTile({
    Key? key,
    required this.media,
    required this.onSelected,
    required this.isSelected,
    this.decoration,
  }) : super(key: key);

  final AssetEntity media;
  final Function(bool, Media) onSelected;
  bool isSelected;
  final PickerDecoration? decoration;

  @override
  State<MediaTile> createState() => _MediaTileState();
}

class _MediaTileState extends State<MediaTile>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  Media? media;

  final Duration _duration = const Duration(milliseconds: 100);
  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: _duration);
    _animation =
        Tween<double>(begin: 1.0, end: 1.3).animate(_animationController!);
    if (widget.isSelected) _animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (media != null) {
      return Padding(
        padding: const EdgeInsets.all(0.5),
        child: Stack(
          children: [
            Positioned.fill(
              child: media!.thumbnail != null
                  ? JumpingButton(
                      onTap: () {
                        setState(() => widget.isSelected = !widget.isSelected);
                        if (widget.isSelected) {
                          _animationController!.forward();
                        } else {
                          _animationController!.reverse();
                        }
                        widget.onSelected(widget.isSelected, media!);
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRect(
                              child: AnimatedBuilder(
                                  animation: _animation!,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _animation!.value,
                                      child: Image.memory(
                                        media!.thumbnail!,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: widget.isSelected ? 1 : 0,
                              curve: Curves.easeOut,
                              duration: _duration,
                              child: ClipRect(
                                child: Container(
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ),
                          if (widget.media.type == AssetType.video)
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5, bottom: 5),
                                child: Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedOpacity(
                  curve: Curves.easeOut,
                  duration: _duration,
                  opacity: widget.isSelected ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(5),
                    child: const Icon(
                      Icons.done,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      convertToMedia(media: widget.media)
          .then((e) => setState(() => media = e));
      return LoadingWidget(
        decoration: widget.decoration!,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

Future<Media> convertToMedia({required AssetEntity media}) async {
  Media convertedMedia = Media();
  convertedMedia.file = await media.file;
  convertedMedia.mediaByte = await media.originBytes;
  convertedMedia.thumbnail =
      await media.thumbnailDataWithSize(const ThumbnailSize(200, 200));
  convertedMedia.id = media.id;
  convertedMedia.size = media.size;
  convertedMedia.title = media.title;
  convertedMedia.creationTime = media.createDateTime;

  GalleryMediaType mediaType = GalleryMediaType.all;
  if (media.type == AssetType.video) mediaType = GalleryMediaType.video;
  if (media.type == AssetType.image) mediaType = GalleryMediaType.image;
  convertedMedia.mediaType = mediaType;

  return convertedMedia;
}
