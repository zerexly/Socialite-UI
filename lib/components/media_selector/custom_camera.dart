// import 'package:foap/helper/common_import.dart';
//
// class CustomCamera extends StatefulWidget {
//   const CustomCamera({Key? key}) : super(key: key);
//
//   @override
//   State<CustomCamera> createState() => _CustomCameraState();
// }
//
// class _CustomCameraState extends State<CustomCamera> {
//   late List<CameraDescription> _cameras;
//   late CameraController controller;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     loadCamera();
//     super.initState();
//   }
//
//   loadCamera() async {
//     _cameras = await availableCameras();
//     controller = CameraController(_cameras[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             print('User denied camera access.');
//             break;
//           default:
//             print('Handle other errors.');
//             break;
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(controller),
//     );
//   }
// }
