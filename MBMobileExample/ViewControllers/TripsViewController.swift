//
//  TripsViewController.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit

class TripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    struct Trip {
        let tripData: [TripData]
        let name: String
    }
    
    struct TripData {
        let locaton = 5
        let timeStamp: Date
    }
    
    var trips: [Trip] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        trips.append(Trip(tripData: [TripData(timeStamp: Date())], name: "Sunday Morning"))
    }
}
