//
//  TripsTableViewCell.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//


import UIKit

class TripsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var viewForegroundLayer: UIView!
    @IBOutlet weak var carLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        // Round corners and set border
        viewForegroundLayer.layer.cornerRadius = 8
        viewForegroundLayer.layer.masksToBounds = true
        viewForegroundLayer.layer.borderWidth = 1.0
        viewForegroundLayer.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func setTestDetails(car: String, origin: String, destination: String, date: Date) {
        originLabel?.text = origin
        destinationLabel?.text = destination
        carLabel?.text = car
        
        dateLabel.text = getHoursAndMinutesFromDate(date: date)
        monthLabel.text = getFormattedDate(date: date)
        
    }
    func getFormattedDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let someDateTime = formatter.string(from: date)
        return someDateTime
    }
    
    
    func getHoursAndMinutesFromDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let someDateTime = formatter.string(from: date)
        return someDateTime
    }
    
}

