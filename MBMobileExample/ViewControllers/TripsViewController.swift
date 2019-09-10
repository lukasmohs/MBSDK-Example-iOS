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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TripsTableViewCell", for: indexPath) as! TripsTableViewCell
        cell.setTestDetails(car: "benz", origin: "Stuttgart", destination: "Karlsruhe", date: Date())
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
