//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBMobileSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Properties
	
	var window: UIWindow?
	var loggerConfiguration = MBLoggerConfiguration()
	

	// MARK: - Methods
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		self.window = UIWindow(frame: UIScreen.main.bounds)
		
		// setup SDK
		let configuration = MBMobileSDKConfigurationHelper.getConfig()
		MBMobileSDK.setup(configuration: configuration, menuDataSource: MenuDataSource())
		
		return true
	}
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		
		// pass the deviceToken to the SDK
		MBMobileSDK.setPushDeviceToken(token: deviceToken)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		LOG.E(error)
	}
}
