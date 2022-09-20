// import 'package:foap/helper/common_import.dart';
//
// class TrendingHashtags extends StatefulWidget {
//   const TrendingHashtags({Key? key}) : super(key: key);
//
//   @override
//   _TrendingHashtagsState createState() => _TrendingHashtagsState();
// }
//
// class _TrendingHashtagsState extends State<TrendingHashtags> {
//   List<NewsModel> allNews =
//       NewsModel.dummyData().map((e) => NewsModel.fromJson(e)).toList();
//
//   List<Hashtag> hashTags =
//   Hashtag.dummyData().map((e) => Hashtag.fromJson(e)).toList();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppTheme().secondaryBackgroundColor,
//         body: CustomScrollView(
//           slivers: [
//             SliverList(
//                 delegate: SliverChildListDelegate([
//               Row(
//                 children: [
//                   ThemeIconWidget(
//                     ThemeIcon.backArrow,
//                     color: AppTheme().iconColor,
//                     size: 30,
//                   ).goBack(),
//                   Expanded(
//                     child: SearchBarType3(
//                         showSearchIocn: true,
//                         iconColor: AppTheme().themeColor,
//                         onSearchCompleted: (searchTerm) {}),
//                   ),
//                 ],
//               ).setPadding(left: 16, right: 16, top: 25, bottom: 20),
//               // category view
//               divider(height: 0.5),
//
//               trendingHashTagsSection(),
//             ]))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget trendingHashTagsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           LocalizationString.trendingAtTwitter,
//           style: Theme.of(context).textTheme.bodyLarge.semiBold,
//         ).bP16,
//         for (int i = 0; i < hashTags.length; i++)
//           Row(
//             children: [
//               Container(
//                   color: AppTheme().themeColor,
//                   height: 25,
//                   width: 25,
//                   child: Center(
//                     child: Text(
//                       '$i',
//                       style: Theme.of(context).textTheme.bodyMedium.lightTitleColor,
//                     ),
//                   )).circular,
//               const SizedBox(
//                 width: 10,
//               ),
//               Text(hashTags[i].name, style: Theme.of(context)
//     .textTheme
//     .bodyMedium!
//     .copyWith(
//         fontWeight: FontWeight.w600,
//         ))
//             ],
//           ).vP8
//       ],
//     ).p16.goTo(const TrendingOnTwitter());
//   }
// }
