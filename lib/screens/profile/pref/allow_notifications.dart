import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class AllowNotification extends StatefulWidget {
  const AllowNotification({Key? key}) : super(key: key);

  @override
  State<AllowNotification> createState() => _AllowNotificationState();
}

class _AllowNotificationState extends State<AllowNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            color: Theme.of(context).cardColor,
            child: ThemeIconWidget(ThemeIcon.notification,
                color: Theme.of(context).primaryColor),
          ).round(30),
          Text(
            LocalizationString.notificationHeader,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600),
          ).setPadding(top: 40),
          Text(
            LocalizationString.notificationSubHeader,
            style: Theme.of(context).textTheme.titleSmall,
          ).setPadding(top: 20),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    cornerRadius: 25,
                    text: LocalizationString.allowNotification,
                    onPress: () {
                      Get.to(() => const AddName());
                    })),
          ).setPadding(top: 150),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    enabledTextStyle:
                        Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                    cornerRadius: 25,
                    text: LocalizationString.notNow,
                    onPress: () {
                      Get.to(() => const AddName());
                    })),
          ).setPadding(top: 20),
        ],
      ).hP25,
    );
  }
}
