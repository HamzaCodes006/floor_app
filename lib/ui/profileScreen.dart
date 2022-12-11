import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/values/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/profile_list_item.dart';
import 'loginPage.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context).textTheme;
    SizeConfig().init(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: MyColors.primaryColor,
                elevation: 5,
              ),
              body: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                            AssetImage('assets/images/appLogo.png'),
                      ),
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'SourceSansPro',
                          color: Colors.red[400],
                          letterSpacing: 2.5,
                        ),
                      ),
                      Text(
                        snapshot.data!.get('userName'),
                        style: TextStyle(
                            fontFamily: 'SourceSansPro',
                            fontSize: 25,
                            color: Colors.black),
                      ),

                      SizedBox(
                        height: 10.0,
                        width: 200,
                        child: Divider(
                          color: Colors.teal[100],
                        ),
                      ),
                      // SizedBox(height: size.height * 0.01),
                      Text(
                        snapshot.data!.get('email'),
                        style: theme.bodyText1!.copyWith(color: Colors.black),
                      ),
                    ],
                  ),

                  SizedBox(height: getHeight(35)),
                  // Column(
                  //   children: [
                  //     Text(
                  //       snapshot.data!.get('userName'),
                  //       style: theme.headline6,
                  //     ),
                  //     SizedBox(height: size.height * 0.01),
                  //     Text(
                  //       snapshot.data!.get('email'),
                  //       style: theme.headline6,
                  //     ),
                  //     SizedBox(height: size.height * 0.02),
                  //
                  //   ],
                  // ),
                  // buildName(user),
                  // SizedBox(height: 10),
                  // NumbersWidget(),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'CartScreen');
                    },
                    child: ProfileListItem(
                        name: 'My Home',
                        icon: Icons.home,
                        secondIcon: Icons.arrow_forward_ios),
                  ),
                  SizedBox(height: 10),
                  ProfileListItem(
                      name: 'My Chat',
                      icon: Icons.chat,
                      secondIcon: Icons.arrow_forward_ios),
                  // SizedBox(height: 10),
                  // ProfileListItem(
                  //     name: 'Favorite',
                  //     icon: Icons.shopping_cart_outlined,
                  //     secondIcon: Icons.arrow_forward_ios),
                  SizedBox(height: 10),
                  ProfileListItem(
                      name: 'Help',
                      icon: Icons.help,
                      secondIcon: Icons.arrow_forward_ios),
                  SizedBox(height: 10),
                  ProfileListItem(
                      name: 'Terms & Policies',
                      icon: Icons.policy,
                      secondIcon: Icons.arrow_forward_ios),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences userData =
                          await SharedPreferences.getInstance();
                      await userData.clear();
                      FirebaseAuth.instance.signOut();
                      Get.offAll(LoginPage());
                    },
                    child: ProfileListItem(
                      name: 'Log Out',
                      icon: Icons.logout,
                      secondIcon: Icons.arrow_forward_ios,
                    ),
                  ),
                  // SwitchListTile(
                  //     title: Text('Become a Seller', style: kBodyTextBlack,),
                  //     subtitle: Text('Turn switch on to go to seller mode.',
                  //       style: kBodyTextGrey,),
                  //     activeColor: MyColors.primaryColor,
                  //     value: convert, onChanged:(selected){
                  //       setState(() {
                  //         convert = !convert;
                  //       });
                  // }
                  // ),
                  SizedBox(height: 10),
                  // Expanded(
                  //   child: ListView(
                  //     children: <Widget>[
                  //       ProfileListItem(
                  //         icon: Icons.account_circle_outlined,
                  //         text: 'Privacy',
                  //       ),
                  //       ProfileListItem(
                  //         icon: Icons.account_circle_outlined,
                  //         text: 'Purchase History',
                  //       ),
                  //       ProfileListItem(
                  //         icon: Icons.account_circle_outlined,
                  //         text: 'Help & Support',
                  //       ),
                  //       ProfileListItem(
                  //         icon: Icons.account_circle_outlined,
                  //         text: 'Settings',
                  //       ),
                  //       ProfileListItem(
                  //         icon: Icons.account_circle_outlined,
                  //         text: 'Invite a Friend',
                  //       ),
                  //       ProfileListItem(
                  //         icon: Icons.account_circle_outlined,
                  //         text: 'Logout',
                  //         hasNavigation: false,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 48),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'About',
                  //         style: kBodyTextBlack,
                  //       ),
                  //       const SizedBox(height: 16),
                  //       Text(
                  //         user.about,
                  //         textAlign: TextAlign.justify,
                  //         style: kBodyTextGrey.copyWith( height: 1.4),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Text('Something Wrong Happens');
          }
          return Center(
              child: CircularProgressIndicator(
            color: MyColors.primaryColor,
          ));
        });
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Profile"),
    //     centerTitle: true,
    //   ),
    //   body: SafeArea(
    //     child: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           CircleAvatar(
    //             radius: 80,
    //             backgroundImage: AssetImage('assets/images/appLogo.png'),
    //           ),
    //           Text(
    //             'Baber',
    //             style: TextStyle(
    //               fontFamily: 'SourceSansPro',
    //               fontSize: 25,
    //               color: Colors.black
    //             ),
    //           ),
    //           Text(
    //             'Welcome',
    //             style: TextStyle(
    //               fontSize: 20,
    //               fontFamily: 'SourceSansPro',
    //               color: Colors.red[400],
    //               letterSpacing: 2.5,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 20.0,
    //             width: 200,
    //             child: Divider(
    //               color: Colors.teal[100],
    //             ),
    //           ),
    //
    //           Card(
    //               color: Colors.white,
    //               margin:
    //                   EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
    //               child: ListTile(
    //                 leading: Icon(
    //                   Icons.email,
    //                   color: Colors.black,
    //                 ),
    //                 title: Text(
    //                   'baber@gmail.com',
    //                   style: TextStyle( fontSize: 20.0),
    //                 ),
    //               )),
    //           Card(
    //             color: Colors.white,
    //             margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
    //             child: ListTile(
    //               leading: Icon(
    //                 Icons.cake,
    //                 color: Colors.teal[900],
    //               ),
    //               title: Text(
    //                 '08-05-1995',
    //                 style: TextStyle(fontSize: 20.0, fontFamily: 'Neucha'),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
    //             child: Container(
    //               height: 60.0,
    //               width: double.infinity,
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(8.0),
    //                 color: Colors.blueAccent,
    //               ),
    //               child: ElevatedButton(
    //                 onPressed: () async {
    //                   SharedPreferences userData =
    //                       await SharedPreferences.getInstance();
    //                   await userData.clear();
    //                   FirebaseAuth.instance.signOut();
    //                  Get.offAll(LoginPage());
    //                 },
    //                 child: Text(
    //                   'Log out',
    //                   style: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.white,
    //                       fontSize: 18.0),
    //                 ),
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
