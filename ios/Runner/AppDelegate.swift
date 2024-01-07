import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      GeneratedPluginRegistrant.register(with: self as FlutterPluginRegistry)

      // 获取 FlutterPluginRegistrar
      guard let registrar = self.registrar(forPlugin: "ZLXFlutterNativePlugin") else {
            fatalError("Could not find FlutterPluginRegistrar for ZLXFlutterNativePlugin")
      }
        
      // 调用 ZLXFlutterNativePlugin 的 register 方法，传递 FlutterPluginRegistrar 参数
      ZLXFlutterNativePlugin.register(with: registrar)
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
   
    
}


