//
//  DataHandler.swift
//  MBMobileExample
//
//  Created by Alexandros Tsakpinis on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import MBMobileSDK
import MBCarKit

struct DataPoint {
    let timeStamp: Date
    let location: VehicleLocationModel
    let ecoScore: VehicleEcoScoreModel
}

struct Trip {
    let name: String
    var tripData: [DataPoint]
}

class DataHandler {
    var trips: [Trip] =  []
    var currentTrip: Trip?
    
    static let shared = DataHandler()
    
    func startNewTrip( name: String ) {
        self.currentTrip = Trip( name: name, tripData: [] )
    }
    
    func finishCurrentTrip() {
        guard let currentTrip = self.currentTrip else {
            return
        }
        trips.append(currentTrip)
    }
    
    func addNewDataPoint( location: VehicleLocationModel, ecoScore: VehicleEcoScoreModel ) {
        if self.currentTrip == nil {
            print("[Error] Current trip is nil")
            return
        }
        self.currentTrip!.tripData.append(DataPoint(timeStamp: Date(), location: location, ecoScore: ecoScore))
    }
    
    func getAllTrips() -> [Trip] {
        return trips
    }
    
    func getCurrentTrip() -> Trip? {
        return currentTrip
    }
}
