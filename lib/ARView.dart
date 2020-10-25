import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lr_ar/CloseButton.dart';
import 'package:lr_ar/NativeCameraWrapper.dart';
import 'package:lr_ar/StatsBlock.dart';
import 'package:lr_ar/utils.dart';

class ARView extends StatefulWidget {
  @override
  _ARViewState createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  CameraController _camera;
  CameraLensDirection _direction = CameraLensDirection.back;
  StreamSubscription<Position> _positionStream;
  Position _currentPosition;
  FOVAngles _cameraAngles;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializePosition();
  }

  void _initializeCamera() async {
    final CameraDescription description = (await availableCameras()).firstWhere((camera) => camera.lensDirection == _direction);
    _camera = CameraController(description, ResolutionPreset.high);
    print('Name: ${description.name}');
    await _camera.initialize();
    this.setState(() {
      _camera = _camera;
    });

    NativeCameraWrapper.getCameraFOV(0).then((value) {
      setState(() {
        _cameraAngles = value;
      });
    });
  }

  void _initializePosition() {
    getPosStream()
        .then((stream) {
      _positionStream = stream.listen((Position position) {
        setState(() {
          _currentPosition = position;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _camera == null ? Center(child: Text('Initializing...', style: TextStyle(color: Color(0xFFABC123)),),) : CameraPreview(_camera),
          AROverlay(pos: _currentPosition,),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _camera.dispose();
    super.dispose();
  }
}

class AROverlay extends StatelessWidget {
  final Position pos;

  const AROverlay({Key key, this.pos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            CloseButton(),
            StatsBlock(pos: pos,),
          ],
        )
    );
  }
}

