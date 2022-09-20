// import 'package:foap/helper/common_import.dart';
// import 'package:foap/util/constant_util.dart';
// import 'package:get/get.dart';
//
// class TrimVideo extends StatefulWidget {
//   final Uint8List bytes;
//   final Function(GalleryMedia) trimmedVideoCallback1;
//
//   const TrimVideo(
//       {Key? key, required this.bytes, required this.trimmedVideoCallback1})
//       : super(key: key);
//
//   @override
//   TrimVideoState createState() => TrimVideoState();
// }
//
// class TrimVideoState extends State<TrimVideo> {
//   late Uint8List bytes;
//   // Uint8List? thumbnailBytes;
//
//   // String? uploadedThumbnailPath;
//   String? uploadedVideoPath;
//
//   final picker = ImagePicker();
//
//   // final Trimmer _trimmer = Trimmer();
//
//   // double _startValue = 0.0;
//   // double _endValue = 0.0;
//   // bool _isPlaying = false;
//   late int videoLength = 0;
//   late String filePath;
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//
//     super.initState();
//     bytes = widget.bytes;
//     loadVideoTrimmer();
//   }
//
//   @override
//   void dispose() {
//     deleteFile(File(filePath));
//
//     super.dispose();
//   }
//
//   Future<void> deleteFile(File file) async {
//     try {
//       if (await file.exists()) {
//         await file.delete();
//       }
//     } catch (e) {
//       // Error in getting access to the file.
//     }
//   }
//
//   loadVideoTrimmer() async {
//     final tempDir = await getTemporaryDirectory();
//     File file = await File('${tempDir.path}/video.mp4').create();
//     file.writeAsBytesSync(bytes);
//     filePath = file.path;
//     // _trimmer.loadVideo(videoFile: file);
//
//     _controller = VideoPlayerController.file(file)..initialize().then((_) {});
//
//     // final videoInfo = FlutterVideoInfo();
//     // var info = await videoInfo.getVideoInfo(file.path);
//     videoLength = _controller.value.duration.inSeconds;
//
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//             child: Padding(
//           padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 const SizedBox(
//                   height: 55,
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                         onTap: () => Get.back(),
//                         child: const Icon(Icons.arrow_back_ios,
//                             color: Colors.black87)),
//                     const Spacer(),
//                     Text(
//                       LocalizationString.done,
//                       style: Theme.of(context).textTheme.titleMedium.themeColor.semiBold,
//                     ).ripple(() {
//                       trimVideo();
//                     })
//                   ],
//                 ),
//                 Center(
//                     child: Text(
//                   LocalizationString.video,
//                   style: Theme.of(context).textTheme.bodyLarge.greyColor,
//                 )).vP16,
//                 // Center(
//                 //         child: AspectRatio(
//                 //             aspectRatio: 1,
//                 //             child: VideoViewer(trimmer: _trimmer)))
//                 //     .bP25,
//                 // TrimEditor(
//                 //   trimmer: _trimmer,
//                 //   viewerHeight: 50.0,
//                 //   viewerWidth: MediaQuery.of(context).size.width,
//                 //   maxVideoLength: const Duration(seconds: 20),
//                 //   borderPaintColor: AppTheme.themeColor,
//                 //   circlePaintColor: AppTheme.themeColor,
//                 //   circleSize: 5,
//                 //   borderWidth: 5,
//                 //   showDuration: true,
//                 //   durationTextStyle: Theme.of(context).textTheme.bodyLarge.primaryColor,
//                 //   onChangeStart: (value) {
//                 //     _startValue = value;
//                 //     if (_isPlaying == false) {
//                 //       playVideo();
//                 //     }
//                 //   },
//                 //   onChangeEnd: (value) {
//                 //     _endValue = value;
//                 //     if (_isPlaying == false) {
//                 //       playVideo();
//                 //     }
//                 //   },
//                 //   onChangePlaybackState: (value) {
//                 //     setState(() {
//                 //       _isPlaying = value;
//                 //     });
//                 //   },
//                 // ).bP25,
//
//                 // Center(
//                 //     child: thumbnailBytes != null ? AspectRatio(
//                 //         aspectRatio: 1,
//                 //         child: Image.memory(thumbnailBytes!,fit: BoxFit.cover,)) : Container()).bP25,
//
//                 if (videoLength > 20)
//                   Center(
//                     child: Text(
//                       LocalizationString.videoCantExceed20Seconds,
//                       style: Theme.of(context).textTheme.bodyMedium.redColor,
//                     ).setPadding(left: 8, right: 25),
//                   ),
//               ]),
//         )));
//   }
//
//   playVideo() async {
//     // await _trimmer.videPlaybackControl(
//     //   startValue: _startValue,
//     //   endValue: _endValue,
//     // );
//   }
//
//   // Future<Uint8List> getThumbnailFile(String videoPath) async {
//   //   thumbnailBytes = await VideoCompress.getByteThumbnail(videoPath,
//   //       quality: 50, // default(100)
//   //       position: -1 // default(-1)
//   //       );
//   //
//   //   // final tempDir = await getTemporaryDirectory();
//   //   // File thumbnailFile = await File('${tempDir.path}/image.png').create();
//   //   // thumbnailFile.writeAsBytesSync(thumbnailBytes!);
//   //
//   //   return Future.value(thumbnailBytes);
//   // }
//
//
//   void trimVideo() async{
//     // Uint8List thumbnailBytes = await getThumbnailFile(videoPath);
//     // Uint8List videoBytes = File(videoPath).readAsBytesSync();
//
//     widget.trimmedVideoCallback(/*GalleryMedia(
//         bytes: bytes,
//         thumbnailBytes: null,
//         id: randomId(),
//         dateCreated: DateTime.now().millisecondsSinceEpoch,
//         mediaType: 2,
//         path: '')*/);
//     Get.back();
//
//     // EasyLoading.show(status: LocalizationString.loading);
//     // _trimmer.saveTrimmedVideo(
//     //     startValue: _startValue,
//     //     endValue: _endValue,
//     //     onSave: (videoPath) async {
//     //       EasyLoading.dismiss();
//     //       if (videoPath == null) {
//     //         AppUtil.showToast(
//     //             message: LocalizationString.errorMessage, isSuccess: false);
//     //       } else {
//     //         Uint8List thumbnailBytes = await getThumbnailFile(videoPath);
//     //         Uint8List videoBytes = File(videoPath).readAsBytesSync();
//     //
//     //         widget.trimmedVideoCallback(GalleryMedia(
//     //             bytes: videoBytes,
//     //             thumbnailBytes: thumbnailBytes,
//     //             id: randomId(),
//     //             dateCreated: DateTime.now().millisecondsSinceEpoch,
//     //             mediaType: 2,
//     //             path: ''));
//     //         Get.back();
//     //       }
//     //     });
//   }
//
//   void publishAction() async {
//     AppUtil.checkInternet().then((value) async {
//       // if (value) {
//       //   ApiController()
//       //       .addPostApi(descriptionText.text, uploadedThumbnailPath!,
//       //           uploadedVideoPath, tags.join(','), widget.competitionId, '2')
//       //       .then((response) async {
//       //     Navigator.of(context).pop();
//       //     postUpdatedDialog(response.message, () {
//       //       if (response.success) {
//       //         Navigator.of(context).pop();
//       //         Get.back();;
//       //       } else {
//       //         Navigator.of(context).pop();
//       //       }
//       //     });
//       //   });
//       // } else {
//       //   Navigator.of(context).pop();
//       //   AppUtil.showToast(
//       //       ApplicationLocalizations.of(context).translate('noInternet_text'),
//       //       context);
//       // }
//     });
//   }
// }
