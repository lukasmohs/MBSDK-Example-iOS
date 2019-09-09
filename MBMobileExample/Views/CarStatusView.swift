//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBCommonKit
import MBCarKit
import MBUIKit

class CarStatusView: MBBaseView {
	
	// MARK: - IBOutlet
    
    @IBOutlet private weak var containerView: UIView!
	@IBOutlet private var stackViewCollection: [UIStackView]!
	
	@IBOutlet private weak var doorsTitleLabel: MBHeadline5Label!
	@IBOutlet private weak var doorFrontLeftTitleLabel: MBSubtitle1Label!
	@IBOutlet private weak var frontLeftLockStatusValueView: ValueView!
	@IBOutlet private weak var frontLeftDoorStatusValueView: ValueView!
	@IBOutlet private weak var doorFrontRightTitleLabel: MBSubtitle1Label!
	@IBOutlet private weak var frontRightLockStatusValueView: ValueView!
	@IBOutlet private weak var frontRightDoorStatusValueView: ValueView!
	@IBOutlet private weak var doorRearLeftTitleLabel: MBSubtitle1Label!
	@IBOutlet private weak var rearLeftLockStatusValueView: ValueView!
	@IBOutlet private weak var rearLeftDoorStatusValueView: ValueView!
	@IBOutlet private weak var doorRearRightTitleLabel: MBSubtitle1Label!
	@IBOutlet private weak var rearRightLockStatusValueView: ValueView!
	@IBOutlet private weak var rearRightDoorStatusValueView: ValueView!
	@IBOutlet private weak var doorDecklidTitleLabel: MBSubtitle1Label!
	@IBOutlet private weak var decklidDoorStatusValueView: ValueView!
	@IBOutlet private weak var decklidLockStatusValueView: ValueView!
	
	@IBOutlet private weak var tankTitleLabel: MBHeadline5Label!
	@IBOutlet private weak var tankElectLevelValueView: ValueView!
	@IBOutlet private weak var tankElectRangeValueView: ValueView!
	@IBOutlet private weak var tankGasLevelValueView: ValueView!
	@IBOutlet private weak var tankGasRangeValueView: ValueView!
	@IBOutlet private weak var tankLiquidLevelValueView: ValueView!
	@IBOutlet private weak var tankLiquidRangeValueView: ValueView!

	
	// MARK: - Public
	
	public func update(doors: VehicleDoorsModel) {
		
		self.frontLeftDoorStatusValueView.update(value: doors.frontLeft.state.value?.toString)
		self.frontLeftLockStatusValueView.update(value: doors.frontLeft.lockState.value?.toString)
		self.frontRightDoorStatusValueView.update(value: doors.frontRight.state.value?.toString)
		self.frontRightLockStatusValueView.update(value: doors.frontRight.lockState.value?.toString)
		self.rearLeftDoorStatusValueView.update(value: doors.rearLeft.state.value?.toString)
		self.rearLeftLockStatusValueView.update(value: doors.rearLeft.lockState.value?.toString)
		self.rearRightDoorStatusValueView.update(value: doors.rearRight.state.value?.toString)
		self.rearRightLockStatusValueView.update(value: doors.rearRight.lockState.value?.toString)
		
		self.decklidDoorStatusValueView.update(value: doors.decklid.state.value?.toString)
		self.decklidLockStatusValueView.update(value: doors.decklid.lockState.value?.toString)
	}
	
	public func update(tank: VehicleTankModel) {
		
		self.tankElectLevelValueView.update(value: self.toString(unit: tank.electricLevel.unit))
		self.tankElectRangeValueView.update(value: self.toString(unit: tank.electricRange.unit))
		self.tankGasLevelValueView.update(value: self.toString(double: tank.gasLevel.value))
		self.tankGasRangeValueView.update(value: self.toString(unit: tank.gasRange.unit))
		self.tankLiquidLevelValueView.update(value: self.toString(unit: tank.liquidLevel.unit))
		self.tankLiquidRangeValueView.update(value: self.toString(unit: tank.liquidRange.unit))
	}
	
	public func updateView(vehicleStatusModel: VehicleStatusModel) {
		
		self.update(doors: vehicleStatusModel.doors)
		self.update(tank: vehicleStatusModel.tank)
	}

	
	// MARK: - View Lifecycle
	
	override func setupUI() {
		
		self.backgroundColor                = .clear
		self.containerView.backgroundColor  = .clear

		self.doorsTitleLabel.text = L10n.attributesDoorsTitle
		self.doorFrontLeftTitleLabel.text = L10n.attributesDoorsFrontLeft
		self.frontLeftDoorStatusValueView.set(title: L10n.attributesDoorsDoorState, value: nil)
		self.frontLeftLockStatusValueView.set(title: L10n.attributesDoorsLockState, value: nil)
		self.doorFrontRightTitleLabel.text = L10n.attributesDoorsFrontRight
		self.frontRightDoorStatusValueView.set(title: L10n.attributesDoorsDoorState, value: nil)
		self.frontRightLockStatusValueView.set(title: L10n.attributesDoorsLockState, value: nil)
		self.doorRearLeftTitleLabel.text = L10n.attributesDoorsRearLeft
		self.rearLeftDoorStatusValueView.set(title: L10n.attributesDoorsDoorState, value: nil)
		self.rearLeftLockStatusValueView.set(title: L10n.attributesDoorsLockState, value: nil)
		self.doorRearRightTitleLabel.text = L10n.attributesDoorsRearRight
		self.rearRightDoorStatusValueView.set(title: L10n.attributesDoorsDoorState, value: nil)
		self.rearRightLockStatusValueView.set(title: L10n.attributesDoorsLockState, value: nil)
		self.doorDecklidTitleLabel.text = L10n.attributesDoorsDecklid
		self.decklidDoorStatusValueView.set(title: L10n.attributesDoorsState, value: nil)
		self.decklidLockStatusValueView.set(title: L10n.attributesDoorsLockState, value: nil)
		
		self.tankTitleLabel.text = L10n.attributesTankTitle
		self.tankElectLevelValueView.set(title: L10n.attributesTankElectricPercent, value: nil)
		self.tankElectRangeValueView.set(title: L10n.attributesTankElectricRange, value: nil)
		self.tankGasLevelValueView.set(title: L10n.attributesTankGasPercent, value: nil)
		self.tankGasRangeValueView.set(title: L10n.attributesTankGasRange, value: nil)
		self.tankLiquidLevelValueView.set(title: L10n.attributesTankLiquidPercent, value: nil)
		self.tankLiquidRangeValueView.set(title: L10n.attributesTankLiquidRange, value: nil)
	}
    
	
	// MARK: - Helper
	
	private func toString(double: Double?) -> String? {
		
		guard let double = double else {
			return nil
		}
		return "\(double)"
	}
	
	private func toString(int: Int?) -> String {
		
		guard let int = int else {
			return "-"
		}
		return "\(int)"
	}
	
	private func toString<T: RawRepresentable>(unit: VehicleAttributeUnitModel<T>?) -> String? where T.RawValue == Int {
		return unit?.formattedValue
	}
}
