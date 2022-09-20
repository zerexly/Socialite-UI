// import 'package:foap/helper/common_import.dart';
//
// class FindFriendsOptions extends StatefulWidget {
//   const FindFriendsOptions({Key? key}) : super(key: key);
//
//   @override
//   FindFriendsOptionsState createState() => FindFriendsOptionsState();
// }
//
// class FindFriendsOptionsState extends State<FindFriendsOptions> {
//   TextEditingController phoneNumber = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController userName = TextEditingController();
//
//   String phoneCode = '+1';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           centerTitle: true,
//           elevation: 0.0,
//           automaticallyImplyLeading: false,
//           title:
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             InkWell(
//                 onTap: () => Get.back();,
//                 child:
//                     Icon(Icons.arrow_back_ios, color: AppTheme.iconColor)),
//             Center(
//                 child: Text(
//               LocalizationString.findFriends,
//               style: Theme.of(context).textTheme.titleMedium.primaryColor,
//             )),
//             Container()
//           ])),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             inputNumberWidget(),
//             inputEmailWidget(),
//             inputUserNameWidget()
//           ],
//         ).hP16,
//       ),
//     );
//   }
//
//   Widget inputNumberWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Text(
//           'Find by Phone Number',
//           style: Theme.of(context).textTheme.bodyLarge.bold.primaryColor,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.6,
//               child: InputMobileNumberField(
//                   controller: phoneNumber,
//                   phoneCodeText: phoneCode,
//                   onChanged: (phone) {},
//                   showBorder: true,
//                   cornerRadius: 5,
//                   phoneCodeValueChanged: (code) {
//                     phoneCode = code;
//                     setState(() {});
//                   }),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               height: 45,
//               width: MediaQuery.of(context).size.width * 0.25,
//               child: FilledButtonType1(
//                 isEnabled: true,
//                 text:
//                     LocalizationString.find,
//                 onPress: () {
//                   findUserBy(1, '$phoneCode${phoneNumber.text}');
//                 },
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget inputEmailWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Text(
//           'Find by email',
//           style: Theme.of(context).textTheme.bodyLarge.bold.primaryColor,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.6,
//               child: InputField(
//                 controller: email,
//                 onChanged: (phone) {},
//                 showBorder: true,
//                 cornerRadius: 5,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               height: 45,
//               width: MediaQuery.of(context).size.width * 0.25,
//               child: FilledButtonType1(
//                 isEnabled: true,
//                 text:
//                     LocalizationString.find,
//                 onPress: () {
//                   findUserBy(2, email.text);
//                 },
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget inputUserNameWidget() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         Text(
//           'Find by user name',
//           style: Theme.of(context).textTheme.bodyLarge.bold.primaryColor,
//         ),
//         const SizedBox(
//           height: 10,
//         ),
//         Row(
//           children: [
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.6,
//               child: InputField(
//                 controller: userName,
//                 onChanged: (phone) {},
//                 showBorder: true,
//                 cornerRadius: 5,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               height: 45,
//               width: MediaQuery.of(context).size.width * 0.25,
//               child: FilledButtonType1(
//                 isEnabled: true,
//                 text:
//                     LocalizationString.find,
//                 onPress: () {
//                   findUserBy(3, userName.text);
//                 },
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }
//
//   findUserBy(int type, String value) {
//     EasyLoading.show(status: LocalizationString.loading);
//     ApiController().findFriends(type:type, value:value).then((response) {
//       EasyLoading.dismiss();
//
//       if (response.users.isNotEmpty) {
//         Get.to(() => UsersList(usersList:
//                   response.users,
//                 ));
//       } else {
//         AppUtil.showToast(message:LocalizationString.noData,isSuccess: false);
//       }
//     });
//   }
// }
