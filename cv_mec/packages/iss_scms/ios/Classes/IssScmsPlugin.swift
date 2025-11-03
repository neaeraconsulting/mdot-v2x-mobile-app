import Flutter
import UIKit
import trafficauth_v2xclient_ios
// import Algorithms
// import TrafficAuthV2XClient

public class IssScmsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "iss_scms", binaryMessenger: registrar.messenger())
    let instance = IssScmsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    LocalSigning.init(scmsEnv: ScmsEnvironment.PREPRODUCTION)

  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
