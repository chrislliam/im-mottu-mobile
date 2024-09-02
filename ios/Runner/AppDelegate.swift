import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

    private var eventChannel: FlutterEventChannel?
    private var methodChannel: FlutterMethodChannel?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        eventChannel = FlutterEventChannel(name: "com.mottu.marvel.im_mottu_mobile/connectivity/event",
                                           binaryMessenger: controller.binaryMessenger)
        eventChannel?.setStreamHandler(NetworkInfoEventChannel())

        methodChannel = FlutterMethodChannel(name: "com.mottu.marvel.im_mottu_mobile/connectivity/method",
                                             binaryMessenger: controller.binaryMessenger)
        
        methodChannel?.setMethodCallHandler { [weak self] (call, result) in
            self?.handleMethodCall(call: call, result: result)
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "isConnected" {
            let isConnected = NetworkInfoMethodChannel().isConnectedToNetwork() 
            result(isConnected)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
