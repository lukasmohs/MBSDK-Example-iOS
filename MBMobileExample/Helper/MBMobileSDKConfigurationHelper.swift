//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import MBMobileSDK

class MBMobileSDKConfigurationHelper {
	
	class func getConfig() -> MBMobileSDKConfiguration {
		
		// Setup SDK
		#if RELEASE
		var configuration = MBMobileSDKConfiguration(applicationIdentifier: Constants.applicationIdentifier,
													 appGroupIdentifier: .custom(""),
													 clientId: "",
													 isStageSelectorEnabled: false,
													 ldssoAppId: "",
													 ldssoAppVersion: "",
													 stageEndpoint: .mock,
													 stageRegion: .ece)
        configuration.mbMobileSDKPushHub = .store
		#elseif DEBUG
		var configuration = MBMobileSDKConfiguration(applicationIdentifier: Constants.applicationIdentifier,
													 appGroupIdentifier: .custom(""),
													 clientId: "",
													 isStageSelectorEnabled: false,
													 ldssoAppId: "",
													 ldssoAppVersion: "",
													 stageEndpoint: .mock,
													 stageRegion: .ece)
        configuration.mbMobileSDKPushHub = .development
		#endif

        // Set the generated acknowledgement plist dictionary
        configuration.acknowledgement = PlistFiles.preferenceSpecifiers

		return configuration
	}
}
