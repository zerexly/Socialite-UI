import 'package:get/get.dart';
import 'package:foap/helper/common_import.dart';

class SetLocation extends StatefulWidget {
  const SetLocation({Key? key}) : super(key: key);

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
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
              Icons.location_on_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ).round(30),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Set your location services',
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'We use your location to show you potential matches in your area',
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
                    text: 'Set location services',
                    onPress: () {
                      Get.to(() => const AllowNotification());
                    })),
          )
        ],
      ).hP25.addGradientBackground(),
    );
  }
}
