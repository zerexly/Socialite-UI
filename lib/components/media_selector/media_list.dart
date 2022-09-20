import 'package:foap/helper/common_import.dart';
import 'widgets/media_tile.dart';

class MediaList extends StatefulWidget {
  const MediaList({
    Key? key,
    required this.album,
    required this.headerController,
    required this.onPick,
    // required this.previousList,
    this.mediaCount,
    this.maximumToSelect = 10,
    this.decoration,
    this.scrollController,
  }) : super(key: key);

  final AssetPathEntity album;
  final HeaderController headerController;

  // final List<Media> previousList;
  final MediaCount? mediaCount;
  final PickerDecoration? decoration;
  final ScrollController? scrollController;
  final ValueChanged<List<Media>> onPick;

  ///maximum media to select
  final int maximumToSelect;

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  List<AssetEntity> mediaList = [];
  int currentPage = 0;
  int? lastPage;
  AssetPathEntity? album;

  List<Media> selectedMedias = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MediaList oldWidget) {
    // TODO: implement didUpdateWidget
    loadData();
    if (widget.mediaCount == MediaCount.single && selectedMedias.length > 1) {
      selectedMedias.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  loadData() {
    // _mediaList = [];
    if (widget.mediaCount == MediaCount.multiple) {
      // selectedMedias.addAll(widget.previousList);
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.headerController.updateSelection!(selectedMedias));
    } else {
      selectedMedias.clear();
    }
    _resetAlbum();
    // album = widget.album;
    // _fetchNewMedia();
  }

  @override
  Widget build(BuildContext context) {
    // _resetAlbum();
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: GridView.builder(
        padding: EdgeInsets.zero,
        controller: widget.scrollController,
        itemCount: mediaList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.decoration!.columnCount,
            childAspectRatio: widget.decoration!.childAspectRatio ?? 1),
        itemBuilder: (BuildContext context, int index) {
          return MediaTile(
            media: mediaList[index],
            onSelected: (isSelected, media) {
              setState(() {
                if (widget.mediaCount == MediaCount.multiple) {
                  if (isSelected) {
                    if (widget.maximumToSelect > selectedMedias.length) {
                      selectedMedias.add(media);
                    }
                  } else {
                    selectedMedias.removeWhere((e) => e.id == media.id);
                  }
                } else {
                  selectedMedias = [media];
                }
                widget.onPick(selectedMedias);
                widget.headerController.updateSelection!(selectedMedias);
              });
            },
            isSelected: isPreviouslySelected(mediaList[index]),
            decoration: widget.decoration,
          );
        },
      ),
    );
  }

  _resetAlbum() {
    // if (album != null) {
    //   print('album!.id = ${album!.name}');
    //   print('widget.album.id = ${widget.album.name}');

    if (album?.id != widget.album.id) {
      mediaList.clear();
      album = widget.album;
      currentPage = 0;
      _fetchNewMedia();
    }
    // }
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      List<AssetEntity> media =
          await album!.getAssetListPaged(page: currentPage, size: 60);

      setState(() {
        if (media.isNotEmpty) {
          for (var asset in media) {
            mediaList.add(asset);
          }

          convertToMedia(media: mediaList.first)
              .then((value) => selectedMedias.add(value));
          widget.onPick(selectedMedias);
          currentPage++;
        }
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  bool isPreviouslySelected(AssetEntity media) {
    bool isSelected = false;

    for (var asset in selectedMedias) {
      if (asset.id == media.id) isSelected = true;
    }
    return isSelected;
  }
}
