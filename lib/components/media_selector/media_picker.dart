import 'package:foap/components/custom_camera/delegates/camera_picker_text_delegate.dart';
import 'package:foap/components/media_selector/header.dart';
import 'package:foap/helper/common_import.dart';

///The MediaPicker widget that will select media files form storage
class MediaPicker extends StatefulWidget {
  ///The MediaPicker constructor that will select media files form storage
  const MediaPicker({
    Key? key,
    required this.onPick,

    // required this.mediaList,
    required this.capturedMedia,
    required this.onSelectMediaCount,
    this.mediaCount = MediaCount.multiple,
    this.mediaType = GalleryMediaType.all,
    this.maximumToSelect = 10,
    this.decoration,
    this.scrollController,
  }) : super(key: key);

  ///CallBack on image pick is done
  final ValueChanged<List<Media>> onPick;

  // ///Previously selected list of media in your app
  // final List<Media> mediaList;

  ///Callback on cancel the picking action
  final ValueChanged<Media> capturedMedia;

  ///Callback on mediaType action
  final Function(MediaCount) onSelectMediaCount;

  ///maximum media to select
  final int maximumToSelect;

  ///make picker to select multiple or single media file
  final MediaCount mediaCount;

  ///Make picker to select specific type of media, video or image
  final GalleryMediaType mediaType;

  ///decorate the UI of picker
  final PickerDecoration? decoration;

  ///assign a scroll controller to Media GridView of Picker
  final ScrollController? scrollController;

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  PickerDecoration? _decoration;

  AssetPathEntity? _selectedAlbum;
  List<AssetPathEntity>? _albums;

  final PanelController _albumController = PanelController();
  final HeaderController _headerController = HeaderController();

  @override
  void initState() {
    _fetchAlbums();
    _decoration = widget.decoration ?? PickerDecoration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: _albums == null
          ? LoadingWidget(
              decoration: widget.decoration!,
            )
          : _albums!.isEmpty
              ? const NoMedia()
              : Column(
                  children: [
                    if (_decoration!.actionBarPosition == ActionBarPosition.top)
                      _buildHeader(),
                    Expanded(
                        child: Stack(
                      children: [
                        Positioned.fill(
                          child: MediaList(
                            album: _selectedAlbum!,
                            headerController: _headerController,
                            // previousList: widget.mediaList,
                            mediaCount: widget.mediaCount,
                            decoration: widget.decoration,
                            scrollController: widget.scrollController,
                            onPick: widget.onPick,
                          ),
                        ),
                        AlbumSelector(
                          panelController: _albumController,
                          albums: _albums!,
                          decoration: widget.decoration!,
                          onSelect: (album) {
                            _headerController.closeAlbumDrawer!();
                            setState(() => _selectedAlbum = album);
                          },
                        ),
                      ],
                    )),
                    if (_decoration!.actionBarPosition ==
                        ActionBarPosition.bottom)
                      _buildHeader(),
                  ],
                ),
    );
  }

  Widget _buildHeader() {
    return Header(
      openCamera: handleCameraPress,
      albumController: _albumController,
      selectedAlbum: _selectedAlbum!,
      controller: _headerController,
      mediaCount: widget.mediaCount,
      decoration: _decoration,
      onSelectMediaCount: handleMediaCountPress,
    );
  }

  _fetchAlbums() async {
    RequestType type = RequestType.common;
    if (widget.mediaType == GalleryMediaType.all) {
      type = RequestType.common;
    } else if (widget.mediaType == GalleryMediaType.video) {
      type = RequestType.video;
    } else if (widget.mediaType == GalleryMediaType.image) {
      type = RequestType.image;
    }

    PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: type);

      _albums = [];
      for (AssetPathEntity album in albums) {
        int albumAssetCount = await album.assetCountAsync;
        if (albumAssetCount > 0) {
          _albums?.add(album);
        }
      }
      setState(() {
        _selectedAlbum = _albums![0];
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  void handleCameraPress() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(
          enableRecording: true,
          shouldAutoPreviewVideo: true,
          maximumRecordingDuration: Duration(seconds: 60),
          enablePinchToZoom: true,
          textDelegate: EnglishCameraPickerTextDelegate()),
    );

    if (entity != null) {
      Uint8List? thumbnailData = await entity.thumbnailData;
      Uint8List? mediaByte = await entity.originBytes;
      File? file = await entity.originFile;

      Media media = Media(
          id: entity.id,
          thumbnail: thumbnailData!,
          mediaByte: mediaByte,
          mediaType: file!.mediaType);

      widget.capturedMedia(media);
    }
  }

  void handleMediaCountPress(MediaCount count) {
    widget.onSelectMediaCount(count);
  }
}

///call this function to capture and get media from camera
openCamera(
    {

    ///callback when capturing is done
    required ValueChanged<Media> onCapture}) async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile != null) {
    Media converted = Media(
      id: UniqueKey().toString(),
      thumbnail: await pickedFile.readAsBytes(),
      creationTime: DateTime.now(),
      mediaByte: await pickedFile.readAsBytes(),
      title: 'capturedImage',
    );

    onCapture(converted);
  }
}
