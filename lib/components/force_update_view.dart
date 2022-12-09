import 'package:foap/helper/common_import.dart';
import 'package:get/get.dart';

class ForceUpdateView extends StatelessWidget {
  ForceUpdateView({Key? key}) : super(key: key);
  SettingsController settingsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Expanded(
              child: Image.asset(
            'assets/force_update.png',
            fit: BoxFit.contain,
          ).p25),
          Text(
            LocalizationString.timeToUpdateApp.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ).hP25,
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Text(
            LocalizationString.usingOlderVersionMessage,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ).hP25,
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          SizedBox(
            height: 50,
            width: 280,
            child: FilledButtonType1(
              cornerRadius: 25,
              text: LocalizationString.update,
              onPress: () async {
                await launchUrl(
                    Uri.parse(settingsController.setting.value!.latestAppDownloadLink!));
              },
              enabledBackgroundColor: const Color(0xff512e98),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ],
      )),
    );
  }
}

class InvalidPurchaseView extends StatelessWidget {
  const InvalidPurchaseView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Expanded(
                child: Image.asset(
              'assets/force_update.png',
              fit: BoxFit.contain,
            ).p25),
            Text(
              'Invalid purchase code'.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ).hP25,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              'Please buy the original code from codecanyon.net to use this app',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ).hP25,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            SizedBox(
              height: 50,
              width: 280,
              child: FilledButtonType1(
                cornerRadius: 25,
                text: LocalizationString.ok,
                onPress: () async {
                  await launchUrl(Uri.parse(
                      'https://codecanyon.net/item/timeline-chat-calling-live-social-media-photo-video-sharing-app-iosandroidadmin-panel/39825646'));
                },
                enabledBackgroundColor: const Color(0xff512e98),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ],
        )),
      ),
    );
  }
}
