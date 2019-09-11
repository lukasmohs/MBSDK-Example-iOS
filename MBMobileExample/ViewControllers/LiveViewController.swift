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
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var recommendationsStackView: UIStackView!
    @IBOutlet weak var speedometerView: ABGaugeView!

    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!

    var previousEcoScore: VehicleEcoScoreModel?
    var recommendationViews: [UIView] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Notification.Name.didChangeVehicleSelection.add(self, selector: #selector(self.didChangeVehicleSelection(notification:)))
        self.observeVehicleStatus()
        self.didChangeVehicleSelection(notification: nil)
        self.addRecommendationsToView()
    }

    func addRecommendationsToView() {
        recommendationsStackView.axis = .vertical
        recommendationsStackView.alignment = .center
        recommendationsStackView.distribution = .equalSpacing
        recommendationsStackView.spacing = 2

        stackViewHeightConstraint.constant += CGFloat(3 * 20)

        let recommendationView1 = RecommendationView.instanceFromNib() as! RecommendationView
        recommendationView1.recommendationText.text = "Break earlier!"
        recommendationView1.recommendationBackgroundView.layer.cornerRadius = 5;
        recommendationView1.recommendationBackgroundView.layer.masksToBounds = true;
        recommendationsStackView.addArrangedSubview(recommendationView1)

        let recommendationView2 = RecommendationView.instanceFromNib() as! RecommendationView
        recommendationView2.recommendationText.text = "Accelerate!"
        recommendationView2.recommendationBackgroundView.layer.cornerRadius = 5;
        recommendationView2.recommendationBackgroundView.layer.masksToBounds = true;
        recommendationsStackView.addArrangedSubview(recommendationView2)

        let recommendationView3 = RecommendationView.instanceFromNib() as! RecommendationView
        recommendationView3.recommendationText.text = "Drive slower!"
        recommendationView3.recommendationBackgroundView.layer.cornerRadius = 5;
        recommendationView3.recommendationBackgroundView.layer.masksToBounds = true;
        recommendationsStackView.addArrangedSubview(recommendationView3)

        recommendationViews.append(recommendationView1)
        recommendationViews.append(recommendationView2)
        recommendationViews.append(recommendationView3)
        //recommendationView1.isHidden = true

        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        recommendationsStackView.addArrangedSubview(spacerView)
    }

    func createRecommendationView(text: String) {
        if recommendationViews.count >= 4 {
            guard let lastRecommendationView = recommendationViews.last else {
                return
            }
            DispatchQueue.main.async {
                self.recommendationsStackView.subviews.last?.removeFromSuperview()
//                self.recommendationsStackView.removeArrangedSubview(lastRecommendationView)
//                lastRecommendationView.removeFromSuperview()
            }
            self.recommendationViews = recommendationViews.dropLast()
        }
        let recommendationView = RecommendationView.instanceFromNib() as! RecommendationView
        recommendationView.recommendationText.text = text
        recommendationView.recommendationBackgroundView.layer.cornerRadius = 5;
        recommendationView.recommendationBackgroundView.layer.masksToBounds = true;
        recommendationsStackView.addArrangedSubview(recommendationView)
        self.recommendationViews.append(recommendationView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
                guard let ecoScoreAccel = ecoScore.accel.value else {
                    return
                }
                if ecoScoreAccel < 20 {
                    self?.createRecommendationView(text: "Drive slower!")
                }
                guard let ecoScoreConst = ecoScore.const.value else {
                    return
                }
                if ecoScoreConst < 20 {
                    self?.createRecommendationView(text: "More predicitive driving!")
                }
                guard let ecoScoreFreeWhl = ecoScore.freeWhl.value else {
                    return
                }
            case .initial(let ecoScore):
                guard let ecoScoreTotalValue = ecoScore.total.value else {
                    return
                }
                print("Eco score total initial: \(ecoScoreTotalValue)")
                self?.speedometerView.needleValue = CGFloat(ecoScoreTotalValue)
                let location = socketObservable.location.current
                DataHandler.shared.addNewDataPoint(location: location, ecoScore: ecoScore)
                self?.previousEcoScore = ecoScore
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
                    print("Engine stopped")
                    let currentStatistics = socketObservable.statistics.current
                    DataHandler.shared.finishCurrentTrip(statistics: currentStatistics)
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

