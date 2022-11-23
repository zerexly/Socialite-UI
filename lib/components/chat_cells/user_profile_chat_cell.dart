import 'package:foap/helper/common_import.dart';

class UserProfileChatTile extends StatelessWidget {
  final ChatMessageModel message;

  const UserProfileChatTile({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 65,
        width: double.infinity,
        child: Container(
                color: message.isMineMessage
                    ? Theme.of(context).disabledColor.withOpacity(0.2)
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AvatarView(
                      url: message.profileContent.userPicture,
                      name: message.profileContent.userName,
                      size: 40,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message.profileContent.userName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          message.profileContent.location,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    const ThemeIconWidget(ThemeIcon.nextArrow),
                  ],
                ).hP8)
            .round(15));
  }

  // Future<UserModel?> getUserDetail(int userId) async {
  //   UserModel? user;
  //   await ApiController().getOtherUser(userId.toString()).then((value) {
  //     user = value.user;
  //   });
  //
  //   return user;
  // }
}

// class UserProfileChatTile extends StatelessWidget {
//   final ChatMessageModel message;
//
//   const UserProfileChatTile({Key? key, required this.message})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 65,
//         width: double.infinity,
//         child: Container(
//           color: message.isMineMessage
//               ? Theme.of(context).disabledColor.withOpacity(0.2)
//               : Theme.of(context).primaryColor.withOpacity(0.2),
//           child: FutureBuilder<UserModel?>(
//               future: getUserDetail(message.profileContent.userId),
//               builder:
//                   (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
//                 if (snapshot.hasData) {
//                   return snapshot.data == null
//                       ? Center(
//                           child: Text(LocalizationString.userDeleted,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .titleMedium!
//                                   .copyWith(
//                                       color: Theme.of(context).primaryColor,
//                                       fontWeight: FontWeight.w900)),
//                         )
//                       : Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Row(
//                               children: [
//                                 AvatarView(
//                                   url: snapshot.data!.picture,
//                                   name: snapshot.data!.userName,
//                                   size: 40,
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       snapshot.data!.userName,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleLarge!
//                                           .copyWith(
//                                               fontWeight: FontWeight.w600),
//                                     ),
//                                     snapshot.data!.country != null
//                                         ? Text(
//                                             '${snapshot.data!.country},${snapshot.data!.city}',
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .bodyMedium,
//                                           )
//                                         : Container(),
//                                   ],
//                                 ),
//                               ],
//                             ).hP8,
//                             // const SizedBox(
//                             //   height: 20,
//                             // ),
//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.center,
//                             //   children: [
//                             //     SizedBox(
//                             //       width: 80,
//                             //       child: Column(
//                             //         crossAxisAlignment:
//                             //             CrossAxisAlignment.center,
//                             //         children: [
//                             //           Text(
//                             //             snapshot.data!.totalPost.toString(),
//                             //             style: Theme.of(context)
//                             //                 .textTheme
//                             //                 .titleLarge!
//                             //                 .copyWith(
//                             //                     fontWeight: FontWeight.w600),
//                             //           ).bP8,
//                             //           Text(
//                             //             LocalizationString.posts,
//                             //             style: Theme.of(context)
//                             //                 .textTheme
//                             //                 .titleSmall,
//                             //           ),
//                             //         ],
//                             //       ),
//                             //     ),
//                             //     const Spacer(),
//                             //     SizedBox(
//                             //       width: 80,
//                             //       child: Column(
//                             //         crossAxisAlignment:
//                             //             CrossAxisAlignment.center,
//                             //         children: [
//                             //           Text(
//                             //             '${snapshot.data!.totalFollower}',
//                             //             style: Theme.of(context)
//                             //                 .textTheme
//                             //                 .titleLarge!
//                             //                 .copyWith(
//                             //                     fontWeight: FontWeight.w600),
//                             //           ).bP8,
//                             //           Text(
//                             //             LocalizationString.followers,
//                             //             style: Theme.of(context)
//                             //                 .textTheme
//                             //                 .titleSmall,
//                             //           ),
//                             //         ],
//                             //       ),
//                             //     ),
//                             //     const Spacer(),
//                             //     SizedBox(
//                             //       width: 80,
//                             //       child: Column(
//                             //         crossAxisAlignment:
//                             //             CrossAxisAlignment.center,
//                             //         children: [
//                             //           Text(
//                             //             '${snapshot.data!.totalFollowing}',
//                             //             style: Theme.of(context)
//                             //                 .textTheme
//                             //                 .titleLarge!
//                             //                 .copyWith(
//                             //                     fontWeight: FontWeight.w600),
//                             //           ).bP8,
//                             //           Text(
//                             //             LocalizationString.following,
//                             //             style: Theme.of(context)
//                             //                 .textTheme
//                             //                 .titleSmall,
//                             //           ),
//                             //         ],
//                             //       ),
//                             //     )
//                             //   ],
//                             // ).hP16,
//                             // const SizedBox(
//                             //   height: 20,
//                             // ),
//                             // FilledButtonType1(
//                             //     text: LocalizationString.viewProfile,
//                             //     onPress: () {}).hP16
//                           ],
//                         );
//                 } else {
//                   if (snapshot.data == null &&
//                       snapshot.connectionState == ConnectionState.done) {
//                     return Center(
//                       child: Text(
//                         LocalizationString.postDeleted,
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayMedium!
//                             .copyWith(
//                                 color: Theme.of(context).primaryColor,
//                                 fontWeight: FontWeight.w900),
//                       ),
//                     );
//                   } else {
//                     return AppUtil.addProgressIndicator(context);
//                   }
//                 }
//               }),
//         ).round(15));
//   }
//
//   Future<UserModel?> getUserDetail(int userId) async {
//     UserModel? user;
//     await ApiController().getOtherUser(userId.toString()).then((value) {
//       user = value.user;
//     });
//
//     return user;
//   }
// }
