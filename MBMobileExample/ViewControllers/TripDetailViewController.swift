//
//  TripDetailViewController.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit


class TripDetailViewController: UIViewController {
    
    var trip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Trip Details"
    }
}
