import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/data/controllers/home_controller.dart';
import 'package:floor_app/data/singleton/singleton.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminMapScreen extends StatelessWidget {
  AdminMapScreen({Key? key}) : super(key: key);
  HomeController homeController = Get.put(HomeController());
  List storeLatitude = []; //fetching store lat
  List storeLongitude = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Map View'),
        backgroundColor: MyColors.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: getHeight(850),
                    child: Stack(
                      // fit: StackFit.expand,
                      children: [
                        GetBuilder<HomeController>(builder: (homeController) {
                          return GoogleMap(
                            onMapCreated: homeController.onMapCreatedAdmin,
                            zoomGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            myLocationEnabled: false,
                            myLocationButtonEnabled: true,
                            mapType: MapType.normal,
                            markers: homeController.adminMarkers,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  SingleToneValue.instance.currentLat,
                                  SingleToneValue.instance.currentLng),
                              zoom: 11.161926040649414,
                              // zoom: 13.161926040649414,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            )

    );
  }
}
