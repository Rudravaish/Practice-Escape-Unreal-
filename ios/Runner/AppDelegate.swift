import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "unreal_bridge",
                                          binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "launchUnrealLevel":
                if let args = call.arguments as? [String: Any],
                   let levelName = args["levelName"] as? String {
                    self.launchUnrealLevel(levelName: levelName, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "levelName is required", details: nil))
                }
                
            case "isUnrealRunning":
                result(true) // Placeholder
                
            case "stopUnreal":
                self.stopUnreal(result: result)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func launchUnrealLevel(levelName: String, result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            let unrealVC = UnrealViewController(level: levelName)
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.rootViewController = unrealVC
                keyWindow.makeKeyAndVisible()
                result(true)
            } else {
                result(FlutterError(code: "NO_WINDOW", message: "Could not find window", details: nil))
            }
        }
    }
    
    private func stopUnreal(result: @escaping FlutterResult) {
        // Implement stop logic
        result(true)
    }
}
