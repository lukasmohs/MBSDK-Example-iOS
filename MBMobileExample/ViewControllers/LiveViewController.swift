//
//  LiveViewController.swift
//  MBMobileExample
//
//  Created by Lukas Mohs on 10.09.19.
//  Copyright © 2019 Daimler AG. All rights reserved.
//

import Foundation
import UIKit
import MBMobileSDK
import MBCarKit
import ABGaugeViewKit

class LiveViewController: UIViewController {

    private var disposal = Disposal()
    private var token: MyCarSocketNotificationToken?
    
    @IBOutlet weak var speedometerView: ABGaugeView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.Name.didChangeVehicleSelection.add(self, selector: #selector(self.didChangeVehicleSelection(notification:)))
        self.observeVehicleStatus()
        self.didChangeVehicleSelection(notification: nil)
    }

    deinit {
        LOG.V()

        /// remove observer
        Notification.Name.didChangeVehicleSelection.remove(self)

        /// stop observer
        self.disposal.removeAll()
        MBCarKit.socketService.unregisterAndDisconnectIfPossible(token: self.token)
    }

    /// Starts oberserving some data from the socket
    private func handle(socketObservable: SocketObservableProtocol) {
        socketObservable.ecoScore.observe { [weak self] (state) in
            switch state {
            case .updated(let ecoScore):
                guard let ecoScoreTotalValue = ecoScore.total.value else {
                    return
                }
                print("Eco score total: \(ecoScoreTotalValue)")
                self?.speedometerView.needleValue = CGFloat(ecoScoreTotalValue)
                let location = socketObservable.location.current
                DataHandler.shared.addNewDataPoint(location: location, ecoScore: ecoScore)
            case .initial(let ecoScore):
                guard let ecoScoreTotalValue = ecoScore.total.value else {
                    return
                }
                print("Eco score total initial: \(ecoScoreTotalValue)")
                self?.speedometerView.needleValue = CGFloat(ecoScoreTotalValue)
                let location = socketObservable.location.current
                DataHandler.shared.addNewDataPoint(location: location, ecoScore: ecoScore)
            }
        }.add(to: &self.disposal)

        socketObservable.location.observe { [weak self] (state) in
            switch state {
            case .updated(let location):
                let ecoScore = socketObservable.ecoScore.current
                DataHandler.shared.addNewDataPoint(location: location, ecoScore: ecoScore)
                print("----- Location ------")
                print(location.latitude)
            case .initial(let location):
                let ecoScore = socketObservable.ecoScore.current
                DataHandler.shared.addNewDataPoint(location: location, ecoScore: ecoScore)
            }
        }.add(to: &self.disposal)

        socketObservable.engine.observe { [weak self] (state) in
            switch state {
            case .updated(let engine):
                guard let engineState = engine.state.value else {
                    print("[Error]: Engine state value is nil")
                    return
                }
                if engineState == .stopped {
                    guard let currentTrip = DataHandler.shared.getCurrentTrip() else {
                        return
                    }
                    for dataPoint in currentTrip.tripData {
                        print("[\(dataPoint.timeStamp)]" + "  \(dataPoint.location.latitude.value)/\(dataPoint.location.longitude.value)")
                    }
                    DataHandler.shared.finishCurrentTrip()
                    print("Number of trips: \(DataHandler.shared.getAllTrips()[0])")
                } else {
                    DataHandler.shared.startNewTrip(name: "Test Trip")
                }
            case .initial(let engine):
                print("Engine initial state")
            }
        }.add(to: &self.disposal)
    }

    /// Example implementation how to create the connection and observes the status of the vehicle
    private func observeVehicleStatus() {

        // Connect the MyCar SocketService to the socket
        let socketStateTupel = MBCarKit.socketService.connect(notificationTokenCreated: { [weak self] notificationToken in

            // Token that will be used to remove the socket connection
            self?.token = notificationToken
            }, socketConnectionState: { (_) in

                // Handle the connection state of the socket
        })

        // Handle the possible obervable socket data
        self.handle(socketObservable: socketStateTupel.socketObservable)
    }

    @objc private func didChangeVehicleSelection(notification: Notification?) {

        guard let vehicleStatusModel = notification?.object as? VehicleStatusModel else {
            return
        }
    }
}
