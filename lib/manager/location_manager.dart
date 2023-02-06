import 'package:location/location.dart';

import '../components/custom_camera/constants/constants.dart';

class LocationManager {
  postLocation() {
    // Location().getLocation().then((locationData) {
    //   LatLng location = LatLng(
    //       latitude: locationData.latitude!, longitude: locationData.longitude!);
    //   ApiController().updateUserLocation(location);
    // }).catchError((error) {});
  }

  stopPostingLocation() {
    // Location().getLocation().then((locationData) {
    //   ApiController().stopSharingUserLocation();
    // }).catchError((error) {});
  }

  getLocation(Function(LatLng) callback) {
    Location().getLocation().then((locationData) {
      LatLng location = LatLng(
          latitude: locationData.latitude!, longitude: locationData.longitude!);
      callback(location);
    }).catchError((error) {});
  }
}
