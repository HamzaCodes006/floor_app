import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/Constants.dart';
import '../data/singleton/singleton.dart';
import '../values/my_imgs.dart';

class DropOffController extends GetxController{
  // final _repository = Repository();

  ///camer position
  late CameraPosition cameraPosition;
  ///polylines
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylinesadd = {};
  Set<Polyline> polyline = {};

  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> polylines = {};

  /// set odd marker
  Set<Marker> markers = {};
  double lat1=31.4543141;
  double lng1=74.2754132;
  /// driver id
  late LatLng pickLatLng;
  GoogleMapController? controller;
  // final firebase = FirebaseDatabase.instance.ref().child('online_driver');


  /// latlng
  LatLng? latLng;

  void removeMarkers() {
    {
      markers.removeWhere((m) => m.markerId.value == "current Location");
      update();
    }
  }

  @override
  Future<void> onInit() async {
  //  SingleToneValue.instance.dropLat=lat1;
   // SingleToneValue.instance.dropLng=lng1;
    // cameraPosition = CameraPosition(target: LatLng(31.4914, 74.2385), zoom: 15.0);
    // getStream();
    // getStreamLocation();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    cameraPosition = CameraPosition(target: LatLng(31.4914, 74.2385), zoom: 15.0);

    super.onReady();
  }

  @override
  void onClose() {
    removeMarkers();
    // streamSubscription.cancel();
    // _repository.close();
  }

  // getStreamLocation(){
  //   final LocationSettings locationSettings = LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 10,
  //   );
  //   streamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) async {
  //
  //     SingleToneValue.instance.currentLat  = position.latitude;
  //     SingleToneValue.instance.currentLng = position.longitude;
  //     print('singleToneChangeLat:${SingleToneValue.instance.currentLat}');
  //     print('singleToneChangeLng:${SingleToneValue.instance.currentLng}');
  //    // final _sharedPrefClient = SharedPrefClient();
  //    // UserDataSaveModel model = await _sharedPrefClient.getUser();
  //     // final instan =
  //     // firebase.child(model.userId.toString());
  //     // instan.update({
  //     //   'driver_id':model.userId.toString(),
  //     //   'lat': SingleToneValue.instance.currentLat,
  //     //   'long': SingleToneValue.instance.currentLng,
  //     //
  //     //   //   'rotation': rot.toString(),
  //     // });
  //     markers.removeWhere((m) => m.markerId.value == "current Location");
  //
  //     latLng=LatLng(SingleToneValue.instance.currentLat,SingleToneValue.instance.currentLng) ;
  //     cameraPosition=CameraPosition(target:latLng!,zoom: 15.0 );
  //     if(controller!=null)
  //       controller!.animateCamera(
  //
  //           CameraUpdate.newCameraPosition(cameraPosition));
  //
  //
  //
  //
  //     markers.add(Marker(
  //         markerId: MarkerId("current Location"),
  //
  //         icon: await BitmapDescriptor.fromAssetImage(
  //             ImageConfiguration(size: Size(10, 10)),
  //             MyImgs.pinImg),
  //         draggable: true,
  //         infoWindow: InfoWindow(
  //           title: 'Driver Location',
  //           snippet: '',
  //         ),
  //         position: LatLng(
  //             SingleToneValue.instance.currentLat, SingleToneValue.instance.currentLng),
  //         onDragEnd: (_currentlatLng) {
  //           latLng = _currentlatLng;
  //           // update();
  //         }));
  //   });
  //   update();
  // }






  Future<void> addMarkers1() async {
    markers.add(Marker(
      // ignore: deprecated_member_use
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(100, 100)),
          MyImgs.pinImg),
      markerId: MarkerId("Pick Location"),
      position: SingleToneValue.instance.dropLat==0 && SingleToneValue.instance.dropLng==0 ?
      LatLng(lat1,lng1)
          :LatLng(SingleToneValue.instance.dropLat,SingleToneValue.instance.dropLng),
      infoWindow: InfoWindow(
        title: 'Pick Up',
        snippet: '${SingleToneValue.instance.dropAddress}',
      ),

    ));


    update();
  }

  createPolylines() async {

    try {

      /// Initializing PolylinePoints

      polylinePoints = PolylinePoints();

      /// Generating the list of coordinates to be used for
      /// drawing the polylines

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Constants.mapKey, // Google Maps API Key
        PointLatLng(SingleToneValue.instance.currentLat,SingleToneValue.instance.currentLng),
        SingleToneValue.instance.dropLat==0 && SingleToneValue.instance.dropLng==0?
        PointLatLng(lat1, lng1) :
        PointLatLng(SingleToneValue.instance.dropLat, SingleToneValue.instance.dropLng
        ),
        travelMode: TravelMode.driving,
      );

      ///Adding the coordinates to the list
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      /// Defining an ID
      PolylineId id = PolylineId('poly');

      /// Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color:  Color.fromARGB(255, 40, 122, 198),
        points: polylineCoordinates,
        width: 5,
      );

      /// Adding the polyline to the map
      //  polylines[id] = polyline;
      polylines.add(polyline);

      update();
    }

    on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        print("No map update");
      }
      print(e);
    }
  }




  onMapCreated1(GoogleMapController controller)  {
    try {

      controller = (controller);
      controller
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      addMarkers1();
      createPolylines();
      LatLngBounds bound;

      bound = LatLngBounds(
        northeast: LatLng(
            SingleToneValue.instance.dropLat==0 ? max(lat1,SingleToneValue.instance.currentLat) :
            max(SingleToneValue.instance.dropLat, SingleToneValue.instance.currentLat),
            SingleToneValue.instance.dropLng==0 ? max(lng1, SingleToneValue.instance.currentLng):
            max(SingleToneValue.instance.dropLng, SingleToneValue.instance.currentLng)),
        southwest: LatLng(
            min(SingleToneValue.instance.dropLat,SingleToneValue.instance.currentLat),
            min(SingleToneValue.instance.dropLng, SingleToneValue.instance.currentLng)),
      );
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 40);

      check(u2,controller);
      update();
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_DENIED") {
        print("No se pudo obtener la ubicación.");
        // currentLocation = null;
      }
      print(e);
    }
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    c.moveCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      check(u, c);
  }



}