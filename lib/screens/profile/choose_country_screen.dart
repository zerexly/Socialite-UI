// import 'package:flutter/material.dart';
// import 'package:foap/apiHandler/api_controller.dart';
// import 'package:foap/model/country_model.dart';
// import 'package:foap/util/app_util.dart';
// import 'package:foap/util/colors_util.dart';
// import 'package:foap/util/navigation_service.dart';
//
// import '../../application_localizations.dart';
//
// class ChooseCountryScreen extends StatefulWidget {
//   final bool isCountryView;
//   final Function(String) handler;
//   ChooseCountryScreen(this.isCountryView, this.handler);
//
//   @override
//   ChooseCountryState createState() => ChooseCountryState();
// }
//
// class ChooseCountryState extends State<ChooseCountryScreen> {
//   List<CountryModel> countries = [];
//
//   @override
//   void initState() {
//     super.initState();
//     AppUtil.checkInternet().then((value) {
//       if (value) {
//         ApiController().getAllCountriesList().then((value) {
//           if (value.success) {
//             setState(() {
//               countries = value.countries;
//             });
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//             backgroundColor: Colors.white,
//             centerTitle: true,
//             elevation: 4.0,
//             title: Text(
//               widget.isCountryView
//                   ? ApplicationLocalizations.of(context)
//                       .translate('chooseCountry_text')
//                   : ApplicationLocalizations.of(context)
//                       .translate('chooseCountryCode_text'),
//               style: TextStyle(color: Colors.black, fontSize: 18),
//             ),
//             leading: InkWell(
//                 onTap: () => Get.back();,
//                 child:
//                     Icon(Icons.arrow_back_ios_rounded, color: Colors.black))),
//         body: ListView.builder(
//             itemCount: countries.length,
//             itemBuilder: (BuildContext context, int index) {
//               return InkWell(
//                 onTap: () {
//                   widget.handler(widget.isCountryView
//                       ? countries[index].name
//                       : countries[index].phoneCode);
//                   Get.back();;
//                 },
//                 child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(
//                       children: [
//                         Container(
//                             height: 60,
//                             child: Center(
//                                 child: Text(
//                                     widget.isCountryView
//                                         ? countries[index].name
//                                         : countries[index].phoneCode +
//                                             ' (${countries[index].name})',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w400,
//                                         fontSize: 16)))),
//                         Container(
//                           height: 1,
//                           color: ColorsUtil.separatorLightColor,
//                         )
//                       ],
//                     )),
//               );
//             }));
//   }
// }
