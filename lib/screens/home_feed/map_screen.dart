import 'package:foap/helper/common_import.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_map;
import 'package:get/get.dart';

// ignore: must_be_immutable
class MapsUsersScreen extends StatefulWidget {
  UserModel? currentUser;

  MapsUsersScreen({Key? key, this.currentUser}) : super(key: key);

  @override
  State<MapsUsersScreen> createState() => _MapsUsersScreenState();
}

class _MapsUsersScreenState extends State<MapsUsersScreen> {
  late google_map.GoogleMapController mapController;
  final MapScreenController _mapScreenController = Get.find();
  google_map.CameraPosition? kGooglePlex;

  @override
  void initState() {
    _mapScreenController.getLocation();
    super.initState();
  }

  @override
  void dispose() {
    _mapScreenController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: [
            Obx(() {
              return _mapScreenController.currentLocation.value == null
                  ? const Center(child: CircularProgressIndicator())
                  : mapView();
            }),
            appBar()
          ],
        ));
  }

  Widget mapView() {
    return Obx(() {
      final google_map.CameraPosition kGooglePlex =
      google_map.CameraPosition(
        target: google_map.LatLng(
            _mapScreenController.currentLocation.value!.latitude!,
            _mapScreenController.currentLocation.value!.longitude!),
        zoom: 0,
      );
      return google_map.GoogleMap(
        mapType: google_map.MapType.terrain,
        markers: _mapScreenController.markers,
        initialCameraPosition: kGooglePlex,
        mapToolbarEnabled: false,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        onMapCreated: (google_map.GoogleMapController controller) {
          mapController = controller;
          _goToCurrentLocation();
        },
      );
    });
  }

  Widget appBar() {
    return Positioned(
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black,
                  Colors.black.withOpacity(0.5),
                  Colors.grey.withOpacity(0.0),
                ],
                stops: const [
                  0.0,
                  0.5,
                  1.0
                ])),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ThemeIconWidget(
              ThemeIcon.backArrow,
              size: 20,
              color: Colors.white,
            ).ripple(() {
              Get.back();
            }),
          ],
        ).hP16,
      ),
    );
  }

  // updateUsersLocations() {
  //   for (UserModel userModel in value) {
  //     if (userModel.latitude != null) {
  //       String imgurl = userModel.picture!;
  //       Uint8List bytes =
  //           (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
  //               .buffer
  //               .asUint8List();
  //
  //       convertImageFileToCustomBitmapDescriptor(bytes,
  //               title: userModel.userName,
  //               size: 170,
  //               borderSize: 20,
  //               addBorder: true,
  //               borderColor: Theme.of(context).primaryColor)
  //           .then((value) {
  //         getMarkers(userModel, value);
  //       });
  //     }
  //   }
  // }

  Future<void> _goToCurrentLocation() async {
    final google_map.CameraPosition kLake = google_map.CameraPosition(
        bearing: 192,
        target: google_map.LatLng(
            _mapScreenController.currentLocation.value!.latitude!,
            _mapScreenController.currentLocation.value!.longitude!),
        tilt: 59,
        zoom: 12);

    final google_map.GoogleMapController controller = mapController;
    controller.animateCamera(google_map.CameraUpdate.newCameraPosition(kLake));
  }
}
