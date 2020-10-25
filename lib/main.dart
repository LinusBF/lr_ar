

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lr_ar/ARView.dart';
import 'package:lr_ar/NativeCameraWrapper.dart';
import 'package:lr_ar/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: Color(0xFFFFFFFF),
      home: SafeArea(child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FOVAngles _angles;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    NativeCameraWrapper.getCameraFOV(0)
        .then((value) {
      setState(() {
        _angles = value;
      });
    });
    Geolocator.checkPermission()
      .then((LocationPermission permission) {
        if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){
          return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        } else {
          Geolocator.requestPermission().then((_) => Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
        }
      })
      .then((position) {
        setState(() {
          _currentPosition = position;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFFFFFFFF),
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: _angles == null
              ? Text('Loading FOV information')
              : Text('${_angles.angleX}, ${_angles.angleY}\n${radToDeg(_angles.angleX)}, ${radToDeg(_angles.angleY)}'),
        ),
        Align(
          alignment: Alignment.center,
          child: _currentPosition == null
              ? Text('Loading position information')
              : Text('${_currentPosition.latitude}, ${_currentPosition.longitude}, ${_currentPosition.heading}, ${_currentPosition.altitude}'),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.of(context)
                .push(CupertinoPageRoute(builder: (context) => ARView())),
            child: Container(
              color: Color(0xFFABC123),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45,
              child: Center(
                child: Text('Enter AR'),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
