import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/data/controllers/home_controller.dart';
import 'package:floor_app/ui/admin_screens/admin_profile_screen.dart';
import 'package:floor_app/ui/admin_screens/admin_record_screen.dart';
import 'package:floor_app/ui/admin_screens/admin_map_screen.dart';
import 'package:floor_app/ui/chat/admin_main_chat_screen.dart';
import 'package:floor_app/ui/loginPage.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../values/size_config.dart';
import 'all_user_screen.dart';
import 'new_user_requests_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({Key? key}) : super(key: key);
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        backgroundColor: MyColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: getHeight(10),
            ),
            SizedBox(
              // height: getHeight(300),
              width: double.infinity,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: getHeight(270),
                  autoPlay: true,
                  // aspectRatio: 2.2,
                  enlargeCenterPage: true,
                ),
                items: homeController.imgList
                // homeScreenController.homeScreenModel.data!.banner!
                    .map((item) => Container(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ClipRRect(
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5.0)),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: getWidth(600),
                            height: getHeight(230),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // image: DecorationImage(
                              //   fit: BoxFit.cover,
                              //   colorFilter: ColorFilter.mode(
                              //       Colors.black54, BlendMode.darken),
                              // ),
                            ),
                            child: Image.asset(
                              item,
                              fit: BoxFit.cover,
                              height: getHeight(300),
                              width: getHeight(700),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(

                              // gradient: LinearGradient(
                              //   colors: [
                              //     Color.fromARGB(200, 0, 0, 0),
                              //     Color.fromARGB(0, 0, 0, 0)
                              //   ],
                              //   begin: Alignment.bottomCenter,
                              //   end: Alignment.topCenter,
                              // ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: getHeight(10),
                                horizontal: getWidth(20)),
                            child: SizedBox(
                              width: getWidth(200),
                              child: const Text(
                                'Real TimeTracking System',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ))
                    .toList(),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    AdminDashboardCard(
                      onTap: () {
                        Get.to(AdminMapScreen());
                      },
                      cardType: 'Map',
                      image: "assets/images/img3.jpg",
                    ),
                    AdminDashboardCard(
                      onTap: () {
                        Get.to(const AdminMainChatScreen());
                      },
                      cardType: 'Complains',
                      image: "assets/images/img6.jpeg",
                    ),
                  ],
                ),
                Row(
                  children: [
                    AdminDashboardCard(
                      onTap: () {
                        Get.to(const AllUsersPage());
                      },
                      cardType: 'Members',
                      image: 'assets/images/img6.jpeg',
                    ),
                    AdminDashboardCard(
                      onTap: () {
                        Get.to(AdminProfileScreen());
                      },
                      cardType: 'Profile',
                      image: 'assets/images/img2.jpeg',
                    ),
                    // AdminDashboardCard(
                    //   cardType: 'Record',
                    //   image: 'assets/images/img7.jpeg',
                    // ),
                  ],
                ),
                Row(
                  children: [
                    AdminDashboardCard(
                      onTap: () {
                        Get.to(
                            NewUsersRequestsPage());
                      },
                      cardType: 'New Users',
                      image: 'assets/images/img7.jpeg',
                    ),
                    AdminDashboardCard(
                      onTap: () async {
                        SharedPreferences userData =
                        await SharedPreferences.getInstance();
                        await userData.clear();
                        FirebaseAuth.instance.signOut();
                        Get.offAll(LoginPage());
                      },
                      cardType: 'Log Out',
                      image: 'assets/images/img3.jpg',
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AdminDashboardCard extends StatelessWidget {
  final String cardType;
  final String image;
  Function()? onTap;

  AdminDashboardCard(
      {super.key, required this.cardType, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 130,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.primaryColor,
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.25),
            ),
            child: Center(
              child: Text(
                cardType,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
