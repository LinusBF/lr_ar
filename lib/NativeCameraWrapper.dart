import 'dart:convert';

import 'package:flutter/services.dart';

class NativeCameraWrapper {
  static const platform = const MethodChannel('lr_ar.linusbf.com/wrapped');

  static Future<FOVAngles> getCameraFOV(cameraId) async {
    FOVAngles fovAngle = FOVAngles();
    try {
      final String result = await platform.invokeMethod('getCameraFOV', {"cameraId": cameraId});
      print('Got $result back from camera FOV query scanning');
      Map<String, dynamic> parsedResult = jsonDecode(result);
      fovAngle.angleX = parsedResult['x'].toDouble(); 
      fovAngle.angleY = parsedResult['y'].toDouble();
    } on PlatformException catch (e) {
      print('NFC native function scanNFCChip failed with message: ${e.message}');
    }
    return fovAngle;
  }
}

class FOVAngles {
  double angleX;
  double angleY;
}