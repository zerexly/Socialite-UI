// import 'package:foap/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class RequestDetail extends StatefulWidget {
//   final SupportRequestModel request;
//
//   const RequestDetail({Key? key, required this.request}) : super(key: key);
//
//   @override
//   _RequestDetailState createState() => _RequestDetailState();
// }
//
// class _RequestDetailState extends State<RequestDetail> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 50,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const ThemeIconWidget(
//                 ThemeIcon.backArrow,
//                 size: 20,
//               ).ripple(() {
//                 Get.back();
//               }),
//               Text(
//                 LocalizationString.supportRequests,
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium!
//                     .copyWith(fontWeight: FontWeight.w900,color: Theme.of(context).backgroundColor)
//                     ,
//               ),
//               const SizedBox(
//                 width: 20,
//               )
//             ],
//           ).hP16,
//           const divider(context: context),
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       height: 1,
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       color: Theme.of(context).dividerColor,
//                     ),
//                     const Spacer(),
//                     Text(
//                       'Your Message',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(fontWeight: FontWeight.w900),
//                     ).hP8,
//                     const Spacer(),
//                     Container(
//                       height: 1,
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       color: Theme.of(context).dividerColor,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       widget.request.requestSentDate(),
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyLarge!
//                           .copyWith(fontWeight: FontWeight.w900),
//                     )),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   widget.request.message,
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyLarge
//                       !.copyWith(,color: Theme.of(context).backgroundColor)
//                       .lightBold,
//                 ),
//                 widget.request.reply == null
//                     ? Container()
//                     : Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(
//                             height: 40,
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 height: 1,
//                                 width: MediaQuery.of(context).size.width * 0.3,
//                                 color: Theme.of(context).dividerColor,
//                               ),
//                               const Spacer(),
//                               Text(
//                                 'Reply',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge!
//                                     .copyWith(fontWeight: FontWeight.w900),
//                               ).hP8,
//                               const Spacer(),
//                               Container(
//                                 height: 1,
//                                 width: MediaQuery.of(context).size.width * 0.3,
//                                 color: Theme.of(context).dividerColor,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 widget.request.requestSentDate(),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyLarge!
//                                     .copyWith(fontWeight: FontWeight.w900),
//                               )),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             widget.request.reply!,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyLarge
//                                 !.copyWith(,color: Theme.of(context).backgroundColor),
//                           ),
//                         ],
//                       ),
//               ],
//             ).hP16,
//           )
//         ],
//       ),
//     );
//   }
// }
