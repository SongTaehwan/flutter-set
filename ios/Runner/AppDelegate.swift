import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		let controller = window?.rootViewController as! FlutterViewController
		configurePigeonSetup(binaryMessenger: controller.binaryMessenger)
		GeneratedPluginRegistrant.register(with: self)
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}

// Flutter -> Native
extension AppDelegate {
	private func configurePigeonSetup(binaryMessenger: FlutterBinaryMessenger) {
		let flutterApi = SpeechFlutterApi(binaryMessenger: binaryMessenger)
		let controller = SpeechController(api: flutterApi)
		SpeechHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: controller)
	}
}

extension FlutterError: Swift.Error {}
