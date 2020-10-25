import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class ARView extends StatefulWidget {
  @override
  _ARViewState createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
  CameraController _camera;
  CameraLensDirection _direction = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final CameraDescription description = (await availableCameras()).firstWhere((camera) => camera.lensDirection == _direction);
    _camera = CameraController(
      description,
      ResolutionPreset.high
    );
    await _camera.initialize();
    _camera.startImageStream((CameraImage image) {});
    this.setState(() {
      _camera = _camera;
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
          AROverlay(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }
}

class AROverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 50,
            height: 50,
            color: Color(0xFF00000),
            child: Center(
              child: Text('X'),
            ),
          ),
        ),
      ),
    );
  }
}

