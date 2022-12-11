import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

// import 'package:flutter_barometer/flutter_barometer.dart';
import 'package:flutter_barometer_plugin/flutter_barometer.dart';
import 'package:get/get.dart';

// void main() {
//   runApp(MyApp());
// }

class BarometerScreen extends StatefulWidget {
  @override
  _BarometerScreenState createState() => _BarometerScreenState();
}

class _BarometerScreenState extends State<BarometerScreen> {
  BarometerValue _currentPressure = BarometerValue(0.0);

  @override
  void initState() {
    super.initState();
    FlutterBarometer.currentPressureEvent.listen((event) {
      setState(() {
        _currentPressure = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_barometer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(_currentPressure.hectpascal * 1000).round() / 1000} hPa',
                style: TextStyle(
                  fontSize: 70,
                ),
              ),
              Text(
                '${(_currentPressure.inchOfMercury * 1000).round() / 1000} inHg',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                '${(_currentPressure.millimeterOfMercury * 1000).round() / 1000} mmHg',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                '${(_currentPressure.poundsSquareInch * 1000).round() / 1000} psi',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                '${(_currentPressure.atm * 1000).round() / 1000} atm',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_chart),
          onPressed: () {

            FlutterBarometer.currentPressureEvent.listen((event) {

              setState(() {
                _currentPressure = event;
                Get.log(".............$event}");
                Get.log("button pressed!");
              });
            });
          },
        ),
      ),
    );
  }
}
