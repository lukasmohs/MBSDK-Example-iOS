//
//  TripDetailViewController.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart


class TripDetailViewController: UIViewController {
    
    var trip: Trip?

    @IBOutlet weak var chartView: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title = "Trip Details"
        
        setUpChart()
    }
    
    func setUpChart() {

        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        chartView.add(series)
    }
}
