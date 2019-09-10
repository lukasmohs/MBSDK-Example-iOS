//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBMobileSDK
import MBCarKit
import EFCountingLabel

class HomeViewController: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var contentStackView: UIStackView!
	@IBOutlet private weak var carImageView: CarImageView!
	@IBOutlet private weak var carStatusView: CarStatusView!
	@IBOutlet private weak var commandDoorView: CommandDoorView!

    @IBOutlet weak var stackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var badgeStackView: UIStackView!
    @IBOutlet weak var co2SavingsLabel: EFCountingLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    // MARK: - Properties
    @IBOutlet weak var savingsView: UIView!
    
	private var disposal = Disposal()
	private var token: MyCarSocketNotificationToken?

	
	// MARK: - View Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// add observer
        Notification.Name.didChangeVehicleSelection.add(self, selector: #selector(self.didChangeVehicleSelection(notification:)))
        
        //self.setupScrollView()
        
        self.observeVehicleStatus()
        self.didChangeVehicleSelection(notification: nil)
        
        self.configureCommandDoors()
        
        startCountingCO2()
        setupProfileView()
        addBadgesToView()
        setupSavingsView()
    }
	
    func setupProfileView() {
        let image = UIImage(named: "zetsche")
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.image = image
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func setupSavingsView() {
        savingsView.layer.borderWidth = 1.0
        savingsView.layer.masksToBounds = false
        savingsView.layer.borderColor = UIColor.white.cgColor
        savingsView.layer.cornerRadius = 20
        savingsView.clipsToBounds = true
    }
    
    func startCountingCO2() {
        co2SavingsLabel.setUpdateBlock { value, label in
            label.text = String(format: "%.1f%", value)
        }
        let savings = 1000 + Int.random(in: 0 ... 1000)
        co2SavingsLabel.countFrom(1, to: CGFloat(savings), withDuration: 2.0)
    }
    
    func addBadgesToView() {
        
        badgeStackView.axis = .horizontal
        badgeStackView.alignment = .leading
        badgeStackView.distribution = .equalSpacing
        badgeStackView.spacing = 2
        
        stackViewWidthConstraint.constant += CGFloat(5 * 70)
        
//        1
        let image1 = UIImage(named: "round_loop")
        let view1 = BadgeCard.instanceFromNib() as! BadgeCard
        view1.badgeImageView.image = image1
        view1.badgeName.text = "Wheelsfree"
        badgeStackView.addArrangedSubview(view1)
//        2
        let image2 = UIImage(named: "round_call_made")
        let view2 = BadgeCard.instanceFromNib() as! BadgeCard
        view2.badgeImageView.image = image2
        view2.badgeName.text = "Bonus Range"
        badgeStackView.addArrangedSubview(view2)
//        3
        let image3 = UIImage(named: "round_eco")
        let view3 = BadgeCard.instanceFromNib() as! BadgeCard
        view3.badgeImageView.image = image3
        view3.badgeName.text = "Eco Year"
        badgeStackView.addArrangedSubview(view3)
//        4
        let image4 = UIImage(named: "round_monetization")
        let view4 = BadgeCard.instanceFromNib() as! BadgeCard
        view4.badgeImageView.image = image4
        view4.badgeName.text = "Saver"
        badgeStackView.addArrangedSubview(view4)
//        5
        let image5 = UIImage(named: "round_outlined_flag")
        let view5 = BadgeCard.instanceFromNib() as! BadgeCard
        view5.badgeImageView.image = image5
        view5.badgeName.text = "Competitor"
        badgeStackView.addArrangedSubview(view5)
        
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        badgeStackView.addArrangedSubview(spacerView)
        
    }
    
    @IBAction func gotoLiveViewButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showLiveView", sender: self)
    }
    
    @IBAction func myTripsButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showTrips", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
//        if self.scrollView.contentSize.equalTo(self.contentStackView.bounds.size) == false {
//
//            self.scrollView.contentSize = self.contentStackView.bounds.size
//            self.scrollView.layoutIfNeeded()
//        }
	}
    
    deinit {
        LOG.V()
        
        /// remove observer
        Notification.Name.didChangeVehicleSelection.remove(self)
        
        /// stop observer
        self.disposal.removeAll()
        MBCarKit.socketService.unregisterAndDisconnectIfPossible(token: self.token)
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

        /*socketObservable.statistics.observe { [weak self] (state) in
            switch state {
            case .initial(let statistics):

            }
        }*/
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
