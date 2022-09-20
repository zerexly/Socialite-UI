import 'package:foap/helper/common_import.dart';
import 'package:foap/manager/file_manager.dart';
import 'package:foap/manager/media_manager.dart';
import 'package:foap/manager/notification_manager.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<PlayerManager>(() => PlayerManager());
  getIt.registerLazySingleton<DBManager>(() => DBManager());
  getIt.registerLazySingleton<UserProfileManager>(() => UserProfileManager());
  getIt.registerLazySingleton<MediaManager>(() => MediaManager());
  getIt.registerLazySingleton<FileManager>(() => FileManager());
  getIt.registerLazySingleton<VoipController>(() => VoipController());
  // getIt.registerLazySingleton<GalleryLoader>(() => GalleryLoader());
  getIt.registerLazySingleton<NotificationManager>(() => NotificationManager());
}

Future<void> setupSocketServiceLocator() async {
  getIt.registerLazySingleton<SocketManager>(() => SocketManager());
}
