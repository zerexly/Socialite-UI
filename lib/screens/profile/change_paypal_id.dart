import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ChangePaypalId extends StatefulWidget {
  const ChangePaypalId({Key? key}) : super(key: key);

  @override
  State<ChangePaypalId> createState() => _ChangePaypalIdState();
}

class _ChangePaypalIdState extends State<ChangePaypalId> {
  TextEditingController paypalId = TextEditingController();
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    paypalId.text = getIt<UserProfileManager>().user!.paypalId ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          profileScreensNavigationBar(
              context: context,
              title: LocalizationString.paymentDetail,
              completion: () {
                profileController.updatePaypalId(
                    paypalId: paypalId.text, context: context);
              }),

          divider(context: context).vP8,
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocalizationString.paypalId,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600)),
                  Container(
                    color: Colors.transparent,
                    height: 50,
                    child: InputField(
                      controller: paypalId,
                      showDivider: true,
                      // showBorder: true,
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleMedium,
                      hintText: 'paypalId@gmail.com',
                    ),
                  ),
                ],
              ).vP8,
            ],
          ).hP16,
        ],
      ),
    );
  }
}
