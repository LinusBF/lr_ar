

import 'package:flutter/cupertino.dart';
import 'package:lr_ar/ARView.dart';
import 'package:lr_ar/NativeCameraWrapper.dart';

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

  @override
  void initState() {
    super.initState();
    NativeCameraWrapper.getCameraFOV(0)
        .then((value) {
      setState(() {
        _angles = value;
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
          child: _angles == null ? Text('Loading FOV information') : Text('${_angles.angleX}, ${_angles.angleY}'),
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
