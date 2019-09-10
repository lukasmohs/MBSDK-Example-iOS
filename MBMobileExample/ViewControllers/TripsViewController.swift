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
    
    @IBOutlet var tripsTableView: UITableView!
    
    var segueIndex = -1
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.shared.getAllTrips().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell", for: indexPath) as! TripsTableViewCell
        
        let trip = DataHandler.shared.getAllTrips()[indexPath.row]
        let origin: String = String(trip.tripData[0].location.latitude) + ", " + String(trip.tripData[0].location.longitude)
        let destination: String = String(trip.tripData[trip.tripData.count-1].location.latitude) + ", " + String(trip.tripData[trip.tripData.count-1].location.longitude)
        cell.setTestDetails(car: "benz", origin: origin, destination: destination, date: trip.timeStamp)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Trips"
        tripsTableView.tableFooterView = UIView()
        tripsTableView.dataSource = self
        tripsTableView.delegate =  self
    }
    
    func tableView(_ tableView: UITableView,  didSelectRowAt indexPath: IndexPath) {
         self.performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let nextViewController = segue.destination as? TripDetailViewController {
                nextViewController.trip = nil
            }
        }
    }
}
