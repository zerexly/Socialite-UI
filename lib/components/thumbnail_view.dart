import 'package:foap/helper/common_import.dart';

class MediaThumbnailView extends StatefulWidget {
  final StoryMediaModel media;

  final double? size;
  final Color? borderColor;

  const MediaThumbnailView({
    Key? key,
    required this.media,
    this.size,
    this.borderColor,
  }) : super(key: key);

  @override
  State<MediaThumbnailView> createState() => _MediaThumbnailViewState();
}

class _MediaThumbnailViewState extends State<MediaThumbnailView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: widget.size ?? 50,
            width: widget.size ?? 50,
            child: widget.media.type == 2 // 1 for text, 2 for image, 3 for video
                ? CachedNetworkImage(
                    imageUrl: widget.media.image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => SizedBox(
                        height: 20,
                        width: 20,
                        child: const CircularProgressIndicator().p16),
                    errorWidget: (context, url, error) => const SizedBox(
                        height: 20, width: 20, child: Icon(Icons.error)),
                  ).round(18).p(1)
                : VTImageView(
                    assetPlaceHolder: '',
                    videoUrl: widget.media.video ?? '',
                    width: widget.size ?? 50,
                    height: widget.size ?? 50,
                    errorBuilder: (context, error, stack) {
                      return SizedBox(
                        width: widget.size ?? 50,
                        height: widget.size ?? 50,
                        child: const Center(
                          child: Icon(Icons.error),
                        ),
                      );
                    },
                  ))
        .borderWithRadius(
            context: context,
            value: 2,
            radius: 20,
            color: widget.borderColor ?? Theme.of(context).primaryColor);
  }

  loadVideoThumbnail() {}
}
