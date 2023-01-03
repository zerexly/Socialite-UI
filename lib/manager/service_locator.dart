import 'package:foap/helper/common_import.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<DBManager>(() => DBManager());
  getIt.registerLazySingleton<UserProfileManager>(() => UserProfileManager());
  // getIt.registerLazySingleton<MediaManager>(() => MediaManager());
  getIt.registerLazySingleton<FileManager>(() => FileManager());
  getIt.registerLazySingleton<VoipController>(() => VoipController());
  // getIt.registerLazySingleton<GalleryLoader>(() => GalleryLoader());
  getIt.registerLazySingleton<NotificationManager>(() => NotificationManager());
  getIt.registerLazySingleton<LocationManager>(() => LocationManager());

}

Future<void> setupSocketServiceLocator1() async {
  if (!getIt.isRegistered<SocketManager>()) {
    getIt.registerLazySingleton<SocketManager>(() => SocketManager());
  }
}
