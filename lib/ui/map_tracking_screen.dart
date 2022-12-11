import 'package:floor_app/data/controllers/home_controller.dart';
import 'package:floor_app/data/singleton/singleton.dart';
import 'package:floor_app/ui/admin_screens/admin_map_screen.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTrackingScreen extends StatelessWidget {
  // final double userLat;
  // final double userLong;
  HomeController homeController = Get.put(HomeController());

  MapTrackingScreen({Key? key, })
      : super(key: key);
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: const Text("Tracking"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                    color: MyColors.secondaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30.0))),
              ),
              Column(
                children: [
                  SizedBox(
                    height: getHeight(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AdminMapScreen());
                        },
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: getWidth(120),
                          height: getHeight(120),
                          color: MyColors.white,
                        ),
                      ),
                      SizedBox(
                        width: getWidth(20),
                      ),
                      Column(
                        children: [
                          Text(
                            'Require altitude',
                            style: TextStyle(
                                fontSize: getFont(18),
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: getHeight(10),
                          ),
                          Obx(
                            () => homeController.altitude.value.toStringAsFixed(0)==0?Text(
                              "${homeController.altitude.value.toStringAsFixed(0).toString()}m",
                              style: TextStyle(
                                  fontSize: getFont(40),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ):Text(
                              "Same Floor",
                              style: TextStyle(
                                  fontSize: getFont(40),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: getHeight(10),
                          ),
                          Text(
                            'Based on your Location',
                            style: TextStyle(
                                fontSize: getFont(18),
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // ListTile(
              //   contentPadding:
              //       const EdgeInsets.only(left: 20, right: 20, top: 20),
              //   title: Obx(
              //     () => Text(
              //       'Your are now at ${homeController.height}, ${homeController.floor.value}',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //   ),
              //
              //   subtitle: Text(
              //     FirebaseAuth.instance.currentUser!.email.toString(),
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   // trailing: GestureDetector(
              //   //   onTap: () {
              //   //     Navigator.push(context,
              //   //         MaterialPageRoute(builder: (context) => MapScreen()));
              //   //   },
              //   //   child: const CircleAvatar(),
              //   // ),
              // ),
            ]),
            SizedBox(
              height: getHeight(650),
              child: Stack(
                // fit: StackFit.expand,
                children: [
                  GetBuilder<HomeController>(builder: (homeController) {
                    return GoogleMap(
                      onMapCreated: homeController.onMapCreatedTrack(controller: mapController),
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      polylines: homeController.polyLines,
                      compassEnabled: true,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: true,
                      markers: homeController.userTrackMarkers,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(SingleToneValue.instance.currentLat,
                            SingleToneValue.instance.currentLng),
                        zoom: 16.161926040649414,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
