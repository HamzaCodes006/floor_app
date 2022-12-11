import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/data/controllers/home_controller.dart';
import 'package:floor_app/data/singleton/singleton.dart';
import 'package:floor_app/ui/loginPage.dart';
import 'package:floor_app/ui/admin_screens/admin_map_screen.dart';
import 'package:floor_app/ui/map_screens/mapScreen.dart';
import 'package:floor_app/values/dimens.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/my_imgs.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:floor_app/widget/build_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> {

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context).textTheme;
    homeController.getCurrentUserLocation();
    GoogleMapController? mapController;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primaryColor,
          title: const Text("Dashboard"),
          centerTitle: true,
        ),
        drawer: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('User')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something Wrong Happens');
              }
              if (snapshot.hasData) {
                return Drawer(
                  child: Material(
                    color: MyColors.primaryColor,
                    child: SafeArea(
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        children: [
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/appLogo.png',
                                    color: Colors.white,
                                    height: getHeight(250),
                                  ),
                                ),
                                SizedBox(height: 14,),

                                Text(
                                  "Hello ${snapshot.data!.get('userName')},",
                                  style: theme.headline6!.copyWith(color: Colors.white),
                                ),
                                // SizedBox(height: 5,),
                                // Text(
                                //   "Email: ${snapshot.data!.get('email')}",
                                //   style: theme.bodyText2,
                                // ),
                                // Text(
                                //   FirebaseAuth.instance.currentUser!.uid,
                                //   style:theme.bodyText1,
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          // buildAuthenticate(context),
                          BuildMenuItem(
                            icon: Icons.home,
                            text: 'Home',
                          ),
                          BuildMenuItem(
                            icon: Icons.chat,
                            text: 'Chat',
                          ),
                          BuildMenuItem(
                            icon: Icons.chat,
                            text: 'Complaint ',
                          ),

                          BuildMenuItem(
                            icon: Icons.error_outline,
                            text: 'Profile',
                          ),
                          SizedBox(height: 35),
                          Divider(color: Colors.white, thickness: 1.4),
                          SizedBox(
                            height: 35.0,
                          ),
                          BuildMenuItem(
                            icon: Icons.help_outline,
                            text: 'About',
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences userData =
                                  await SharedPreferences.getInstance();
                              await userData.clear();
                              FirebaseAuth.instance.signOut();
                              Get.offAll(LoginPage());
                            },
                            child: const BuildMenuItem(
                              icon: Icons.logout,
                              text: 'Log Out',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Center(
                  child: CircularProgressIndicator(
                color: MyColors.primaryColor,
              ));
            }),
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
                          onTap: (){
                            // Get.to(()=>AdminMapScreen());

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
                              'Your current altitude',
                              style: TextStyle(
                                  fontSize: getFont(18),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: getHeight(10),
                            ),
                            Obx(
                              () => Text(
                                "${homeController.altitude.value.toStringAsFixed(0).toString()}m",
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
                        onMapCreated: homeController.onMapCreatedUser,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        // polylines: homeController.polyLines,
                        compassEnabled: true,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: true,
                        markers: homeController.userMarkers,
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(SingleToneValue.instance.currentLat,
                              SingleToneValue.instance.currentLng),
                          zoom: 17.161926040649414,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        )
        // GoogleMap(
        //    zoomGesturesEnabled: true,
        //    scrollGesturesEnabled: true,
        //    zoomControlsEnabled: false,
        //    compassEnabled: false,
        //    myLocationEnabled: false,
        //    myLocationButtonEnabled: false,
        //    mapType: MapType.normal,
        //    initialCameraPosition: CameraPosition(
        //      target: LatLng(
        //          31.4643687,
        //          74.2414678),
        //      zoom: 16.151926040649414,
        //    ),
        //    onMapCreated: homeController.onMapCreated2)

        // body: Stack(
        //   children: <Widget>[
        //     Column(
        //       children: <Widget>[
        //         Expanded(
        //           child: Container(color: Colors.deepPurple),
        //           flex: 3,
        //         ),
        //         Expanded(
        //           child: Container(color: Colors.transparent),
        //           flex: 5,
        //         ),
        //       ],
        //     ),
        //     Column(
        //       children: <Widget>[
        //         // header,
        //         Expanded(
        //           child: Container(
        //             padding:
        //                 const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        //             child: Stack(
        //               fit: StackFit.expand,
        //               children: [
        //                 GetBuilder(builder: (context) {
        //                   return GoogleMap(
        //                       zoomGesturesEnabled: true,
        //                       scrollGesturesEnabled: true,
        //                       zoomControlsEnabled: false,
        //                       compassEnabled: false,
        //                       myLocationEnabled: false,
        //                       myLocationButtonEnabled: false,
        //                       mapType: MapType.normal,
        //                       initialCameraPosition: CameraPosition(
        //                         target: LatLng(
        //                             31.4643687,
        //                             74.2414678),
        //                         zoom: 16.151926040649414,
        //                       ),
        //                       onMapCreated: homeController.onMapCreated);
        //                 }),
        //                 Center(
        //                     child: Padding(
        //                         padding: const EdgeInsets.only(bottom: 16.0),
        //                         child: Image.asset(
        //                           MyImgs.pinImg,
        //                           height: Dimens.size35,
        //                         ))),
        //                 Align(
        //                   alignment: Alignment.topCenter,
        //                   child: Padding(
        //                     padding: const EdgeInsets.only(top: 100),
        //                     child: SizedBox(
        //                       height: getHeight(Dimens.size60),
        //                       width: 600,
        //                       child: Container(
        //                         color: MyColors.primaryColor,
        //                         child: Row(
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           crossAxisAlignment: CrossAxisAlignment.center,
        //                           children: [
        //                             SizedBox(
        //                               width: getWidth(Dimens.size30),
        //                             ),
        //                             const SizedBox(
        //                                 width: 25,
        //                                 child: Icon(
        //                                   Icons.wifi,
        //                                   color: MyColors.white,
        //                                 )),
        //                             SizedBox(
        //                               width: getWidth(Dimens.size30),
        //                             ),
        //                             Text(
        //                               "currentlyonline".tr,
        //                               style: textTheme.headline4!.copyWith(
        //                                   color: MyColors.white,
        //                                   fontSize: getFont(16),
        //                                   fontWeight: FontWeight.w400),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     )
        //   ],
        // ),
        // body: ListView.builder(
        //   itemCount: Users.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     var User = Users[index];
        //     return ListTile(
        //       title: Text(User.name),
        //       subtitle: Text(User.detail),
        //       leading: FlutterLogo(),
        //       trailing: IconButton(
        //         icon: Icon(User.isFav ? Icons.favorite : Icons.favorite_border),
        //         onPressed: () => {
        //           setState(
        //                 () {
        //               User.isFav = !User.isFav;
        //             },
        //           )
        //         },
        //       ),
        //     );
        //   },
        // ),

        // body: Container(
        //   height: height,
        //   child: Stack(
        //     children: <widget>[
        //       Positioned(
        //           top: -height * .15,
        //           right: -MediaQuery.of(context).size.width * .4,
        //           child: BezierContainer()),
        //       Container(
        //         padding: EdgeInsets.symmetric(horizontal: 20),
        //         child: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: <widget>[
        //               SizedBox(height: height * .2),
        //               // _title(),
        //               SizedBox(height: 50),
        //               // _emailPasswordWidget(),
        //               SizedBox(height: 20),
        //               // _submitButton(),
        //               Container(
        //                 padding: EdgeInsets.symmetric(vertical: 10),
        //                 alignment: Alignment.centerRight,
        //                 child: Text('',
        //                     style: TextStyle(
        //                         fontSize: 14, fontWeight: FontWeight.w500)),
        //               ),
        //               // _divider(),
        //               // _facebookButton(),
        //               SizedBox(height: height * .055),
        //               // _createAccountLabel(),
        //             ],
        //           ),
        //         ),
        //       ),
        //       Positioned(top: 40, left: 0, child: _backButton()),
        //     ],
        //   ),
        // ));
        );
  }

// get dashBg => Column(
//       children: <Widget>[
//         Expanded(
//           child: Container(color: Colors.deepPurple),
//           flex: 2,
//         ),
//         Expanded(
//           child: Container(color: Colors.transparent),
//           flex: 5,
//         ),
//       ],
//     );
//
// get content => Container(
//       child: Column(
//         children: <Widget>[
//           // header,
//           grid,
//         ],
//       ),
//     );

// get header => ListTile(
//       contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
//       title: Text(
//         FirebaseAuth.instance.currentUser!.email.toString(),
//         style: const TextStyle(color: Colors.white),
//       ),
//       subtitle: const Text(
//         'Comsats Attock',
//         style: TextStyle(color: Colors.blue),
//       ),
//       trailing: GestureDetector(
//         onTap: (){
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => MapScreen()));
//         },
//         child: const CircleAvatar(),
//       ),
//     );

// get grid => Expanded(
//       child: Container(
//         padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//       ),
//     );
}
