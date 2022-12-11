import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor_app/ui/homePage.dart';
import 'package:floor_app/ui/signup.dart';
import 'package:floor_app/values/my_colors.dart';
import 'package:floor_app/widget/bezierContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthController authController = Get.put(AuthController());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  bool _saving = false;
  bool _visible = false;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              Text("Loading"),
            ],
          ),
        );
      },
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
          const CircularProgressIndicator(
            color: MyColors.primaryColor,
          );
          authController
              .loginUser(
            email: _emailController.text,
            password: _passwordController.text,
            context: context,
          )
              .then((value) {
            ///do whatever you want to do
            // Get.back();
            // Get.offAll(() => HomePage());
          });

          // final _authData = Provider.of<AuthController>(
          //     context,listen: false
          // );
          setState(() {
            _saving = true;
          });
          // try {
          //   await FirebaseAuth.instance.signInWithEmailAndPassword(
          //     email: email!,
          //     password: password!,
          //   ).then((value) {
          //     Navigator.pushReplacement(
          //         context, MaterialPageRoute(builder: (context) => HomePage()));
          //   });
          //   //
          //   // _authData
          //   //     .loginUser(email, password)
          //   //     .then((credential) async {
          //   //       print('credentialssssssssssssssss$credential');
          //   //
          //
          //
          // } on FirebaseAuthException catch (e) {
          //   if (e.code == 'user-not-found') {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //             const SnackBar(content: Text('No user record corresponding to this email found!')));
          //     // this.error = 'No user found for that email.';
          //     // print('No user found for that email.');
          //   } else if (e.code == 'wrong-password') {
          //     // this.error = 'Wrong password provided .';
          //     // print('Wrong password .');
          //     ScaffoldMessenger.of(context).showSnackBar(
          //               const SnackBar(content: Text('Invalid Password!')));
          //   }
          // }
          // catch (e) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text('Invalid Credentials!')));
          //   setState(() {
          //     _saving = false;
          //   });
          // }
        }
        // _onLoading();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
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
                child: const Text('Don\'t Have An Account: Click Here.',
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
          text: 'Real Time ',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: 'Employee ',
              style: TextStyle(color: MyColors.primaryColor, fontSize: 30),
            ),
            TextSpan(
              text: 'Tracking System',
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
                prefixIcon: const Icon(
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
                  borderSide: const BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
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
                prefixIcon: const Icon(
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
                  borderSide: const BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
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
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  const SizedBox(height: 50),
                  _emailPasswordWidget(),
                  const SizedBox(height: 20),
                  _submitButton(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: const Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  _divider(),
                  _facebookButton(),
                  SizedBox(height: height * .055),
                  // _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
