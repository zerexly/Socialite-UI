import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({Key? key}) : super(key: key);

  @override
  ChangePhoneNumberState createState() => ChangePhoneNumberState();
}

class ChangePhoneNumberState extends State<ChangePhoneNumber> {
  TextEditingController phoneNumber = TextEditingController();
  final ProfileController profileController = Get.find();

  String countryCode = "+1";

  @override
  void initState() {
    super.initState();
    phoneNumber.text = getIt<UserProfileManager>().user!.phone ?? '';
    countryCode = getIt<UserProfileManager>().user!.countryCode ?? '+1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 55,
            ),
            profileScreensNavigationBar(
                context: context,
                title: LocalizationString.changePhoneNumber,
                completion: () {
                  profileController.updateMobile(
                      countryCode: countryCode,
                      phoneNumber: phoneNumber.text,
                      context: context);
                }),
            divider(context: context).vP8,
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(LocalizationString.phoneNumber,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(
                  height: 8,
                ),
                addTextField(),
              ],
            ).hP16
          ]),
        ));
  }

  addTextField() {
    return SizedBox(
      height: 50,
      child: InputMobileNumberField(
        onChanged: (value) {},
        phoneCodeText: countryCode,
        phoneCodeValueChanged: (value) {
          countryCode = value;
          setState(() {});
        },
        controller: phoneNumber,
        showDivider: true,
        hintText: '123456789',
      ),
    ).vP8;
  }
}
