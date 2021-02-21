//
//  TaskOptionsPriorityCell.swift
//  Shortlist
//
//  Created by Mark Wong on 19/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

extension UICellConfigurationState {
	var priorityItem: TaskOptionsPriorityItem? {
		set { self[.priorityItem] = newValue }
		get { return self[.priorityItem] as? TaskOptionsPriorityItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let priorityItem = UIConfigurationStateCustomKey("com.whizbang.shortlist.taskOptions.priority")
}

class TaskOptionsPriorityCell: BaseCell<TaskOptionsPriorityItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.priorityItem = self.item
		return state
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
		
	override func updateConfiguration(using state: UICellConfigurationState) {

		let bg = UIView()
		bg.backgroundColor = UIColor.offWhite
		backgroundView = bg
		
		var contentConfig = TaskOptionsPriorityContentConfiguration().updated(for: state)
		contentConfig.name = state.priorityItem?.name
		contentConfig.caption = state.priorityItem?.caption
		contentConfig.priority = state.priorityItem?.priority.rawValue
		contentConfig.isSelected = state.priorityItem?.isSelected
		contentConfiguration = contentConfig
		
		layer.cornerRadius = 10.0
		layer.borderWidth = 5
		
		if state.priorityItem?.isSelected ?? false {
			layer.borderColor = state.priorityItem?.priority.color.cgColor
		} else {
			layer.borderColor = UIColor.offBlack.cgColor
		}
	}
}

// MARK: Config
struct TaskOptionsPriorityContentConfiguration: UIContentConfiguration, Hashable {
	
	var name: String?
	var caption: String?
	var priority: Int16?
	var textColor: UIColor?
	var isSelected: Bool?
	
	func makeContentView() -> UIView & UIContentView {
		TaskOptionsPriorityContentView(configuration: self)
	}
	
	func updated(for state: UIConfigurationState) -> TaskOptionsPriorityContentConfiguration {
		guard state is UICellConfigurationState else {
			return self
		}
		
		var updatedConfiguration = self
		updatedConfiguration.textColor = UIColor.offBlack
		return updatedConfiguration
	}
	
}

// MARK: Content View
class TaskOptionsPriorityContentView: UIView, UIContentView {
	
	var configuration: UIContentConfiguration {
		get {
			  currentConfiguration
		  }
		  set {
			  // Make sure the given configuration is of type InputContentConfiguration
			  guard let newConfiguration = newValue as? TaskOptionsPriorityContentConfiguration else {
				  return
			  }
			  
			  // Apply the new configuration to SFSymbolVerticalContentView
			  // also update currentConfiguration to newConfiguration
			  apply(configuration: newConfiguration)
		  }
		}
	
	private var currentConfiguration: TaskOptionsPriorityContentConfiguration!
	
	private lazy var priorityLabel: PaddedLabel = {
		let tf = PaddedLabel(yPadding: 0.0)
		tf.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(60.0)
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.textAlignment = .center
		return tf
	}()
	
	private lazy var priorityTitleLabel: PaddedLabel = {
		let tf = PaddedLabel(yPadding: 5.0)
//		tf.layer.borderColor = UIColor.offBlack.cgColor
		tf.font = UIFont.preferredFont(forTextStyle: .headline)
		tf.translatesAutoresizingMaskIntoConstraints = false
		tf.textAlignment = .center
		return tf
	}()
	
	private lazy var descriptionLabel: PaddedLabel = {
		let label = PaddedLabel(xPadding: 20.0, yPadding: 20.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.alpha = 0.7
		label.text = ""
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		return label
	}()
	
	private var constraintCheck: NSLayoutConstraint? = nil
	
	init(configuration: TaskOptionsPriorityContentConfiguration) {
		super.init(frame: .zero)
//		layer.cornerRadius = 5.0
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
		addSubview(priorityLabel)
		addSubview(descriptionLabel)
		addSubview(priorityTitleLabel)
		
		priorityLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		constraintCheck = priorityLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20)
		constraintCheck?.isActive = true

//		constraintCheck = priorityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0)
//		constraintCheck?.isActive = true
//		priorityLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 0).isActive = true
//		priorityLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//		priorityLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		
		descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		priorityTitleLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor).isActive = true
		priorityTitleLabel.centerXAnchor.constraint(equalTo: priorityLabel.centerXAnchor).isActive = true
	}
	
	private func apply(configuration: TaskOptionsPriorityContentConfiguration) {
		guard currentConfiguration != configuration else {
			return
		}
		
		// Replace current configuration with new configuration
		currentConfiguration = configuration
		priorityLabel.text = "\(currentConfiguration.name ?? "1")"
		priorityTitleLabel.text = Priority.init(rawValue: currentConfiguration.priority ?? 3)?.stringValue
		descriptionLabel.text = currentConfiguration.caption
		
		if currentConfiguration.isSelected ?? false {
			prioritySet(priority: Priority.init(rawValue: currentConfiguration.priority ?? 3) ?? .medium)
		} else {
			priorityLabel.textColor = UIColor.offBlack
			priorityTitleLabel.textColor = UIColor.offBlack
			descriptionLabel.textColor = UIColor.offBlack
		}
		
	}
	
	func prioritySet(priority: Priority) {
		priorityLabel.textColor = priority.color
		priorityTitleLabel.textColor = priority.color
		descriptionLabel.textColor = priority.color
	}
	
	func textViewDidChange(_ textView: UITextView) {
		currentConfiguration.name = textView.text ?? ""
	}
}

