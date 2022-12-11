import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/ui/homePage.dart';
import 'package:floor_app/ui/loginPage.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/widget/bezierContainer.dart';
import 'package:floor_app/widget/toasts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/controllers/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthController authController = Get.put(AuthController());
  String? userName, email, password;

  final _auth = FirebaseAuth.instance;
  bool _saving = false;
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await authController
              .registerUser(
            email: _emailController.text,
            password: _passwordController.text,
            userName: _userNameController.text,
            context: context,
          )
              .then((credentials) {
            // if (credentials?.user?.uid != null) {
            //   // print(credentials.user.uid);
            //   authController
            //       .saveUserDataToDB(
            //           userName: _userNameController.text,
            //           email: _emailController.text,
            //           password: _passwordController.text)
            //       .then((value) {
            //     setState(() {
            //       _formKey.currentState!.reset();
            //       _saving = false;
            //     });
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => HomePage()));
            //     print('Data stored succssfully');
            //   }).catchError((onError) {
            //     print('some error occur');
            //   });
            // }
          });
        } else {
          CustomToast.failToast(msg: 'Please enter valid data');
        }

        // // Navigator.push(
        // //     context, MaterialPageRoute(builder: (context) => HomePage()));
        // _onLoading();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: const Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text("Loading"),
            ],
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
    });
  }

  Widget _facebookButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     decoration: const BoxDecoration(
            //       color: Color(0xff1959a9),
            //       borderRadius: BorderRadius.only(
            //           bottomLeft: Radius.circular(5),
            //           topLeft: Radius.circular(5)),
            //     ),
            //     alignment: Alignment.center,
            //     child: const Text('f',
            //         style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 25,
            //             fontWeight: FontWeight.w400)),
            //   ),
            // ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff2872ba),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                alignment: Alignment.center,
                child: const Text('Already Have An Account: Click Here.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Real Time',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: ' Employee',
              style: TextStyle(color: MyColors.primaryColor, fontSize: 30),
            ),
            TextSpan(
              text: ' Tracking System',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.008, horizontal: size.width * 0.025),
            child: TextFormField(
              controller: _userNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your User Name!';
                }
                setState(() {
                  userName = value;
                });
                return null;
              },
              style: TextStyle(
                fontSize: size.height * 0.025,
                // fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
              decoration: InputDecoration(
                fillColor: Colors.orange[200]!.withOpacity(0.4),
                filled: true,
                //hoverColor: kDarkBlue,
                // helperText: 'Add Text',
                hintStyle: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Colors.orange,
                ),
                labelText: 'Username',
                labelStyle: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.orange,
                ),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                // focusColor: kOrange,
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.008, horizontal: size.width * 0.025),
            child: TextFormField(
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Email';
                }
                setState(() {
                  email = value;
                });
                return null;
              },
              style: TextStyle(
                fontSize: size.height * 0.025,
                // fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
              decoration: InputDecoration(
                fillColor: Colors.orange[200]!.withOpacity(0.4),
                filled: true,
                //hoverColor: kDarkBlue,
                // helperText: 'Add Text',
                hintStyle: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.orange,
                ),
                labelText: 'Email',
                labelStyle: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.orange,
                ),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                // focusColor: kOrange,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.008, horizontal: size.width * 0.025),
            child: TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Password!';
                }
                if (value.length < 6) {
                  return 'Minimum 6 characters';
                }
                setState(() {
                  password = value;
                });
                return null;
              },
              style: TextStyle(
                fontSize: size.height * 0.025,
                // fontWeight: FontWeight.bold,
                //color: Colors.white
              ),
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.orange[200]!.withOpacity(0.4),
                filled: true,
                //hoverColor: kDarkBlue,
                // helperText: 'Add Text',
                hintStyle: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(
                  Icons.key,
                  color: Colors.orange,
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  fontSize: 17.0,
                  color: Colors.orange,
                ),
                contentPadding: EdgeInsets.zero,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.orange),
                ),
                // focusColor: kOrange,
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _facebookButton(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
