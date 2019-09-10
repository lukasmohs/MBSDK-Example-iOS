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
    let location: Location
    let ecoScore: EcoScore
}

struct Trip {
    let name: String
    var tripData: [DataPoint]
    //Statistics
    var avgSpeedStart: Double
    var distanceStart: Double
    var distanceZeStart: Int
    var drivenTimeStart: Int
    var drivenTimeZeStart: Int
    var gasConsumptionStart: Double
    var electricConsumptionStart: Double
    var liquidConsumptionStart: Double
}

struct Location {
    let longitude: Double
    let latitude: Double
}

struct EcoScore {
    let accel: Int
    let bonusRange: Double
    let const: Int
    let freeWhl: Int
    let total: Int
}

class DataHandler {
    var trips: [Trip] =  []
    var currentTrip: Trip?
    
    static let shared = DataHandler()
    
    func startNewTrip( name: String ) {
        // swiftlint:disable:next line_length
        self.currentTrip = Trip(name: name, tripData: [], avgSpeedStart: 0, distanceStart: 0, distanceZeStart: 0, drivenTimeStart: 0, drivenTimeZeStart: 0, gasConsumptionStart: 0, electricConsumptionStart: 0, liquidConsumptionStart: 0)
    }
    
    func finishCurrentTrip( statistics: VehicleStatisticsModel ) {
        guard var currentTrip = self.currentTrip, let currentAvgSpeedStart = statistics.averageSpeed.start.value,
            let distanceStart = statistics.distance.start.value, let distanceZeStart = statistics.distance.ze.start.value,
            let drivenTimeStart = statistics.drivenTime.start.value,
            let drivenTimeZeStart = statistics.drivenTime.ze.start.value,
            let gasConsumptionStart = statistics.gas.consumption.start.value,
            let electricConsumptionStart = statistics.electric.consumption.start.value,
            let liquidConsumptionStart = statistics.liquid.consumption.start.value  else {
            return
        }
        currentTrip.avgSpeedStart = currentAvgSpeedStart
        currentTrip.distanceStart = distanceStart
        currentTrip.distanceZeStart = distanceZeStart
        currentTrip.drivenTimeStart = drivenTimeStart
        currentTrip.drivenTimeZeStart = drivenTimeZeStart
        currentTrip.gasConsumptionStart = gasConsumptionStart
        currentTrip.electricConsumptionStart = electricConsumptionStart
        currentTrip.liquidConsumptionStart = liquidConsumptionStart
        trips.append(currentTrip)
        self.currentTrip = nil
    }
    
    func addNewDataPoint( location: VehicleLocationModel, ecoScore: VehicleEcoScoreModel ) {
        guard self.currentTrip != nil, let longitudeValue = location.longitude.value, let latitudeValue = location.latitude.value,let accelValue = ecoScore.accel.value, let bonusRangeValue = ecoScore.bonusRange.value,
            let constValue = ecoScore.const.value, let freeWhlValue = ecoScore.freeWhl.value,
            let totalValue = ecoScore.total.value else {
            print("[Error] Current trip is nil")
            return
        }
        let currentLocation = Location(longitude: longitudeValue, latitude: latitudeValue)
        let currentEcoscore = EcoScore(accel: accelValue, bonusRange: bonusRangeValue, const: constValue, freeWhl: freeWhlValue, total: totalValue)
        self.currentTrip!.tripData.append(DataPoint(timeStamp: Date(), location: currentLocation, ecoScore: currentEcoscore))
    }
    
    func getAllTrips() -> [Trip] {
        return trips
    }
    
    func getCurrentTrip() -> Trip? {
        return currentTrip
    }
}
