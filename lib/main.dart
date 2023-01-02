import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:foap/controllers/podcast_streaming_controller.dart';
import 'package:foap/helper/common_import.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:giphy_get/l10n.dart';

import 'controllers/faq_controller.dart';
// import 'package:easy_localization/easy_localization.dart';

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
  // await EasyLocalization.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
      true // option: set to false to disable working with http links (default: false)
  );
  // await CustomGalleryPermissions.requestPermissionExtend();

  final firebaseMessaging = FCM();
  firebaseMessaging.setNotifications();
  String? token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
  if (token != null) {
    SharedPrefs().setVoipToken(token);
  }

  AutoOrientation.portraitAutoMode();

  bool isDarkTheme = await SharedPrefs().isDarkMode();
  Get.changeThemeMode(isDarkTheme ? ThemeMode.dark : ThemeMode.light);
  // Get.changeThemeMode(ThemeMode.dark);
  Get.put(DashboardController());
  Get.put(SettingsController());
  Get.put(SubscriptionPackageController());
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
  Get.put(CompetitionController());
  Get.put(ChatHistoryController());
  Get.put(BlockedUsersController());
  Get.put(MediaListViewerController());
  Get.put(SelectMediaController());
  Get.put(ChatRoomDetailController());
  Get.put(LiveJoinedUserController());
  Get.put(SinglePostDetailController());
  Get.put(CallHistoryController());
  Get.put(VideoPostTileController());
  Get.put(ContactsController());
  Get.put(SelectUserForChatController());
  Get.put(SelectUserForGroupChatController());
  Get.put(EnterGroupInfoController());
  Get.put(ClubsController());
  Get.put(ClubDetailController());
  Get.put(CreateClubController());
  Get.put(NotificationController());
  Get.put(UserNetworkController());
  Get.put(RandomLivesController());
  Get.put(RandomChatAndCallController());
  Get.put(SearchClubsController());
  Get.put(TvStreamingController());
  Get.put(MapScreenController());
  Get.put(GiftController());
  Get.put(LiveHistoryController());
  Get.put(RequestVerificationController());
  Get.put(FAQController());
  Get.put(EventsController());
  Get.put(PodcastStreamingController());

  setupServiceLocator();
  await getIt<UserProfileManager>().refreshProfile();
  getIt<NotificationManager>().initialize();

  // AppConfigConstants.selectedLanguage = await SharedPrefs().getLanguageCode();

  // getIt<DBManager>().clearOldStories();
  await getIt<DBManager>().createDatabase();

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

  runApp(Phoenix(child: const SocialifiedApp()));
}

class SocialifiedApp extends StatefulWidget {
  const SocialifiedApp({Key? key}) : super(key: key);

  @override
  State<SocialifiedApp> createState() => _SocialifiedAppState();
}

class _SocialifiedAppState extends State<SocialifiedApp> {
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    super.initState();
    _settingsController.getSettings();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);

    return OverlaySupport.global(
        child: FutureBuilder<String>(
            future: SharedPrefs().getLanguage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                return GetMaterialApp(
                  translations: Languages(),
                  locale: Locale(snapshot.data!),
                  fallbackLocale: const Locale('en', 'US'),
                  debugShowCheckedModeBanner: false,
                  // navigatorKey: navigationKey,
                  home: const SplashScreen(),
                  builder: EasyLoading.init(),
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: ThemeMode.dark,
                  // localizationsDelegates: context.localizationDelegates,
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    // GlobalCupertinoLocalizations.delegate,
                    // Add this line
                    GiphyGetUILocalizations.delegate,
                  ],
                  supportedLocales: const <Locale>[
                    Locale('hi', 'US'),
                    Locale('en', 'SA'),
                    Locale('ar', 'SA'),
                    Locale('tr', 'SA'),
                    Locale('ru', 'SA'),
                    Locale('es', 'SA'),
                    Locale('fr', 'SA')
                  ],
                );
              } else {
                return Container();
              }
            }));
  }
}
