// import 'package:foap/helper/common_import.dart';
//
//
// class SupportRequests extends StatefulWidget {
//   const SupportRequests({Key? key}) : super(key: key);
//
//   @override
//   _SupportRequestsState createState() => _SupportRequestsState();
// }
//
// class _SupportRequestsState extends State<SupportRequests> {
//   List<SupportRequestModel> requests = [];
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     getSupportRequests();
//     super.initState();
//   }
//
//   getSupportRequests() {
//     ApiController().getSupportMessagesApi().then((result) {
//       isLoading = false;
//       requests = result.supportMessages;
//       // Navigator.of(context).pop();
//       setState(() {});
//     });
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
//                       Navigator.of(context).pop();
//                     }),
//                     Text(
//                       LocalizationString.supportRequests,
//                       style: Theme.of(context).textTheme.titleMedium.bold.primaryColor,
//                     ),
//                     const SizedBox(
//                       width: 20,
//                     )
//                   ],
//                 ).hP16,
//                 const divider(context: context),
//                 Expanded(
//                   child: ListView.separated(
//                       padding: const EdgeInsets.only(top: 20),
//                       itemCount: requests.length,
//                       itemBuilder: (ctx, index) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     requests[index].name,
//                                     style: Theme.of(context).textTheme.titleMedium.primaryColor.bold,
//                                   ),
//                                 ),
//                                 Text(
//                                   'Request sent on ${requests[index].requestSentDate()}',
//                                   style:
//                                       Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               requests[index].message,
//                               style: Theme.of(context).textTheme.bodyMedium,
//                             ),
//                           ],
//                         )
//                             .p16
//                             .borderWithRadius(value: 0.5, radius: 5)
//                             .ripple(() {
//                           Get.to(() =>
//                                   RequestDetail(request: requests[index]));
//                         });
//                       },
//                       separatorBuilder: (ctx, index) {
//                         return const SizedBox(
//                           height: 20,
//                         );
//                       }).hP16,
//                 ),
//                 SizedBox(
//                   height: 60,
//                   child: FilledButtonType1(
//                     isEnabled: true,
//                     enabledTextStyle:
//                         Theme.of(context).textTheme.titleSmall.bold,
//                     text: 'New request',
//                     onPress: () {
//                       Get.to(() => const CreateSupportRequest());
//                     },
//                   ),
//                 ).hP16,
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//     );
//   }
// }
