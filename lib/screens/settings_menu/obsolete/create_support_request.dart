// import 'package:foap/helper/common_import.dart';
// import 'package:get/get.dart';
//
// class CreateSupportRequest extends StatefulWidget {
//   const CreateSupportRequest({Key? key}) : super(key: key);
//
//   @override
//   _CreateSupportRequestState createState() => _CreateSupportRequestState();
// }
//
// class _CreateSupportRequestState extends State<CreateSupportRequest> {
//   TextEditingController nameTf = TextEditingController();
//   TextEditingController emailTf = TextEditingController();
//   TextEditingController phoneTf = TextEditingController();
//   TextEditingController messageTf = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: Column(
//           children: [
//             const SizedBox(
//               height: 50,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const ThemeIconWidget(
//                   ThemeIcon.backArrow,
//                   size: 20,
//                 ).ripple(() {
//                   Get.back();
//                 }),
//                 Text(
//                   LocalizationString.createSupportRequest,
//                   style: Theme.of(context).textTheme.titleMedium!
//                       .copyWith(fontWeight: FontWeight.w900,color: Theme.of(context).backgroundColor),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 )
//               ],
//             ).hP16,
//             const divider(context: context),
//             const SizedBox(
//               height: 20,
//             ),
//             addTextField(nameTf, 'Jacob', 1),
//             addTextField(emailTf, 'lacob@gmail.com', 1),
//             addTextField(phoneTf, '+1(123)456789', 1),
//             addTextField(messageTf, 'Enter your message here', 10),
//             SizedBox(
//               height: 60,
//               child: FilledButtonType1(
//                 isEnabled: true,
//                 enabledTextStyle: Theme.of(context).textTheme.titleSmall!
//                     .copyWith(fontWeight: FontWeight.w900),
//                 text: 'Submit',
//                 onPress: () {
//                   validateFormAndSubmit();
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         ).hP16);
//   }
//
//   addTextField(
//       TextEditingController controller, String hintText, int maxlines) {
//     return Container(
//       color: Colors.transparent,
//       child: InputField(
//         controller: controller,
//         // showBorder: true,
//         textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).backgroundColor),
//         hintText: hintText,
//         maxLines: maxlines,
//         showDivider: true,
//         cornerRadius: 5,
//       ),
//     );
//   }
//
//   void validateFormAndSubmit() {
//     if (FormValidator().isTextEmpty(nameTf.text)) {
//       AppUtil.showToast(
//           message: LocalizationString.pleaseEnterName, isSuccess: false);
//     } else if (FormValidator().isTextEmpty(emailTf.text)) {
//       AppUtil.showToast(
//           message: LocalizationString.pleaseEnterEmail, isSuccess: false);
//     } else if (FormValidator().isTextEmpty(phoneTf.text)) {
//       AppUtil.showToast(
//           message: LocalizationString.pleaseEnterPhone, isSuccess: false);
//     } else if (FormValidator().isTextEmpty(messageTf.text)) {
//       AppUtil.showToast(
//           message: LocalizationString.pleaseEnterMessage, isSuccess: false);
//     } else {
//       AppUtil.checkInternet().then((value) {
//         if (value) {
//           EasyLoading.show(status: LocalizationString.loading);
//           ApiController()
//               .sendSupportRequest(
//                   nameTf.text, emailTf.text, phoneTf.text, messageTf.text)
//               .then((response) async {
//             EasyLoading.dismiss();
//             if (response.success) {
//               AppUtil.showToast(
//                   message: LocalizationString.requestSent, isSuccess: true);
//               Timer(const Duration(seconds: 2), () {
//                 Get.back();
//               });
//             } else {
//               AppUtil.showToast(message: response.message, isSuccess: false);
//             }
//           });
//         } else {
//           AppUtil.showToast(message:LocalizationString.noInternet, isSuccess: false);
//         }
//       });
//     }
//   }
// }
