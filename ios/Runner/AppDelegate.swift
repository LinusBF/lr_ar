import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let wrapperChannel = FlutterMethodChannel(name: "lr_ar.linusbf.com/wrapped", binaryMessenger: controller.binaryMessenger)
      wrapperChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread.
        guard call.method == "getCameraFOV" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.getNativeCameraFOV(result: result)
      })

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getNativeCameraFOV(result: @escaping FlutterResult) {
        let encoder = JSONEncoder()
        
        var HFOV : Float = -1
        var VFOV : Float = -1
        
        let devices = AVCaptureDevice.devices()
            var captureDevice : AVCaptureDevice?
            for device in devices {
                if (device.hasMediaType(AVMediaType.video)) {
                    if(device.position == AVCaptureDevice.Position.back) {
                        captureDevice = device
                    }
                }
            }
            if let retrievedDevice = captureDevice {
                HFOV = retrievedDevice.activeFormat.videoFieldOfView
                VFOV = ((HFOV)/16.0)*9.0
            }
        
        let cameraFOV = CameraFOV(x: HFOV, y: VFOV)
        let jsonData = try! encoder.encode(cameraFOV)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        result(jsonString)
    }
}

public struct CameraFOV : Codable{
    var x: Float
    var y: Float
}
