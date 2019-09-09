//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBMobileSDK
import MBCarKit

class HomeViewController: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var contentStackView: UIStackView!
	@IBOutlet private weak var carImageView: CarImageView!
	@IBOutlet private weak var carStatusView: CarStatusView!
	@IBOutlet private weak var commandDoorView: CommandDoorView!

	// MARK: - Properties
	
	private var disposal = Disposal()
	private var token: MyCarSocketNotificationToken?

	
	// MARK: - View Lifecycle
	
	deinit {
		LOG.V()
		
		/// remove observer
		Notification.Name.didChangeVehicleSelection.remove(self)
		
		/// stop observer
		self.disposal.removeAll()
		MBCarKit.socketService.unregisterAndDisconnectIfPossible(token: self.token)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		/// add observer
		Notification.Name.didChangeVehicleSelection.add(self, selector: #selector(self.didChangeVehicleSelection(notification:)))
		
		self.setupScrollView()
		
		self.observeVehicleStatus()
		self.didChangeVehicleSelection(notification: nil)
		
		self.configureCommandDoors()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if self.scrollView.contentSize.equalTo(self.contentStackView.bounds.size) == false {
			
			self.scrollView.contentSize = self.contentStackView.bounds.size
			self.scrollView.layoutIfNeeded()
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		self.scrollView.contentSize = self.contentStackView.bounds.size
	}
	
	
	// MARK: - Observer
	
	@objc private func didChangeVehicleSelection(notification: Notification?) {
		
		guard let vehicleStatusModel = notification?.object as? VehicleStatusModel else {
			return
		}
			
		self.carImageView.updateView(vehicleStatusModel: vehicleStatusModel)
		self.carStatusView.updateView(vehicleStatusModel: vehicleStatusModel)
	}
	
	
	// MARK: - Helper
	
	private func configureCommandDoors() {
		
		self.commandDoorView.backgroundColor = .clear
		self.commandDoorView.configure(title: L10n.commandDoorsTitle, startTitle: L10n.commandLock, stopTitle: L10n.commandUnlock, start: { [weak self] (button) in
			
			self?.commandDoorView.reset()
			
			button.activate(state: .loading)
			
			// Send the command request to lock the doors
			MBCarKit.socketService.send(command: Command.DoorsLock(), completion: { (commandProcessingState, meta) in
				
				// Updates the UI for the state of the command request
				self?.commandDoorView.handle(commandProcessingState: commandProcessingState, meta: meta, button: button)
			})
			
		}, stop: { [weak self] (button) in
				
			self?.commandDoorView.reset()
			
			button.activate(state: .loading)
			
			// Send the command request to lock the doors
			MBCarKit.socketService.send(command: Command.DoorsUnlock(), completion: { (commandProcessingState, meta) in
				
				// Updates the UI for the state of the command request
				self?.commandDoorView.handle(commandProcessingState: commandProcessingState, meta: meta, button: button)
			})
		})
	}
	
    /// Starts oberserving some data from the socket
	private func handle(socketObservable: SocketObservableProtocol) {
		
        // Starts observering the door data
		socketObservable.doors.observe { [weak self] (state) in
			
			switch state {
			case .initial(let doors):
                // Updates the UI with the initial data
				self?.carImageView.update(doors: doors)
				self?.carStatusView.update(doors: doors)
				
			case .updated(let doors):
                // Updates the UI for updated data
				self?.carImageView.update(doors: doors)
				self?.carStatusView.update(doors: doors)
			}
		}.add(to: &self.disposal) // Adds the observable value to the disposal object to remove it later
		
        // Starts observering the tank data
		socketObservable.tank.observe { [weak self] (state) in
			
			switch state {
			case .initial(let tank):
				self?.carStatusView.update(tank: tank)
				
			case .updated(let tank):
				self?.carStatusView.update(tank: tank)
			}
		}.add(to: &self.disposal)
		
        // Starts observering the verhicle data
		socketObservable.vehicle.observe { [weak self] (state) in
			
			switch state {
			case .initial(let vehicle):
				self?.carImageView.update(vehicle: vehicle)
				
			case .updated(let vehicle):
				self?.carImageView.update(vehicle: vehicle)
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
		
		self.carImageView.update(doors: socketStateTupel.socketObservable.doors.current)
		self.carImageView.update(vehicle: socketStateTupel.socketObservable.vehicle.current)
		
		self.carStatusView.update(doors: socketStateTupel.socketObservable.doors.current)
		self.carStatusView.update(tank: socketStateTupel.socketObservable.tank.current)
		
        // Handle the possible obervable socket data
		self.handle(socketObservable: socketStateTupel.socketObservable)
	}
	
	private func setupScrollView() {
		self.scrollView.contentInset = UIEdgeInsets(top: Constants.inset,
													left: 0,
													bottom: Constants.inset,
													right: 0)
	}
}
