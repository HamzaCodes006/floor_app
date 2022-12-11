import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/ui/admin_screens/admin_dashboard_screen.dart';
import 'package:floor_app/ui/homePage.dart';
import 'package:floor_app/ui/loginPage.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/widget/toasts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/admin_screens/admin_home_page.dart';

class AuthController extends GetxController {
  String pickerError = '';
  bool isPicAvail = false;
  String? email;
  String? password;
  String error = '';
  String pickError = '';
  User? user = FirebaseAuth.instance.currentUser;

  ///Register buyer using email
  Future<UserCredential?> registerUser({
    required String email,
    required String password,
    required String userName,
    required BuildContext context,
  }) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: MyColors.primaryColor,
        ),
      ),
      barrierDismissible: false,
    );
    this.email = email;
    update();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        FirebaseFirestore.instance
            .collection('User')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'userName': userName,
          'email': userCredential.user!.email,
          'password': password,
          'status': 'online',
          'approved': false,
        }).then(
              (value) {
            print('User Registered');
            FirebaseAuth.instance.signOut().then((value) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    "Account Verification!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  content: const Text(
                    "Please Wait Few Hours.\nYour Account is being verified by the Admin and then you will Login.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Get.offAll(LoginPage());
                      },
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          "Okay",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      });
      CustomToast.successToast(msg: 'User Register Successfully!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
        CustomToast.failToast(
            msg: 'The password provided is too weak.', len: 4);
        update();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
        CustomToast.failToast(
            msg: 'The account already exists for that email.');
        update();
      }
    } catch (e) {
      error = e.toString();
      CustomToast.failToast(msg: e.toString());
      update();
    }
    Get.back();

    return userCredential;
  }

  ///Login user using email
  Future<UserCredential?> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    Get.dialog(
        const Center(
            child: CircularProgressIndicator(
              color: MyColors.primaryColor,
            )),
        barrierDismissible: false);
    this.email = email;
    update();
    final prefs = await SharedPreferences.getInstance();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((loginUSer) {
        FirebaseFirestore.instance
            .collection('User')
            .doc(loginUSer.user!.uid)
            .get()
            .then((doc) {
          if (doc.get('approved') == true) {
            prefs.setString('email', email);
            CustomToast.successToast(msg: 'Logged In Successfully!');
            // Get.offAll(HomePage());
            loginUSer.user!.email == "admin@gmail.com"
                ? Get.offAll(() => AdminDashboardScreen())
                : Get.offAll(() => HomePage());
          } else {
            FirebaseAuth.instance.signOut().then((value) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text(
                    "Account Verification!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  content: const Text(
                    "Please Wait Few Hours.\nYour Account is being verified by the Admin and then you will Login.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(14),
                        child: const Text(
                          "Okay",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
          }
        });
      });

      // Navigator.pushReplacementNamed(context, HomeScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
        CustomToast.failToast(msg: 'No user found for that email.');

        update();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided .';
        update();
        CustomToast.failToast(msg: 'Wrong password .');
        print(error);
      }
    }
    // } catch (e) {
    //   this.error = e.toString();
    //   notifyListeners();
    //   print(e);
    // }
    Get.back();
    return userCredential;
  }

// //Save user data to DB
// Future<void> saveUserDataToDB({
//   String? userName,
//   String? email,
//   String? password,
//   // bool shopCreated,
// }) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   FirebaseFirestore.instance
//       .collection('User')
//       .doc(FirebaseAuth.instance.currentUser?.uid)
//       .set({
//     'uid': user?.uid,
//     'userName': userName,
//     'email': this.email,
//     'password': password,
//   });
// }
}
