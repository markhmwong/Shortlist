//
//  TaskDetailCell+Completion.swift
//  Shortlist
//
//  Created by Mark Wong on 17/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension UICellConfigurationState {
	var completionItem: CompletionItem? {
		set { self[.completionItem] = newValue }
		get { return self[.completionItem] as? CompletionItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let completionItem = UIConfigurationStateCustomKey("com.whizbang.shortlist.cell.completion")
}

class TaskDetailCompletionCell: BaseCell<CompletionItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.completionItem = self.item
		return state
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
		
	override func updateConfiguration(using state: UICellConfigurationState) {
		
		var contentConfig = TaskDetailCompletionContentConfiguration().updated(for: state)
		contentConfig.name = state.completionItem?.name
		contentConfig.completionState = state.completionItem?.isComplete
		contentConfiguration = contentConfig
	}
}

// MARK: Config
struct TaskDetailCompletionContentConfiguration: UIContentConfiguration, Hashable {
	
	var name: String?
	var textColor: UIColor?
	var completionState: Bool?
	
	func makeContentView() -> UIView & UIContentView {
		TaskDetailCompletionContentView(configuration: self)
	}
	
	func updated(for state: UIConfigurationState) -> TaskDetailCompletionContentConfiguration {
		guard state is UICellConfigurationState else {
			return self
		}
		
		var updatedConfiguration = self
		updatedConfiguration.textColor = UIColor.offBlack
		return updatedConfiguration
	}
	
}

// MARK: Content View
class TaskDetailCompletionContentView: UIView, UIContentView {
	
	var configuration: UIContentConfiguration {
		get {
			  currentConfiguration
		  }
		  set {
			  // Make sure the given configuration is of type InputContentConfiguration
			  guard let newConfiguration = newValue as? TaskDetailCompletionContentConfiguration else {
				  return
			  }
			  
			  // Apply the new configuration to SFSymbolVerticalContentView
			  // also update currentConfiguration to newConfiguration
			  apply(configuration: newConfiguration)
		  }
		}
	
	private var currentConfiguration: TaskDetailCompletionContentConfiguration!
	
	private lazy var completionButton: UIButton = {
		let tf = UIButton()
		tf.layer.cornerRadius = 10.0
		tf.layer.borderWidth = 2
		tf.layer.borderColor = UIColor.offBlack.cgColor
		tf.setTitleColor(UIColor.black, for: .normal)
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.addTarget(self, action: #selector(handleComplete), for: .touchDown)
		return tf
	}()
	
	private var constraintCheck: NSLayoutConstraint? = nil
	
	init(configuration: TaskDetailCompletionContentConfiguration) {
		super.init(frame: .zero)
		layer.cornerRadius = 5.0
		clipsToBounds = true
		// Custom initializer implementation here.
		// Create the content view UI
		setupAllViews()
		
		// Apply the configuration (set data to UI elements / define custom content view appearance)
		apply(configuration: configuration)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupAllViews() {
		guard constraintCheck == nil else { return }
		addSubview(completionButton)
		
		constraintCheck = completionButton.topAnchor.constraint(equalTo: topAnchor)
		constraintCheck?.isActive = true
		completionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		completionButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		completionButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
	
	private func apply(configuration: TaskDetailCompletionContentConfiguration) {
		guard currentConfiguration != configuration else {
			return
		}
		
		// Replace current configuration with new configuration
		currentConfiguration = configuration
		completionButton.setTitle(currentConfiguration.name, for: .normal)
		
	}
	
	func textViewDidChange(_ textView: UITextView) {
		currentConfiguration.name = textView.text ?? ""
	}
	
	@objc func handleComplete() {
		let config = configuration.makeContentView() as? TaskDetailCompletionContentView
		config?.currentConfiguration.completionState = !(config?.currentConfiguration.completionState ?? false)
		
		if config?.currentConfiguration.completionState ?? false {
			completionButton.setTitleColor(UIColor.systemGreen, for: .normal)
		} else {
			completionButton.setTitleColor(UIColor.systemRed, for: .normal)
		}
	}
}

