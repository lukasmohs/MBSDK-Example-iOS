//
//  TripsTableViewCell.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//


import UIKit

class TripsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ecoScoreLabel: UILabel!
    
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
    
    func setTestDetails(trip: Trip) {
        
        let origin: String = String(trip.tripData[0].location.latitude) + ", " + String(trip.tripData[0].location.longitude)
        let destination: String = String(trip.tripData[trip.tripData.count-1].location.latitude) + ", " + String(trip.tripData[trip.tripData.count-1].location.longitude)
        
        originLabel?.text = origin
        destinationLabel?.text = destination
        carLabel?.text = "Benz AMG - 63 coupé"
        
        dateLabel.text = trip.getHoursAndMinutesFromDate()
        monthLabel.text = trip.getFormattedDate()
        var averageEcoScore = 0
        for tripDataPoint in  trip.tripData {
            averageEcoScore += tripDataPoint.ecoScore.total
        }
        let averageEcoScoreFinal = round(Double(averageEcoScore) / Double(trip.tripData.count))
        ecoScoreLabel.text = String(averageEcoScoreFinal)
    }
    
}

