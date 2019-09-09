//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import UIKit
import MBMobileSDK
import MBCarKit
import MBUIKit

class CommandDoorView: MBBaseView {

	typealias ButtonHandler = (MBControlActivityConformable) -> Void
	
	// MARK: - IBOutlet
	
	@IBOutlet private weak var titleLabel: MBHeadline5Label!
	@IBOutlet private weak var errorView: ValueView!
	@IBOutlet private weak var stateView: ValueView!
	@IBOutlet private weak var timestampView: ValueView!
	@IBOutlet private weak var startButton: MBPrimaryButton!
	@IBOutlet private weak var stopButton: MBPrimaryButton!
	
	
	// MARK: - Properties
	
	private var startHandler: ButtonHandler?
	private var stopHandler: ButtonHandler?
	
	
	// MARK: - Internal
	
    /// Configures the view
    ///
    /// - Parameters:
    ///   - title: view title
    ///   - startTitle: title for the start button
    ///   - stopTitle: title for the stop button
    ///   - start: completion for the start button
    ///   - stop: completion for the stop button
	func configure(title: String?, startTitle: String?, stopTitle: String, start: @escaping ButtonHandler, stop: @escaping ButtonHandler) {
		
		self.startHandler = start
		self.stopHandler  = stop
		
		self.titleLabel.text = title
		self.startButton.setTitle(startTitle, for: .normal)
		self.stopButton.setTitle(stopTitle, for: .normal)
	}
	
	
    /// Handles the state of the command and updates the UI if needed
	func handle<T: CommandErrorProtocol>(commandProcessingState: CommandProcessingState<T>, meta: CommandProcessingMetaData, button: MBControlActivityConformable) {
		
		switch commandProcessingState {
			
		case .updated(let state):
			self.handleCommandUpdated(state: state, meta: meta, button: button)
			
		case .failed(let errors):
			self.handleCommandFailed(errors: errors, meta: meta, button: button)
			
		case .finished:
			self.handleCommandFinished(meta: meta, button: button)
		}
	}
	
    /// Resets the view
	func reset() {
		
		self.startButton.activate(state: MBControlActivityState.interactable)
		self.stopButton.activate(state: MBControlActivityState.interactable)
		
		self.errorView.set(title: L10n.commandErrors, value: nil)
		self.stateView.set(title: L10n.commandState, value: nil)
		self.timestampView.set(title: L10n.commandTimestamp, value: nil)
	}
	
	
	// MARK: - View Lifecycle
	
	override func setupUI() {
		super.setupUI()
		
		self.reset()
		
		self.startButton.addTarget(self, action: #selector(self.startButtonPressed), for: .touchUpInside)
		self.startButton.titleLabel?.adjustsFontSizeToFitWidth = true

		self.stopButton.addTarget(self, action: #selector(self.stopButtonPressed), for: .touchUpInside)
		self.stopButton.titleLabel?.adjustsFontSizeToFitWidth = true
	}
	
	
	// MARK: - Button management
	
	@objc private func startButtonPressed() {
		self.startHandler?(self.startButton)
	}
	
	@objc private func stopButtonPressed() {
		self.stopHandler?(self.stopButton)
	}
	
	
	// MARK: - Helper
	
	private func handleCommandUpdated(state: VehicleCommandStateType, meta: CommandProcessingMetaData, button: MBControlActivityConformable) {

		// wait until the command is at least in the state .processing
		if state != .accepted {
			button.activate(state: .interactable)
		}
		
		switch state {
		case .accepted:
			self.stateView.update(value: "🚀")
		case .enqueued:
			self.stateView.update(value: "🔜")
		case .processing:
			self.stateView.update(value: "⚙️")
		case .waiting:
			self.stateView.update(value: "⏳")
		}
		
		self.errorView.update(value: "-")
		self.timestampView.update(value: "\(meta.timestamp)")
	}
	
	private func handleCommandFailed(errors: [CommandErrorProtocol], meta: CommandProcessingMetaData, button: MBControlActivityConformable) {
		
		for error in errors {
			
			guard let genericError = error.unwrapGenericError() else {
				continue
			}
			
			self.handle(genericError: genericError, button: button)
		}
		
		button.activate(state: .interactable)
		
		self.errorView.update(value: errors.map { "\($0)" }.joined(separator: "/"))
		self.stateView.update(value: "❌")
		self.timestampView.update(value: "\(meta.timestamp)")
	}
	
	// This could be a generic handler for all commands while the above handler is meant for handling the errors of a single command
	private func handle(genericError: GenericCommandError, button: MBControlActivityConformable) {
		
		switch genericError {
		case .noVehicleSelected:
			AlertHelper.showOK(from: self.viewController(), type: .hint(message: L10n.sendCommandError))
		default:
			break
		}
	}
	
	private func handleCommandFinished(meta: CommandProcessingMetaData, button: MBControlActivityConformable) {
		
		button.activate(state: .interactable)
		
		self.errorView.update(value: "-")
		self.stateView.update(value: "✅")
		self.timestampView.update(value: "\(meta.timestamp)")
	}
}


// MARK: - Extension UIView

fileprivate extension UIView {
	
	func viewController() -> UIViewController? {
		
		if let nextResponder = self.next as? UIViewController {
			return nextResponder
		} else if let nextResponder = self.next as? UIView {
			return nextResponder.viewController()
		} else {
			return nil
		}
	}
}
