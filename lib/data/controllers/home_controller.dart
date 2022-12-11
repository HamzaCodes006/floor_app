import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/data/Constants.dart';
import 'package:floor_app/ui/loginPage.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/widget/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

import '../singleton/singleton.dart';

class HomeController extends GetxController with StateMixin {
  GoogleMapController? mapController;
  Set<Marker> userMarkers = {};
  Set<Marker> userTrackMarkers = {};
  Set<Marker> adminMarkers = {};
  double? userLatitude;
  double? userLongitude;
  RxDouble altitude = 0.0.obs;
  bool permit = false;
  Set<Polyline> polyLines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  List<String> imgList = [
    // 'assets/images/img1.jpeg',
    // 'assets/images/img2.jpeg',
    'assets/images/img3.jpg',
    'assets/images/img4.jpg',
    'assets/images/img5.jpeg',
    'assets/images/img6.jpeg',
    'assets/images/img7.jpeg',
  ];
  late CameraPosition cameraPosition;
  double lat1=31.582045;
  double lng1=74.329376;
  LatLng? latLng;
  double ?userLat;
  double ?userLng;

  ///get current location
  getCurrentUserLocation() async {
    loc.Location location = loc.Location();

    final user = FirebaseAuth.instance.currentUser;
    loc.PermissionStatus status = await location.hasPermission();

    if (status == loc.PermissionStatus.granted ) {
      // CustomToast.successToast(
      //   msg: 'LOCATION PERMISSION GRANTED',
      // );
      if (user != null) {
        // CustomToast.successToast(
        //   msg: 'USER != NUL',
        // );
        // Position position = await Geolocator.getCurrentPosition(
        //     desiredAccuracy: LocationAccuracy.high);
        StreamSubscription<Position> stream =
            Geolocator.getPositionStream().listen((event) {
          userLatitude = event.latitude;
          userLongitude = event.longitude;
          altitude.value = event.altitude;
          LatLng latLng = LatLng(event.latitude, event.longitude);
          SingleToneValue.instance.currentLat = event.latitude;
          SingleToneValue.instance.currentLng = event.longitude;
          SingleToneValue.instance.currentHeight = event.altitude;

          userTrackAddMarkers(lat: event.latitude,lng: event.longitude,currentAltitude: event.altitude);

          FirebaseFirestore.instance.collection('User').doc(user.uid).update({
            'userLatitude': event.latitude,
            'userLongitude': event.longitude,
            'userHeight': event.altitude,
          }).then((value) => Get.log('Location Updated!'));

          Get.log("=====${event.latitude},${event.latitude}");
          // event.latitude;
        });

        permit = true;

        // if (position.altitude > 166 && position.altitude < 171) {
        //   floor.value = "Ground floor";
        //   update();
        // } else if (position.altitude > 171 && position.altitude < 175) {
        //   floor.value = "1st floor";
        //   update();
        // }

        // return latLng;
      }
    } else {
      loc.PermissionStatus status = await location.requestPermission();
      if (status == loc.PermissionStatus.granted ||
          status == loc.PermissionStatus.granted) {
        CustomToast.successToast(
          msg: 'Location Updated!',
        );

        StreamSubscription<Position> stream =
        Geolocator.getPositionStream().listen((event) {
          userLatitude = event.latitude;
          userLongitude = event.longitude;
          altitude.value = event.altitude;
          LatLng latLng = LatLng(event.latitude, event.longitude);
          SingleToneValue.instance.currentLat = event.latitude;
          SingleToneValue.instance.currentLng = event.longitude;
          SingleToneValue.instance.currentHeight = event.altitude;
          userTrackAddMarkers(lat: event.latitude,lng: event.longitude,currentAltitude: event.altitude);

          FirebaseFirestore.instance.collection('User').doc(user!.uid).update({
            'userLatitude': event.latitude,
            'userLongitude': event.longitude,
            'userHeight': event.altitude,
          }).then((value) => Get.log('Location Updated!'));

          Get.log("+++++++${event.latitude},${event.latitude}");
          // event.latitude;
        });

      } else {
        Get.offAll(LoginPage());
        CustomToast.failToast(msg: 'Access Denied', bgcolor: Colors.red);

        // return LatLng(0.0, 0.0);
      }
    }
  }

  ///onMap create
  onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    mapController!.setMapStyle('[]');
    //update();
  }

  // getUsers() async {
  //   await FirebaseFirestore.instance.collection('User').get().then(
  //     (QuerySnapshot querySnapshot) {
  //       for (var element in querySnapshot.docs) {
  //         element.get('userLatitude');
  //         element.get('userLongitude');
  //       }
  //     },
  //   );
  // }

  ///onMap Create 1 for user
  onMapCreatedUser(GoogleMapController controller) {
    try {
      controller = (controller);

      userAddMarkers();
      // createPolyLines();
      LatLngBounds bound;

      bound = LatLngBounds(
        northeast: LatLng(max(31.474925, SingleToneValue.instance.currentLat),
            max(4.306518, SingleToneValue.instance.currentLng)),
        southwest: LatLng(min(31.475767, SingleToneValue.instance.currentLat),
            min(74.304297, SingleToneValue.instance.currentLng)),
      );
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 80);
      controller.animateCamera(u2).then((void v) {
        check(u2, controller);
      });
      update();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        print("PERMISSION_DENIED");
        // currentLocation = null;
      }
      print(e);
    }
  }

  ///onMap Create 2

  onMapCreatedAdmin(GoogleMapController controller) {
    try {
      controller = (controller);

      adminAddMarkers();

      // createPolyLines();
      LatLngBounds bound;

      bound = LatLngBounds(
        northeast: LatLng(max(31.474925, SingleToneValue.instance.currentLat),
            max(4.306518, SingleToneValue.instance.currentLng)),
        southwest: LatLng(min(31.475767, SingleToneValue.instance.currentLat),
            min(74.304297, SingleToneValue.instance.currentLng)),
      );
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 80);
      controller.animateCamera(u2).then((void v) {
        check(u2, controller);
      });
      update();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        print("PERMISSION_DENIED");
        // currentLocation = null;
      }
      print(e);
    }
  }

  ///onMap tracking for user
  onMapCreatedTrack(
      {GoogleMapController? controller,}) {
    try {
      controller = (controller);

      // userTrackAddMarkers();
      // createTrackingPolyLines(lat: lat, long: long);
      LatLngBounds bound;

      bound = LatLngBounds(
        northeast: LatLng(max(SingleToneValue.instance.user2Lat!, SingleToneValue.instance.currentLat),
            max(SingleToneValue.instance.user2Lng!, SingleToneValue.instance.currentLng)),
        southwest: LatLng(min(SingleToneValue.instance.user2Lat!, SingleToneValue.instance.currentLat),
            min(SingleToneValue.instance.user2Lng!, SingleToneValue.instance.currentLng)),
      );

      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 80);
      // controller!.animateCamera(u2).then((void v) {
      //   check(u2, controller!);
      // });
      update();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        print("PERMISSION_DENIED");
        // currentLocation = null;
      }
      print(e);
    }
  }

  ///check
  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    c.moveCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }

  ///user map marker
  Future<void> userAddMarkers() async {
    userMarkers.clear();
    userMarkers.add(Marker(
      // ignore: deprecated_member_use
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId("User 1"),
      position: LatLng(SingleToneValue.instance.currentLat,
          SingleToneValue.instance.currentLng),
      infoWindow: const InfoWindow(
        title: 'Current Location',
        snippet: 'This is user\'s current location',
      ),
    ));

    update();
  }

  ///user tracking marker
  userTrackAddMarkers({double? lat, double? lng,double? currentAltitude}) async {

    userTrackMarkers.clear();

    latLng=LatLng(lat!, lng!
    ) ;
    cameraPosition=CameraPosition(target:latLng!,zoom: 17.0 );

      mapController?.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition));

    userTrackMarkers.removeWhere((m) => m.markerId.value == "first");

    userTrackMarkers.add(Marker(
      // ignore: deprecated_member_use
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      markerId: MarkerId("first"),
      position: LatLng(SingleToneValue.instance.currentLat,
          SingleToneValue.instance.currentLng),
      infoWindow:  InfoWindow(
        title: "You",
        snippet: 'height: ${currentAltitude!.toStringAsFixed(0)}',
      ),
    ));
update();

///i need altitude value of 2nd user from singleton which come from chat .... then i can show required altitude
    //2nd marker
    userTrackMarkers.add(Marker(
      // ignore: deprecated_member_use
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      markerId: MarkerId("second"),
      position: LatLng(SingleToneValue.instance.user2Lat!,SingleToneValue.instance.user2Lng!),
      infoWindow: InfoWindow(
        title: SingleToneValue.instance.user2Name.toString(),
        snippet: SingleToneValue.instance.user2Height!.toStringAsFixed(0).toString(),
      ),
    ));
    double val=SingleToneValue.instance.user2Height!;
    altitude.value =  currentAltitude -  val;
    update();
  }



  ///markers for admin
  adminAddMarkers() async {
    adminMarkers.clear();

    FirebaseFirestore.instance.collection('User').snapshots().listen((event) {
      // adminAddMarkers();
      event.docs.map((doc) {
        // Get.log("loc: ${doc.get('userName')}");
        adminMarkers.add(Marker(
          // ignore: deprecated_member_use
          // icon: doc.get('status')=="online"?BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen):BitmapDescriptor.defaultMarker,
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId(doc.id),
          position: LatLng(
            doc.get('userLatitude'),
            doc.get('userLongitude'),
          ),
          infoWindow: InfoWindow(
            title: doc.get('userName'),
            snippet:
                "Height: ${doc.get('userHeight').toStringAsFixed(0).toString()}m ",
          ),
        ));
        update();
      }).toList();
    });

    update();
  }

  // createPolyLines() async {
  //   // OrderDetails orderDetails = getOrderDetails();
  //   try {
  //     /// Initializing PolylinePoints
  //
  //     polylinePoints = PolylinePoints();
  //
  //     /// Generating the list of coordinates to be used for
  //     /// drawing the poly lines
  //
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       Constants.mapKey, // Google Maps API Key
  //       PointLatLng(SingleToneValue.instance.currentLat,
  //           SingleToneValue.instance.currentLng),
  //       PointLatLng(31.472454, 74.326431),
  //       travelMode: TravelMode.walking,
  //     );
  //
  //     ///Adding the coordinates to the list
  //     if (result.points.isNotEmpty) {
  //       for (var point in result.points) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //     }
  //
  //     /// Defining an ID
  //     PolylineId id = PolylineId('poly');
  //
  //     /// Initializing Polyline
  //
  //     // polyLines.clear();
  //
  //     Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: MyColors.primaryColor,
  //       points: polylineCoordinates,
  //       width: 5,
  //     );
  //
  //     /// Adding the polyline to the map
  //     //  polylines[id] = polyline;
  //     polyLines.add(polyline);
  //     // polylineCoordinates.clear();
  //
  //     /// new addition
  //
  //     update();
  //   } on PlatformException catch (e) {
  //     if (e.code == "PERMISSION_DENIED") {
  //       print("No map update");
  //     }
  //     print(e);
  //   }
  // }

  // createTrackingPolyLines({required double lat, required double long}) async {
  //   // polyLines.clear();
  //
  //   // OrderDetails orderDetails = getOrderDetails();
  //   try {
  //     // polylineCoordinates.clear();/// new addition
  //
  //     /// Initializing PolylinePoints
  //
  //     polylinePoints = PolylinePoints();
  //
  //     /// Generating the list of coordinates to be used for
  //     /// drawing the poly lines
  //
  //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       Constants.mapKey, // Google Maps API Key
  //       PointLatLng(SingleToneValue.instance.currentLat,
  //           SingleToneValue.instance.currentLng),
  //       PointLatLng(lat, long),
  //       travelMode: TravelMode.walking,
  //     );
  //
  //     ///Adding the coordinates to the list
  //     if (result.points.isNotEmpty) {
  //       for (var point in result.points) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       }
  //     }
  //
  //     /// Defining an ID
  //     PolylineId id = PolylineId('polyLine');
  //
  //     /// Initializing Polyline
  //
  //     Polyline polyline = Polyline(
  //       polylineId: id,
  //       color: MyColors.primaryColor,
  //       points: polylineCoordinates,
  //       width: 4,
  //     );
  //
  //     /// Adding the polyline to the map
  //     //  polylines[id] = polyline;
  //     polyLines.add(polyline);
  //
  //     // update();
  //   } on PlatformException catch (e) {
  //     if (e.code == "PERMISSION_DENIED") {
  //       print("No map update");
  //     }
  //     print(e);
  //   }
  // }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }


  @override
  void onClose() {
    // polylineCoordinates.clear();
    polyLines.clear();
    // TODO: implement onClose
    super.onClose();
  }

}
