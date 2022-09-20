// import 'package:foap/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class ManagePhotos extends StatefulWidget {
//   const ManagePhotos({Key? key}) : super(key: key);
//
//   @override
//   ManagePhotosState createState() => ManagePhotosState();
// }
//
// class ManagePhotosState extends State<ManagePhotos> {
//   List<PostModel> explorePosts = [];
//   bool isLoading = true;
//   int selectedSegment = 0;
//   UserModel? model;
//
//   @override
//   void initState() {
//     super.initState();
//     model = getIt<UserProfileManager>().user;
//
//     getMyPosts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.primaryBackgroundColor,
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(
//                   backgroundColor: Colors.black12,
//                   valueColor:
//                       AlwaysStoppedAnimation<Color>(AppTheme.themeColor)),
//             )
//           : Column(
//               children: [
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const ThemeIconWidget(
//                       ThemeIcon.backArrow,
//                       size: 20,
//                     ).ripple(() {
//                       Get.back();
//                     }),
//                     Text(
//                       LocalizationString.photos,
//                       style: Theme.of(context).textTheme.titleMedium.bold.primaryColor,
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     )
//                   ],
//                 ).hP16,
//                 const divider(context: context),
//                 addProfileView(),
//                 Expanded(child: addPhotoGrid())
//               ],
//             ),
//     );
//   }
//
//   addProfileView() {
//     return SizedBox(
//       height: 150,
//       child: Column(children: [
//         Container(
//           child: CircleAvatar(
//             radius: 32,
//             backgroundColor: AppTheme.themeColor,
//             child: model == null || model?.picture == null
//                 ? const Icon(Icons.person, color: Colors.white, size: 30)
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(32.0),
//                     child: CachedNetworkImage(
//                       imageUrl: model!.picture!,
//                       fit: BoxFit.cover,
//                       height: 64.0,
//                       width: 64.0,
//                       placeholder: (context, url) =>
//                           AppUtil.addProgressIndicator(context),
//                       errorWidget: (context, url, error) =>
//                           const Icon(Icons.error),
//                     )),
//           ).p4,
//         ).borderWithRadius(value: 2, radius: 40, color: AppTheme.themeColor),
//         const SizedBox(
//           height: 10,
//         ),
//         Text(
//           model?.userName ?? '',
//           style: Theme.of(context).textTheme.titleMedium.semiBold.primaryColor,
//         ).bP4,
//         model?.email != null
//             ? Text(
//                 '${model?.email}',
//                 style: Theme.of(context).textTheme.titleMedium.primaryColor,
//               )
//             : Text(
//                 '${model?.country ?? ''},${model?.city ?? ''}',
//                 style: Theme.of(context).textTheme.titleMedium.primaryColor,
//               ),
//       ]).p8,
//     );
//   }
//
//   addPhotoGrid() {
//     return MasonryGridView.count(
//       padding: EdgeInsets.zero,
//       shrinkWrap: true,
//       crossAxisCount: 3,
//       itemCount: explorePosts.length,
//       // physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (BuildContext context, int index) =>
//           explorePosts[index].gallery.first.isVideoPost() == true
//               ? InkWell(
//                   onTap: () async {
//                     // MaterialPageRoute(
//                     //     builder: (ctx) => VideoPostViewer(
//                     //           model: explorePosts[index],
//                     //           handler: () {
//                     //             setState(() {});
//                     //           },
//                     //         ));
//                   },
//                   child: Stack(children: [
//                     AspectRatio(
//                         aspectRatio: 1,
//                         child: CachedNetworkImage(
//                           imageUrl:
//                               explorePosts[index].gallery.first.videoThumbnail!,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) =>
//                               AppUtil.addProgressIndicator(context),
//                           errorWidget: (context, url, error) => const Icon(
//                             Icons.error,
//                           ),
//                         ).round(10)),
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       top: 0,
//                       bottom: 0,
//                       child: ThemeIconWidget(
//                         ThemeIcon.videoPost,
//                         size: 50,
//                         color: AppTheme.iconColor,
//                       ),
//                     )
//                   ]),
//                 )
//               : InkWell(
//                   onTap: () async {
//                     File path = await AppUtil.findPath(
//                         explorePosts[index].gallery.first.filePath);
//                     MaterialPageRoute(
//                         builder: (ctx) => EnlargeImageViewScreen(
//                               model: explorePosts[index],
//                               file: path,
//                               handler: () {},
//                             ));
//                   },
//                   child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 1.0, color: Colors.grey),
//                       ),
//                       child: Stack(children: [
//                         SizedBox(
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.width / 3,
//                             child: CachedNetworkImage(
//                               imageUrl:
//                                   explorePosts[index].gallery.first.filePath,
//                               fit: BoxFit.cover,
//                               placeholder: (context, url) =>
//                                   AppUtil.addProgressIndicator(context),
//                               errorWidget: (context, url, error) =>
//                                   const Icon(Icons.error),
//                             )),
//                       ])),
//                 ),
//       mainAxisSpacing: 4.0,
//       crossAxisSpacing: 4.0,
//     );
//   }
//
//   void getMyPosts() {
//     explorePosts = [];
//     setState(() {});
//     AppUtil.checkInternet().then((value) {
//       if (value) {
//         ApiController()
//             .getPostsApi(
//                 userId: null,
//                 isPopular: 0,
//                 isSold: 0,
//                 isRecent: 0,
//                 isMine: 1,
//                 title: '')
//             .then((response) async {
//           explorePosts = response.success ? response.posts : [];
//           explorePosts = response.success
//               ? response.posts
//                   .where((element) => element.gallery.isNotEmpty)
//                   .toList()
//               : [];
//           isLoading = false;
//           setState(() {});
//         });
//       }
//     });
//   }
// }
