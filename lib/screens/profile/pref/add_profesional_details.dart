import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class AddProfessionalDetails extends StatefulWidget {
  const AddProfessionalDetails({Key? key}) : super(key: key);

  @override
  State<AddProfessionalDetails> createState() => AddProfessionalDetailsState();
}

class AddProfessionalDetailsState extends State<AddProfessionalDetails> {
  int smoke = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              LocalizationString.addProfessionalHeader,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w600),
            ).paddingOnly(top: 100),
            addHeader('Qualification').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                // controller: _requestVerificationController
                //     .messageTf.value,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            addHeader('Occupation').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                // controller: _requestVerificationController
                //     .messageTf.value,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            addHeader('Work industry').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                // controller: _requestVerificationController
                //     .messageTf.value,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            addHeader('Work experience').paddingOnly(top: 30, bottom: 8),
            InputField(
                hintText: 'Add',
                // controller: _requestVerificationController
                //     .messageTf.value,
                showBorder: true,
                borderColor: Theme.of(context).disabledColor,
                cornerRadius: 10),
            Center(
              child: SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 50,
                  child: FilledButtonType1(
                      cornerRadius: 25,
                      text: LocalizationString.send,
                      onPress: () {
                        //Hit Api
                      })),
            ).paddingOnly(top: 100),
          ],
        ).paddingAll(25),
      ),
    );
  }

  Text addHeader(String header) {
    return Text(
      header,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.w500),
    );
  }
}

// {
// "username":"username2",
// "email":"user42@gmail.com",
// "bio":"dio info",
// "description":"hello msyfsjf",
// "country":"india",
// "city":"mohali",
// "sex":"1",
// "dob":"1988-05-20",
// "is_biometric_login":"1",
// "state":"Punjab",
// "interest_id":"1,2",
// "height":"173",
// "color":"fair",
// "religion":"Hindu",
// "marital_status":"2",
// "language_id":"7,2",
// "smoke_id":"2",
// "drinking_habit":"1",
// "qualification":"12",
// "occupation":"Software",
// "profile_category_type":"2",
// "work_experience_month":"9",
// "work_experience_year":"6",
// "state_id":"23",
// "city_id":"2"
//
// }
