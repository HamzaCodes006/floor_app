// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapScreen extends StatefulWidget {
//   MapScreen({Key? key, this.title}) : super(key: key);
//
//   final String? title;
//
//   @override
//   _MapScreenPageState createState() => _MapScreenPageState();
// }
//
// class _MapScreenPageState extends State<MapScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//
//   static const CameraPosition cameraPosition = CameraPosition(
//     target: LatLng(33.78297, 72.35221),
//     zoom: 15,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//     bearing: 192.8334901395799,
//     target: LatLng(33.78297, 72.35221),
//     tilt: 59.440717697143555,
//     zoom: 19.151926040649414,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: cameraPosition,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('Go To!'),
//         icon: const Icon(Icons.home_outlined),
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
