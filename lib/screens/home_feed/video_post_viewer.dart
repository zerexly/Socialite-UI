// import 'package:foap/helper/common_import.dart';
//
// class VideoPostViewer extends StatefulWidget {
//   final PostModel model;
//   final VoidCallback handler;
//
//   const VideoPostViewer({Key? key, required this.model, required this.handler})
//       : super(key: key);
//
//   @override
//   VideoPostViewerState createState() => VideoPostViewerState();
// }
//
// class VideoPostViewerState extends State<VideoPostViewer> {
//   late FlickManager flickManager;
//   late PostModel model;
//
//   @override
//   void initState() {
//     super.initState();
//     model = widget.model;
//
//     flickManager = FlickManager(
//       videoPlayerController:
//           VideoPlayerController.network(model.gallery.first.filePath),
//     );
//   }
//
//   @override
//   void dispose() {
//     flickManager.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//             backgroundColor: Colors.black,
//             centerTitle: true,
//             elevation: 0.0,
//             title: InkWell(
//                 onTap: () {
//                   Navigator.of(context).push(MaterialPageRoute(
//                       builder: (ctx) =>
//                           OtherUserProfile(userId: model.userId)));
//                 },
//                 child: Text(
//                   model.username,
//                   style: Theme.of(context).textTheme.bodyLarge.white,
//                 )),
//             leading: InkWell(
//                 onTap: () => Get.back();,
//                 child: const Icon(Icons.arrow_back_ios_rounded,
//                     color: Colors.white)),
//             actions: [
//               Padding(
//                   padding: const EdgeInsets.only(right: 20),
//                   child: InkWell(
//                     onTap: () => openReportPostPopup(),
//                     child: Center(
//                       child: Text(
//                           model.isReported
//                               ? ApplicationLocalizations.of(context)
//                                   .translate('reportedSmall_text')
//                               : ApplicationLocalizations.of(context)
//                                   .translate('reportSmall_text'),
//                           style: Theme.of(context).textTheme.bodyLarge.white),
//                     ),
//                   ))
//             ]),
//         body: Column(children: [
//           FlickVideoPlayer(flickManager: flickManager),
//           const Spacer(),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               InkWell(
//                   onTap: () => likeUnlikeApiCall(),
//                   child: Icon(model.isLike ? Icons.star : Icons.star_border,
//                       color: Colors.white, size: 25)),
//               model.totalLike > 0
//                   ? Text(
//                       '${model.totalLike} ${ApplicationLocalizations.of(context).translate('likes_text')}',
//                       style: Theme.of(context).textTheme.bodyLarge.white)
//                   : Container(),
//             ]),
//             Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//               InkWell(
//                   onTap: () => openComments(),
//                   child:
//                       const Icon(Icons.comment_outlined, color: Colors.white)),
//               InkWell(
//                 onTap: () => openComments(),
//                 child: model.totalComment > 0
//                     ? Text(
//                         '${model.totalComment} ${ApplicationLocalizations.of(context).translate('comments_text')}',
//                         style: Theme.of(context).textTheme.bodyLarge.white)
//                     : Container(),
//               )
//             ])
//           ]).p25,
//         ]));
//   }
//
//   void openReportPostPopup() {
//     if (!model.isReported) {
//       showModalBottomSheet(
//           context: context,
//           builder: (context) => Wrap(
//                 children: [
//                   Padding(
//                       padding: const EdgeInsets.only(
//                           left: 20, right: 20, top: 20, bottom: 25),
//                       child: Text(
//                           ApplicationLocalizations.of(context)
//                               .translate('reportThis_text'),
//                           style: Theme.of(context).textTheme.titleMedium.primaryColor.lightBold)),
//                   ListTile(
//                       leading: const Icon(Icons.camera_alt_outlined,
//                           color: Colors.black87),
//                       title: Text(ApplicationLocalizations.of(context)
//                           .translate('reportSmall_text')),
//                       onTap: () async {
//                         Navigator.of(context).pop();
//                         reportPostApiCall();
//                       }),
//                   ListTile(
//                       leading: const Icon(Icons.close, color: Colors.black87),
//                       title: Text(ApplicationLocalizations.of(context)
//                           .translate('cancel_text')),
//                       onTap: () => Navigator.of(context).pop()),
//                 ],
//               ));
//     }
//   }
//
//   void openComments() {
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (ctx) => CommentsScreen(
//             model: model,
//             handler: () {
//               widget.handler();
//               setState(() {});
//             })));
//   }
//
//   void likeUnlikeApiCall() {
//     model.isLike = !model.isLike;
//     model.totalLike =
//         model.isLike ? (model.totalLike) + 1 : (model.totalLike) - 1;
//
//     widget.handler();
//     setState(() {});
//
//     AppUtil.checkInternet().then((value) async {
//       if (value) {
//         ApiController()
//             .likeUnlikeApi(!model.isLike, model.id)
//             .then((response) async {});
//       } else {
//         AppUtil.showToast(
//           LocalizationString.noInternet,
//         );
//       }
//     });
//   }
//
//   void reportPostApiCall() {
//     model.isReported = true;
//     widget.handler();
//     setState(() {});
//     AppUtil.checkInternet().then((value) async {
//       if (value) {
//         EasyLoading.show(status: LocalizationString.loading);
//         ApiController().reportPostApi(model.id).then((response) async {
//           EasyLoading.dismiss();
//         });
//       } else {
//         AppUtil.showToast(
//           LocalizationString.noInternet,
//         );
//       }
//     });
//   }
// }
