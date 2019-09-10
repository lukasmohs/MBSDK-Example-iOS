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
        tripsTableView.tableFooterView = UIView()
        tripsTableView.dataSource = self
        tripsTableView.delegate =  self
        
    }
    
}
