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
    let tripData: [DataPoint]
}


