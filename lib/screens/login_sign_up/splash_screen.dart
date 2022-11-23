import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool haveBiometricLogin = false;
  var localAuth = LocalAuthentication();
  RxInt bioMetricType = 0.obs;
  List<String> bgImages = [
    'assets/tutorial1.jpg',
    'assets/tutorial2.jpg',
    'assets/tutorial3.jpg',
    'assets/tutorial4.jpg'
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Get.offAll(() => const LoadingScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            CarouselSlider(
              items: [
                for (String image in bgImages)
                  Image.asset(
                    image,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  )
              ],
              options: CarouselOptions(
                autoPlayInterval: const Duration(seconds: 1),
                autoPlay: true,
                enlargeCenterPage: false,
                enableInfiniteScroll: true,
                height: double.infinity,
                viewportFraction: 1,
                onPageChanged: (index, reason) {},
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: const [
                    0.1,
                    0.3,
                    0.6,
                    0.9,
                  ],
                  colors: [
                    Theme.of(context).backgroundColor.withOpacity(0.9),
                    Theme.of(context)
                        .backgroundColor
                        .lighten()
                        .withOpacity(0.9),
                    Theme.of(context)
                        .backgroundColor
                        .lighten()
                        .withOpacity(0.5),
                    Theme.of(context).primaryColor.withOpacity(0.5),
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/spash_logo.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppConfigConstants.appName,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    AppConfigConstants.appTagline.tr,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ).bp(200),
            ),
          ],
        ));
  }
}
