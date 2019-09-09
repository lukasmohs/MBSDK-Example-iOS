//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBUIKit

class ValueView: MBBaseView {
	
	// MARK: - Struct
	
	private struct Constants {
		static let defaultString = "-"
	}
	
	// MARK: - IBOutlet
	
	@IBOutlet private weak var containerView: UIView!
	@IBOutlet private weak var separatorView: MBSeparatorView!
	@IBOutlet private weak var titleLabel: MBBody1Label!
	@IBOutlet private weak var valueLabel: MBBody1Label!
	
	
	// MARK: - Public
	
	/// Set title and value text
	///
	/// - Parameter title: text for titleLabel
	/// - Parameter value: text for valueLabel
	func set(title: String?, value: String?) {
		
		self.titleLabel.text = title
		self.update(value: value)
		
		if title == nil && value == nil {
			
			self.separatorView.isHidden = true
			self.valueLabel.text = nil
		}
	}
	
	/// Update value text
	///
	/// - Parameter value: text for valueLabel
	func update(value: String?) {
		self.valueLabel.text = value ?? Constants.defaultString
	}
	
	
	// MARK: - View life cycle
	
	public override func setupUI() {
		super.setupUI()
		
		self.backgroundColor               = .clear
		self.containerView.backgroundColor = .clear
		
		self.valueLabel.textColor = MBColorName.risAccentPrimary.color
	}
}
