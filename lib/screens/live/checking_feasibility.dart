import 'package:foap/helper/common_import.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:get/get.dart';

class CheckingLiveFeasibility extends StatefulWidget {
  const CheckingLiveFeasibility({Key? key}) : super(key: key);

  @override
  State<CheckingLiveFeasibility> createState() =>
      _CheckingLiveFeasibilityState();
}

class _CheckingLiveFeasibilityState extends State<CheckingLiveFeasibility> {
  final AgoraLiveController _agoraLiveController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _agoraLiveController.clear();
    super.dispose();
  }

  openSettingAppForAccess() {
    _agoraLiveController.checkFeasibilityToLive(
        context: context, isOpenSettings: true);
  }

  @override
  Widget build(BuildContext context) {
    _agoraLiveController.checkFeasibilityToLive(
        context: context, isOpenSettings: false);

    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Stack(
          children: [
            const rtc_local_view.SurfaceView(),
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Obx(() => _agoraLiveController.canLive.value == 0
                    ? Center(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              LocalizationString.checkingConnection,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.w900),
                              colors: colorizeColors,
                            ),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {},
                        ),
                      )
                    : _agoraLiveController.canLive.value == -1
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                color: Theme.of(context)
                                    .errorColor
                                    .withOpacity(0.5),
                                child: const ThemeIconWidget(
                                  ThemeIcon.camera,
                                  size: 100,
                                ),
                              ).circular,
                              const SizedBox(
                                height: 150,
                              ),
                              Text(
                                _agoraLiveController.errorMessage!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: FilledButtonType1(
                                  text: LocalizationString.allow,
                                  onPress: () {
                                    openAppSettings();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 200,
                                height: 45,
                                child: Center(
                                  child: Text(
                                    LocalizationString.back,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ).ripple(() {
                                Get.back();
                              })
                            ],
                          ).hP16
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(width: 20.0, height: 100.0),
                              Text(
                                LocalizationString.goingLive,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              const SizedBox(width: 20.0, height: 100.0),
                              DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(fontWeight: FontWeight.w700),
                                child: AnimatedTextKit(
                                  pause: const Duration(milliseconds: 10),
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    RotateAnimatedText('3',
                                        duration: const Duration(seconds: 1),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w200)),
                                    RotateAnimatedText('2',
                                        duration: const Duration(seconds: 1),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w200)),
                                    RotateAnimatedText('1',
                                        duration: const Duration(seconds: 1),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w200)),
                                    RotateAnimatedText(LocalizationString.go,
                                        duration: const Duration(seconds: 1),
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w200)),
                                  ],
                                  onTap: () {},
                                  onFinished: () {
                                    goToLive();
                                  },
                                ),
                              ),
                            ],
                          ))),
          ],
        ),
      ),
    );
  }

  goToLive() {
    _agoraLiveController.initializeLive();
  }
}
