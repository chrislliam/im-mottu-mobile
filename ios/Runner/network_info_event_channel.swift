import Flutter
import UIKit
import SystemConfiguration

class NetworkInfoEventChannel: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    private var reachability: SCNetworkReachability?
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterEventChannel(name: "com.mottu.marvel.im_mottu_mobile/connectivity/event", binaryMessenger: registrar.messenger())
        let instance = NetworkInfoEventChannel()
        channel.setStreamHandler(instance)
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startMonitoringNetwork()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        stopMonitoringNetwork()
        return nil
    }

    private func startMonitoringNetwork() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        
        var context = SCNetworkReachabilityContext(version: 0, info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), retain: nil, release: nil, copyDescription: nil)
        
        SCNetworkReachabilitySetCallback(reachability!, { (_, flags, info) in
            let eventSink = Unmanaged<NetworkInfoEventChannel>.fromOpaque(info!).takeUnretainedValue().eventSink
            
            if let eventSink = eventSink {
                
                let isConnected = flags.contains(.reachable) && !flags.contains(.connectionRequired)
                eventSink(isConnected)
            }
        }, &context)
        
        SCNetworkReachabilityScheduleWithRunLoop(reachability!, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
    }

    private func stopMonitoringNetwork() {
        if let reachability = reachability {
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
            self.reachability = nil
        }
    }
}
