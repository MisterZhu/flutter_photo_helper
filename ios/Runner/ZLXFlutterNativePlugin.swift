//
//  ZLXFlutterNativePlugin.swift
//  Runner
//
//  Created by Ge YuMing on 2024/1/7.
//

import UIKit
import Flutter

class ZLXFlutterNativePlugin: NSObject, FlutterPlugin {
    
    static let shared = ZLXFlutterNativePlugin()
    
    var eventSink: FlutterEventSink?
    var messageArray: [Any] = []
    var flutterController: FlutterViewController?
    var messenger: FlutterBinaryMessenger?

    private override init() {
        super.init()
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        shared.messenger = (UIApplication.shared.delegate?.window??.rootViewController as! FlutterBinaryMessenger)
//        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

//        shared.messenger = registrar.messenger()
        shared.flutterController = (UIApplication.shared.delegate?.window??.rootViewController as! FlutterViewController)
        shared.imgProcesPlugin()
    }
    
    func imgProcesPlugin() {
        let channel = FlutterMethodChannel(name: "plugin_apple", binaryMessenger: self.messenger!)
       channel.setMethodCallHandler { (call:FlutterMethodCall, result:@escaping FlutterResult) in
       
           if (call.method == "sendImageToNative") {
               if let arguments = call.arguments as? [String: Any],
                  let imagePath = arguments["imagePath"] as? String {
                   print(imagePath);
                   self.sendImageToNative(imagePath, result: result);
               }
//               result(["result":"success","code":200]);
           }
       }
    }
    @objc func sendImageToNative(_ imagePath: String, result: @escaping FlutterResult) {
        let mlViewController = MLStillViewController()
        mlViewController.btn01Clicked(imagePath) { imgData in
            result(["result": "success", "code": 200, "imgData": imgData])
        }
    }

//    func imgProcesPlugin() {
//        let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
//                                                  binaryMessenger: flutterController!.binaryMessenger)
//        batteryChannel.setMethodCallHandler({
//          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//          // This method is invoked on the UI thread.
//          guard call.method == "getBatteryLevel" else {
//            result(FlutterMethodNotImplemented)
//            return
//          }
//          self?.receiveBatteryLevel(result: result)
//        })
//    }
//    private func receiveBatteryLevel(result: FlutterResult) {
//      let device = UIDevice.current
//      device.isBatteryMonitoringEnabled = true
//      if device.batteryState == UIDevice.BatteryState.unknown {
//        result(FlutterError(code: "UNAVAILABLE",
//                            message: "Battery level not available.",
//                            details: nil))
//      } else {
//        result(Int(device.batteryLevel * 100))
//      }
//    }

}

