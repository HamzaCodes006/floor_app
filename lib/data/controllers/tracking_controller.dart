// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:map_module/data/common_utils/sing leton.dart';
// import 'package:map_module/widgets/toasts.dart';
//
// class TrackingController extends GetxController {
//   bool? serviceEnabled;
//   CameraPosition? defaultLocation;
//   GoogleMapController? mapController;
//   Set<Marker> markers = {};
//   DatabaseReference ref = FirebaseDatabase.instance.ref().child("users");
//   double ?userLat;
//   double ?userLng;
//   double lat1=31.582045;
//   double lng1=74.329376;
//   LatLng? latLng;
//   late CameraPosition cameraPosition;
//
//
//   ///
//   getLatLongStreamData() async {
//     loc.Location location = loc.Location();
//     //getting permission of location
//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled!) {
//       CustomToast.failToast(msg: "location not enabled!");
//
//       serviceEnabled = await location.requestService();
//     } else {
//       loc.PermissionStatus status = await location.hasPermission();
//       if (status == loc.PermissionStatus.denied) {
//         CustomToast.failToast(msg: "location denied");
//
//         loc.PermissionStatus? permissionGranted =
//             await location.requestPermission();
//         if (permissionGranted != loc.PermissionStatus.granted) {
//           CustomToast.failToast(msg: "Now you have to uninstall app");
//           loc.PermissionStatus status = await location.hasPermission();
//
//           loc.PermissionStatus? permissionGranted2 =
//               await location.requestPermission();
//           if (permissionGranted2 != loc.PermissionStatus.granted) {
//             CustomToast.failToast(msg: 'lat long set to 0 ,0 ');
//           } else if (permissionGranted2 == loc.PermissionStatus.deniedForever) {
//             // CustomToast.failToast(msg: "location denied forever");
//
//           } else {
//             // CustomToast.successToast(msg: "location granted successfully");
//             location.changeSettings(
//               accuracy: loc.LocationAccuracy.high,
//             );
//
//             SingleToneValue.instance.stream =
//                 location.onLocationChanged.listen((event) {
//                   setStreamLatLong(event);
//               SingleToneValue.instance.currentLat = event.latitude!;
//               SingleToneValue.instance.currentLng = event.longitude!;
//               ///initial camera position
//               defaultLocation = CameraPosition(
//                   target: LatLng(SingleToneValue.instance.currentLat,
//                       SingleToneValue.instance.currentLng),
//                   zoom: 17);
//
//               Get.log(
//                   "1111111111111111111111111111111  ${event.latitude},${event.longitude}");
//             });
//             update();
//           }
//         } else if (permissionGranted == loc.PermissionStatus.deniedForever) {
//           CustomToast.failToast(msg: "location not granted forever");
//
//           // permissionGranted = await location.requestPermission();
//         } else {
//           CustomToast.successToast(msg: "location granted successfully1");
//
//           location.changeSettings(
//             accuracy: loc.LocationAccuracy.high,
//           );
//           // loc.LocationData data = await location.getLocation();
//           // LatLng latLng = LatLng(data.latitude!, data.longitude!);
//           SingleToneValue.instance.stream =
//               location.onLocationChanged.listen((event) {
//                 setStreamLatLong(event);
//             SingleToneValue.instance.currentLat = event.latitude!;
//             SingleToneValue.instance.currentLng = event.longitude!;
//             ///initial camera position
//             defaultLocation = CameraPosition(
//                 target: LatLng(SingleToneValue.instance.currentLat,
//                     SingleToneValue.instance.currentLng),
//                 zoom: 17);
//             Get.log(
//                 "222222222222222222222222222222222  ${event.latitude},${event.longitude}");
//           });
//
//           update();
//         }
//       } else if (status == loc.PermissionStatus.granted) {
//         CustomToast.successToast(msg: "location granted successfully2");
//
//         location.changeSettings(
//           accuracy: loc.LocationAccuracy.high,
//         );
//         // loc.LocationData data = await location.getLocation();
//         // LatLng latLng = LatLng(data.latitude!, data.longitude!);
//         SingleToneValue.instance.stream =
//             location.onLocationChanged.listen((event) {
//               setStreamLatLong(event);
//               getStreamLatLong();
//           SingleToneValue.instance.currentLat = event.latitude!;
//           SingleToneValue.instance.currentLng = event.longitude!;
//               ///initial camera position
//               defaultLocation = CameraPosition(
//                   target: LatLng(SingleToneValue.instance.currentLat,
//                       SingleToneValue.instance.currentLng),
//                   zoom: 17);
//           Get.log(
//               "333333333333333333333333333333333    ${event.latitude},${event.longitude}");
//         });
//
//
//         update();
//       } else if (status == loc.PermissionStatus.deniedForever) {
//         CustomToast.failToast(msg: "location denied forever");
//
//         loc.PermissionStatus permissionGranted3 =
//             await location.requestPermission();
//         if (permissionGranted3 == loc.PermissionStatus.denied) {}
//       } else {
//         loc.PermissionStatus requestPermission =
//             await location.requestPermission();
//         if (requestPermission == loc.PermissionStatus.denied) {
//           CustomToast.failToast(msg: "location denied");
//
//           loc.PermissionStatus permissionGranted4 =
//               await location.requestPermission();
//
//           if (permissionGranted4 != loc.PermissionStatus.granted) {
//             CustomToast.failToast(msg: "location not granteddd");
//           } else if (permissionGranted4 != loc.PermissionStatus.granted) {}
//         } else if (requestPermission == loc.PermissionStatus.granted) {
//           location.changeSettings(
//             accuracy: loc.LocationAccuracy.high,
//           );
//           // loc.LocationData data = await location.getLocation();
//           // LatLng latLng = LatLng(data.latitude!, data.longitude!);
//           SingleToneValue.instance.stream =
//               location.onLocationChanged.listen((event) {
//                 setStreamLatLong(event);
//             SingleToneValue.instance.currentLat = event.latitude!;
//             SingleToneValue.instance.currentLng = event.longitude!;
//             ///initial camera position
//             defaultLocation = CameraPosition(
//                 target: LatLng(SingleToneValue.instance.currentLat,
//                     SingleToneValue.instance.currentLng),
//                 zoom: 17);
//             Get.log(
//                 "444444444444444444444444444444  ${event.latitude},${event.longitude}");
//           });
//
//           ///initial camera position
//           defaultLocation = CameraPosition(
//               target: LatLng(SingleToneValue.instance.currentLat,
//                   SingleToneValue.instance.currentLng),
//               zoom: 17);
//           update();
//         } else if (requestPermission == loc.PermissionStatus.deniedForever) {
//           CustomToast.failToast(msg: "denied forever");
//         }
//       }
//     }
//   }
//
//   ///setting stream of latlong in DB
//   setStreamLatLong(newStream) {
//     // loc.Location location = loc.Location();
//     // location.changeSettings(
//     //   accuracy: loc.LocationAccuracy.high,
//     // );
//     ref.child('userId').set({
//       "userLatitude": newStream.latitude,
//       "userLongitude": newStream.longitude,
//     });
//     // Get.log("Inside set stream...  ${newStream.latitude},${newStream.longitude}");
//     update();
//   }
//
//   ///getting stream of latlong in DB
//   getStreamLatLong() {
//
//     ref.child('userId').onValue.listen((event) {
//         dynamic snapShot = event.snapshot.value;
//         if (snapShot["userLatitude"] != null && snapShot["userLongitude"] != null){
//           userLat=snapShot['userLatitude'];
//           userLng=snapShot['userLongitude'];
//           update();
//         }
//         userMarker(userLat.toString(),userLng.toString());
//
//       // Get.log("aaaaaaaaaaaaaaaaaaaaa  ${data['userLatitude']},${data['userLongitude']}");
//
//
//     });
//       // ({
//       // "userLatitude": newStream.latitude,
//       // "userLongitude": newStream.longitude,
//     // });
//     // Get.log("Inside get stream...  ${newStream.latitude},${newStream.longitude}");
//     update();
//   }
//
//   /// when map created initially it provides default latlong which means current latlong and show current address
//   onMapCreated(GoogleMapController controller) {
//     // Get.find<LocationController>().getAddressFromLatLang(
//     //     defaultLocation.target.latitude, defaultLocation.target.longitude);
//     // await getCurrentLatLong();
//     addMarker();
//     mapController = controller;
//     mapController!.setMapStyle("");
//
//     update();
//   }
//
//   addMarker() {
//     markers.clear();
//     markers.add(
//       Marker(
//         markerId: const MarkerId('trackLocation'),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueGreen,
//         ),
//         infoWindow: const InfoWindow(title: 'Tracking Current Location'),
//         position: defaultLocation!.target,
//       ),
//     );
//
//     update();
//   }
//
//
//   userMarker(String lat,String lng){
//     latLng=LatLng(double.parse(lat),double.parse(lng)) ;
//     cameraPosition=CameraPosition(target:latLng!,zoom: 17.0 );
//     if(mapController!=null)
//       mapController!.animateCamera(
//           CameraUpdate.newCameraPosition(cameraPosition));
//     markers.removeWhere((m) => m.markerId.value == "trackLocation");
//
//     markers.add(Marker(
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueBlue,
//       ),
//       markerId: MarkerId("trackLocation"),
//       // position:LatLng(userLat!,userLng!),
//
//       position: userLat==null && userLng==null ?
//       LatLng(lat1,lng1)
//           :LatLng(userLat!,userLng!),
//       infoWindow: InfoWindow(
//         title: 'User Location',
//
//       ),
//
//     ));
//     update();
//   }
//
//
//   @override
//   Future<void> onInit() async {
//     await getLatLongStreamData();
//     // TODO: implement onInit
//     super.onInit();
//   }
// }
