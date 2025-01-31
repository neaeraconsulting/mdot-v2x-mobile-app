import Flutter
import UIKit
import Kronos

public class SwiftFlutterKronosPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_kronos_plus", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterKronosPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "SYNC":
        Clock.sync(from: "time.aws.com")
        result(nil)
    case "GET_CURRENT_TIME_MS":
        let now = Clock.now?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        result(Int64(now*1000))
    case "GET_CURRENT_NTP_TIME_MS":
        guard let ntpTime = Clock.now else {
            result(nil)
            return
        }
        result(Int64(ntpTime.timeIntervalSince1970*1000))
    default:
        result(FlutterMethodNotImplemented);
    }
  }
}
