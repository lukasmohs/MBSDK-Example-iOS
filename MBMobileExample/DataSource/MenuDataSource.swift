//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBMobileSDK
import MBUIKit

class MenuDataSource: LoginMenuDataSource {

    // MARK: Properties
    override var customMenuItems: [MBMenuItem] {
        // Add your custom menu items here to define which one will shown
        // return [<#CustomMenuItemType Element#>].map({ $0.menuItem })
        return []
    }
    
    // MARK: Override method
    
    override func getViewController(for menuItem: MBMenuItem) -> UIViewController {
        
        // Add your HomeViewController to the case `.home` so that it appears
        // Do the same if you have custom menu items with the case `.custom`
        switch menuItem.type {
        case .home:	return StoryboardScene.Main.homeViewController.instantiate()
        default:	return super.getViewController(for: menuItem)
        }
    }
}

enum CustomMenuItemType: MBCustomMenuItemConformable {
	
    //Define your custom menu items here

	var featureToggle: FeatureToggleConformable.Type? {
		switch self {
		default:	return nil
		}
	}
	
	var image: UIImage? {
		switch self {
		default:	return nil
		}
	}
	
    var title: String {
        switch self {
        default:	return ""
        }
    }
    
    var accessibilityIdentifier: String {
        switch self {
        default:	return ""
        }
    }
}
