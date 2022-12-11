import 'package:firebase_core/firebase_core.dart';
import 'package:floor_app/ui/splash_screen.dart';
import 'package:floor_app/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  // Provider.debugCheckInvalidValueType=null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flood App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
      //     bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
      //   ),
      // ),
      theme: Styles.appTheme,

      getPages: [
        GetPage<void>(
            name: '/', page: () => SplashScreen(),),
      ],
    );
  }
}
