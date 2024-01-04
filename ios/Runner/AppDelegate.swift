import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let messenger : FlutterBinaryMessenger = window?.rootViewController as! FlutterBinaryMessenger
         
      testPlugin(messenger: messenger)

      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                                binaryMessenger: controller.binaryMessenger)
      batteryChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        // This method is invoked on the UI thread.
        guard call.method == "getBatteryLevel" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.receiveBatteryLevel(result: result)
      })


      GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    func testPlugin(messenger: FlutterBinaryMessenger) {
       let channel = FlutterMethodChannel(name: "plugin_apple", binaryMessenger: messenger)
       channel.setMethodCallHandler { (call:FlutterMethodCall, result:@escaping FlutterResult) in
       
           if (call.method == "sendImageToNative") {
               if let arguments = call.arguments as? [String: Any],
                  let imagePath = arguments["imagePath"] as? String {
                   print(imagePath);
               }
               result(["result":"success","code":200]);
           }
           
           if (call.method == "sendImageDataToNative") {
               if let arguments = call.arguments as? [String: Any],
                  let imagePath = arguments["imagePath"] as? String {
                   print(imagePath);
               }
               result(["result":"success","code":404]);
           }

       }
    }
    private func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      if device.batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Battery level not available.",
                            details: nil))
      } else {
        result(Int(device.batteryLevel * 100))
      }
    }
}


