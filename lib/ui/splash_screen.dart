import 'dart:async';

import 'package:floor_app/ui/admin_screens/admin_dashboard_screen.dart';
import 'package:floor_app/ui/homePage.dart';
import 'package:floor_app/ui/loginPage.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_screens/admin_map_screen.dart';

String? finalEmail;

class SplashScreen extends StatefulWidget {
  static const String id = 'SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getValidationData()
        .whenComplete(() => Timer(const Duration(seconds: 2), () async {
              //     Navigator.pushReplacementNamed(
              //         context, finalEmail == null ? LoginScreen.id : HomeScreen.id);
              Get.offAll(finalEmail == null
                  ? LoginPage()
                  : finalEmail == "admin@gmail.com"
                      ? AdminDashboardScreen()
                      : HomePage());
            }));
    super.initState();
  }

  Future getValidationData() async {
    final prefs = await SharedPreferences.getInstance();
    var obtainedEmail = prefs.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
    print('final Email:$finalEmail');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                width: double.infinity,
                height: getHeight(300),
                child: Image.asset('assets/images/appLogo.png'),
              ),
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MyColors.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
