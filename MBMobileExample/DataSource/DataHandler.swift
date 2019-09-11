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
import CoreLocation


struct DataPoint {
    let timeStamp: Date
    let location: Location
    let ecoScore: EcoScore
}

struct Trip {
    let timeStamp: Date
    let name: String
    var tripData: [DataPoint]
    var origin: String
    var destination: String
    //Statistics
    var avgSpeedStart: Double
    var distanceStart: Double
    var distanceZeStart: Int
    var drivenTimeStart: Int
    var drivenTimeZeStart: Int
    var gasConsumptionStart: Double
    var electricConsumptionStart: Double
    var liquidConsumptionStart: Double
    
    func getFormattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let someDateTime = formatter.string(from: timeStamp)
        return someDateTime
    }
    
    func getHoursAndMinutesFromDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let someDateTime = formatter.string(from: timeStamp)
        return someDateTime
    }
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

struct ReturnLocations {
    let origin: String
    let destination: String
}

class DataHandler {
    var trips: [Trip] =  []
    var currentTrip: Trip?
    
    static let shared = DataHandler()
    
    func startNewTrip( name: String ) {
        // swiftlint:disable:next line_length
        self.currentTrip = Trip(timeStamp: Date(), name: name, tripData: [],origin: "", destination: "", avgSpeedStart: 0, distanceStart: 0, distanceZeStart: 0, drivenTimeStart: 0, drivenTimeZeStart: 0, gasConsumptionStart: 0, electricConsumptionStart: 0, liquidConsumptionStart: 0)
    }
    
    func finishCurrentTrip( statistics: VehicleStatisticsModel ) {
        guard var currentTrip = self.currentTrip else {
                print("[Error] Current trip is nil")
                return
        }
        currentTrip.origin = "Frankfurt Flughafen"
        currentTrip.destination = "Frankfurt Neu-Isenburg"
        
//        if(trips.count == 0){
//            
//        } else if(trips.count == 1 ){
//            currentTrip.origin = "Berlin City"
//            currentTrip.destination = "Kreuzberg"
//        } else if ( trips.count == 2){
//            currentTrip.origin = "München"
//            currentTrip.destination = "Starnberg"
//        } else {
//            currentTrip.origin = "Regensburg"
//            currentTrip.destination = "Neutraubling"
//        }
        //let origin = currentTrip.tripData[0].location
        //let destination = currentTrip.tripData[currentTrip.tripData.count-1].location
        //tranlateCoordinates(origin: origin, destination: destination)
        guard let currentAvgSpeedStart = statistics.averageSpeed.start.value,
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
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: completion)
    }
    
    func tranlateCoordinates(origin: Location, destination: Location) {
        var returnStringOrigin = ""
        geocode(latitude: origin.latitude, longitude: origin.longitude){ placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                DispatchQueue.main.async {
                    let adress = placemark.thoroughfare ?? "unknownAdress"
                    let number = placemark.subThoroughfare ?? "unknownNumber"
                    let city = placemark.locality ?? "unknownCity"
                    returnStringOrigin =  adress + " " + number + ", " + city
                    self.currentTrip?.origin = returnStringOrigin
                    print("ReturnstringOrigin: " + returnStringOrigin)
                }
            }
        }
        var returnStringDestination = ""
        geocode(latitude: destination.latitude, longitude: destination.longitude){ placemark, error in
            if let error = error as? CLError {
                print("CLError:", error)
                return
            } else if let placemark = placemark?.first {
                DispatchQueue.main.async {
                    let adress = placemark.thoroughfare ?? "unknownAdress"
                    let number = placemark.subThoroughfare ?? "unknownNumber"
                    let city = placemark.locality ?? "unknownCity"
                    returnStringDestination =  adress + " " + number + ", " + city
                    self.currentTrip?.destination = returnStringDestination
                    print("ReturnstringDestination: " + returnStringDestination)
                }
            }
        }
    }
}
