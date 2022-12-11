import 'package:floor_app/ui/chat/admin_main_chat_screen.dart';
import 'package:floor_app/ui/map_screens/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:moony_nav_bar/moony_nav_bar.dart';

import '../../values/my_colors.dart';
import 'admin_map_screen.dart';
import '../profileScreen.dart';
import 'admin_dashboard_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final Widget _screen1 = AdminMapScreen();
  final Widget _screen2 = const AdminMainChatScreen();
  final Widget _screen3 = AdminDashboardScreen();
  final Widget _screen4 = ProfileScreen();
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        body: getBody(),
        bottomNavigationBar: MoonyNavigationBar(
          items: <NavigationBarItem>[
            NavigationBarItem(
                icon: Icons.home_rounded,
                indicatorColor: Colors.white,
                activeIcon: Icons.home_rounded,
                color: Colors.white,
                onTap: () {
                  onTapHandler(0);
                }),
            NavigationBarItem(
                icon: Icons.chat,
                indicatorColor: Colors.white,
                color: Colors.white,
                activeIcon: Icons.chat,
                // color: Colors.pink,
                // indicatorColor: Colors.white,
                onTap: () {
                  onTapHandler(1);
                }),
            NavigationBarItem(
                icon: Icons.map,
                indicatorColor: Colors.white,
                color: Colors.white,
                activeIcon: Icons.map,
                onTap: () {
                  onTapHandler(2);
                }),
            NavigationBarItem(
                icon: Icons.person_outline,
                indicatorColor: Colors.white,
                color: Colors.white,
                activeIcon: Icons.person_outline,
                onTap: () {
                  onTapHandler(3);
                })
          ],
          style: MoonyNavStyle(
            elevation: 2.0,
            backgroundColor: MyColors.primaryColor,
            activeColor: MyColors.white,
            // indicatorColor: Colors.white,
            indicatorPosition: IndicatorPosition.TOP,
            indicatorType: IndicatorType.POINT,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _screen1;
    } else if (selectedIndex == 1) {
      return _screen2;
    } else if (selectedIndex == 2) {
      return _screen3;
    }
    return _screen4;
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
