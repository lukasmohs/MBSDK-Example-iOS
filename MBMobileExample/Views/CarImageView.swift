//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBCarKit
import MBUIKit

class CarImageView: MBBaseView {
	
	// MARK: - Struct
	
	private struct Constants {
		static let defaultColor = UIColor.clear
	}
	
	// MARK: - IBOutlet
	
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var carImageView: UIImageView!
	@IBOutlet private weak var carOutlineImageView: UIImageView!
	@IBOutlet private weak var doorFrontLeftImageView: UIImageView!
	@IBOutlet private weak var doorFrontRightImageView: UIImageView!
	@IBOutlet private weak var doorRearLeftImageView: UIImageView!
	@IBOutlet private weak var doorRearRightImageView: UIImageView!
	@IBOutlet private weak var ignitionStateImageView: UIImageView!
	@IBOutlet private weak var vehicleLockStateImageView: UIImageView!
	
	
	// MARK: - Public
	
    /// Updates the images of the doors based on the status of the door
	public func update(doors: VehicleDoorsModel) {
		
		self.doorFrontLeftImageView.image   = doors.frontLeft.frontLeftImage
		self.doorFrontRightImageView.image  = doors.frontRight.frontRightImage
		self.doorRearLeftImageView.image    = doors.rearLeft.rearLeftImage
		self.doorRearRightImageView.image   = doors.rearRight.rearRightImage
	}
	
    /// Updates the color of the doors based on the status of the door
	public func update(vehicle: VehicleVehicleModel) {
		
		self.carOutlineImageView.tintColor        = vehicle.vehicleLockState.value?.statusColor ?? Constants.defaultColor
		self.vehicleLockStateImageView.tintColor  = vehicle.vehicleLockState.value?.statusColor ?? Constants.defaultColor
	}
	
	public func updateView(vehicleStatusModel: VehicleStatusModel) {
		
		self.update(doors: vehicleStatusModel.doors)
		self.update(vehicle: vehicleStatusModel.vehicle)
	}
	
	
	// MARK: - View life cycle
	
	override func setupUI() {
		super.setupUI()
		
		self.backgroundColor                 = .clear
		self.containerView.backgroundColor   = .clear
		
		self.carImageView.image              = Asset.carWithoutDoors.image
		self.carOutlineImageView.image       = Asset.carOutline.image.withRenderingMode(.alwaysTemplate)
		self.doorFrontLeftImageView.image    = Asset.dflc.image
		self.doorFrontRightImageView.image   = Asset.dfrc.image
		self.doorRearLeftImageView.image     = Asset.dblc.image
		self.doorRearRightImageView.image    = Asset.dbrc.image
		self.vehicleLockStateImageView.image = Asset.carLock.image.withRenderingMode(.alwaysTemplate)
	}
}


// MARK: - DoorStatus

// Images for every status of each door
extension DoorStatus {
	
	fileprivate var frontLeftImage: UIImage {
		
		switch self {
		case .closed:	return Asset.dflcg.image
		case .open:		return Asset.dflcr.image
		}
	}
	
	fileprivate var frontRightImage: UIImage {
		
		switch self {
		case .closed:	return Asset.dfrcg.image
		case .open:		return Asset.dfrcr.image
		}
	}
	
	fileprivate var rearLeftImage: UIImage {
		
		switch self {
		case .closed:	return Asset.dblcg.image
		case .open:		return Asset.dblcr.image
		}
	}
	
	fileprivate var rearRightImage: UIImage {
		
		switch self {
		case .closed:	return Asset.dbrcg.image
		case .open:		return Asset.dbrcr.image
		}
	}
}

// MARK: - VehicleDoorModel

// Images for every status of each verhicle door
extension VehicleDoorModel {
	
	fileprivate var frontLeftImage: UIImage {
		
		guard let state = self.state.value,
			let lockState = self.lockState.value else {
				return Asset.dflc.image
		}
		
		switch state {
		case .closed:
			switch lockState {
			case .locked:	return Asset.dflcg.image
			case .unlocked:	return Asset.dflcr.image
			}
			
		case .open:
			switch lockState {
			case .locked:	return Asset.dflog.image
			case .unlocked:	return Asset.dflor.image
			}
		}
	}
	
	fileprivate var frontRightImage: UIImage {
		
		guard let state = self.state.value,
			let lockState = self.lockState.value else {
				return Asset.dfrc.image
		}
		
		switch state {
		case .closed:
			switch lockState {
			case .locked:	return Asset.dfrcg.image
			case .unlocked:	return Asset.dfrcr.image
			}
			
		case .open:
			switch lockState {
			case .locked:	return Asset.dfrog.image
			case .unlocked:	return Asset.dfror.image
			}
		}
	}
	
	fileprivate var rearLeftImage: UIImage {
		
		guard let state = self.state.value,
			let lockState = self.lockState.value else {
				return Asset.dblc.image
		}
		
		switch state {
		case .closed:
			switch lockState {
			case .locked:	return Asset.dblcg.image
			case .unlocked:	return Asset.dblcr.image
			}
			
		case .open:
			switch lockState {
			case .locked:	return Asset.dblog.image
			case .unlocked:	return Asset.dblor.image
			}
		}
	}
	
	fileprivate var rearRightImage: UIImage {
		
		guard let state = self.state.value,
			let lockState = self.lockState.value else {
				return Asset.dbrc.image
		}
		
		switch state {
		case .closed:
			switch lockState {
			case .locked:	return Asset.dbrcg.image
			case .unlocked:	return Asset.dbrcr.image
			}
			
		case .open:
			switch lockState {
			case .locked:	return Asset.dbrog.image
			case .unlocked:	return Asset.dbror.image
			}
		}
	}
}


// MARK: - VehicleDoorLockStatus

// Colors for every door lock status of the vehicle
extension VehicleDoorLockStatus {
	
	fileprivate var statusColor: UIColor {
		switch self {
		case .lockedExternal:		return ColorName.vehicleStatusClosed.color
		case .lockedInternal:		return ColorName.vehicleStatusClosed.color
		case .unknown:				return ColorName.vehicleStatusUnknown.color
		case .unlocked:				return ColorName.vehicleStatusOpened.color
		case .unlockedSelective:	return ColorName.vehicleStatusOpened.color
		}
	}
}


// MARK: - VehicleLockStatus

// Colors for every lock status of the vehicle
extension VehicleLockStatus {
	
	fileprivate var statusColor: UIColor {
		switch self {
		case .lockedExternal:		return ColorName.vehicleStatusClosed.color
		case .lockedInternal:		return ColorName.vehicleStatusClosed.color
		case .unknown:				return ColorName.vehicleStatusUnknown.color
		case .unlocked:				return ColorName.vehicleStatusOpened.color
		case .unlockedSelective:	return ColorName.vehicleStatusOpened.color
		}
	}
}
