//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import MBMobileSDK
import MBCommonKit

let LOG = MBLogger.shared

class MBLoggerConfiguration {
    
    init() {
        
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else {
            return
        }
        
        #if DEBUG
        
        LOG.register(logger: ConsoleLogger())
        
        #elseif RELEASE
        
        LOG.register(logger: FileLogger())
        LOG.logLevel = .warning
        
        #endif
    }
}
