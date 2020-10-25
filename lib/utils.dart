import 'dart:async';
import 'dart:math';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

double radToDeg(double rad) {
  return rad * 180 / pi;
}

double degToRad(double deg) {
  return deg * pi / 180;
}

Future<Stream<Position>> getPosStream() {
  return Geolocator.checkPermission().then((LocationPermission permission) {
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }
    else {
      return Geolocator.requestPermission().then((newPermission) {
        if(permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          return true;
        } else {
          return false;
        }
      });
    }
  }).then((gotPermission) {
    if(gotPermission) {
      return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high);
    } else {
      return null;
    }
  });
}

Stream<CompassEvent> getHeadingStream() {
  return FlutterCompass.events;
}

