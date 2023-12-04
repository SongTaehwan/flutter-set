import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		let controller = window?.rootViewController as! FlutterViewController

		configureSTTMethodChannel(binaryMessenger: controller.binaryMessenger)
		configureTTSMethodChannel(binaryMessenger: controller.binaryMessenger)

		GeneratedPluginRegistrant.register(with: self)
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
}

// From Flutter to Swift
extension AppDelegate {
	private func configureSTTMethodChannel(binaryMessenger: FlutterBinaryMessenger) {
		let flutterApi = SpeechFlutterApi(binaryMessenger: binaryMessenger)
		let controller = SpeechController(api: flutterApi)
		SpeechHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: controller)
	}

	private func configureTTSMethodChannel(binaryMessenger: FlutterBinaryMessenger) {
		let controller = TextToSpeechController()
		TextToSpeechHostApiSetup.setUp(binaryMessenger: binaryMessenger, api: controller)
	}
}

extension FlutterError: Swift.Error {}
