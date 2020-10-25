import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let wrapperChannel = FlutterMethodChannel(name: "lr_ar.linusbf.com/wrapped",
                                                binaryMessenger: controller.binaryMessenger)
      wrapperChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread.
        guard call.method == "getCameraFOV" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.retrieveMessage(call: call, result: result)
      })

      GeneratedPluginRegistrant.register(with: self)
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func retrieveMessage(result: @escaping FlutterResult) {
      result(-1.0)
    }
}
