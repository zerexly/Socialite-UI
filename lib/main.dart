import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:foap/helper/common_import.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foap/manager/notification_manager.dart';
import 'package:get/get.dart';
import 'package:giphy_get/l10n.dart';
import 'package:easy_localization/easy_localization.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  // await CustomGalleryPermissions.requestPermissionExtend();

  final firebaseMessaging = FCM();
  firebaseMessaging.setNotifications();
  String? token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  if (token != null) {
    SharedPrefs().setVoipToken(token);
  }

  bool isDarkTheme = await SharedPrefs().isDarkMode();
  Get.changeThemeMode(isDarkTheme ? ThemeMode.dark : ThemeMode.light);
  // Get.changeThemeMode(ThemeMode.dark);

  Get.put(AgoraCallController());
  Get.put(AgoraLiveController());
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(PostController());
  Get.put(PostCardController());
  Get.put(AddPostController());
  Get.put(AppStoryController());
  Get.put(ExploreController());
  Get.put(HighlightsController());
  Get.put(ChatDetailController());
  Get.put(ProfileController());
  Get.put(NotificationSettingController());
  Get.put(SubscriptionPackageController());
  Get.put(CompetitionController());
  Get.put(SettingsController());
  Get.put(ChatController());
  Get.put(BlockedUsersController());
  Get.put(MediaListViewerController());
  Get.put(SelectMediaController());
  Get.put(ChatRoomDetailController());
  Get.put(LiveJoinedUserController());
  Get.put(SinglePostDetailController());
  Get.put(CallHistoryController());
  Get.put(VideoPostTileController());
  Get.put(ContactsController());

  setupServiceLocator();
  await getIt<UserProfileManager>().refreshProfile();
  getIt<NotificationManager>().initialize();

  // AppConfigConstants.selectedLanguage = await SharedPrefs().getLanguageCode();

  getIt<DBManager>().clearOldStories();

  if (getIt<UserProfileManager>().isLogin == true) {
    ApiController().updateTokens();
  }

  // if (Platform.isAndroid) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }
  AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: 'Calls',
          channelKey: 'calls',
          channelName: 'Calls',
          channelDescription: 'Notification channel for calls',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          locked: true,
          enableVibration: true,
          playSound: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'calls', channelGroupName: 'Calls'),
      ],
      debug: true);

  runApp(EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'AE'),
        Locale('ar', 'SA'),
        Locale('ar', 'DZ'),
        Locale('de', 'DE'),
        Locale('fr', 'FR'),
        Locale('ru', 'RU')
      ],
      path: 'assets/resources',
      fallbackLocale: const Locale('en', 'US'),
      child: Phoenix(child: const PhotoSellApp())));
}

class PhotoSellApp extends StatelessWidget {
  const PhotoSellApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return OverlaySupport.global(
        child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: navigationKey,
      home: const SplashScreen(),
      builder: EasyLoading.init(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: context.localizationDelegates,
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   // GlobalCupertinoLocalizations.delegate,
      //   // Add this line
      //   GiphyGetUILocalizations.delegate,
      // ],
      locale: context.locale,

      supportedLocales: context.supportedLocales,
    ));
  }
}
