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
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            color: Colors.white,
            child: Icon(
              Icons.notifications,
              color: Theme.of(context).primaryColor,
            ),
          ).round(30),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Allow notifications',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'We\'ll let you know when you get new matches and messages',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 150,
          ),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    enabledTextStyle: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor),
                    enabledBackgroundColor: Colors.white,
                    cornerRadius: 25,
                    text: 'Allow notifications',
                    onPress: () {
                      Get.to(()=> const AddName());
                    })),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: FilledButtonType1(
                    enabledTextStyle:
                        Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                    // enabledBackgroundColor: Colors.white,
                    cornerRadius: 25,
                    text: 'Not now',
                    onPress: () {
                      Get.to(()=> const AddName());
                    })),
          )
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
