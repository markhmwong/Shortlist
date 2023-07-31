//
//  TaskOptionsPriorityCell.swift
//  Shortlist
//
//  Created by Mark Wong on 19/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit
// not in use
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
    private var darkShadow = CALayer()
    
    private var lightShadow = CALayer()
    
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.priorityItem = self.item
		return state
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = ThemeV2.Background
        self.backgroundColor = ThemeV2.Background
        self.clipsToBounds = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func updateConfiguration(using state: UICellConfigurationState) {
        
        var contentConfig = TaskOptionsPriorityContentConfiguration().updated(for: state)
        if let selected = state.priorityItem?.isSelected {
            if selected {
                contentConfig.name = state.priorityItem?.name
                contentConfig.caption = state.priorityItem?.caption
                contentConfig.priority = state.priorityItem?.priority.rawValue
                contentConfig.textColor = state.priorityItem?.priority.color
            } else {
                contentConfig.caption = state.priorityItem?.caption
                contentConfig.priority = state.priorityItem?.priority.rawValue
                contentConfig.textColor = UIColor.white.adjust(by: -30)!
                contentConfig.isSelected = state.priorityItem?.isSelected
            }
        } else {
            contentConfig.caption = state.priorityItem?.caption
            contentConfig.priority = state.priorityItem?.priority.rawValue
            contentConfig.textColor = UIColor.white.adjust(by: -30)!
            contentConfig.isSelected = state.priorityItem?.isSelected
        }

		contentConfiguration = contentConfig
        
        self.setupNeumorphic()

	}
    
    private func setupNeumorphic() {
        // neumorphic
        let shadowRadius: CGFloat = 3.0
        let cornerRadius: CGFloat = 25.0

        darkShadow.frame = bounds
        darkShadow.backgroundColor = ThemeV2.Background.cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        layer.insertSublayer(darkShadow, at: 0)

        lightShadow.frame = bounds
        lightShadow.backgroundColor = ThemeV2.Background.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
        layer.insertSublayer(lightShadow, at: 0)
        
        darkShadow.shadowColor = ThemeV2.CellProperties.Neumorphic.DarkShadow.cgColor
        lightShadow.shadowColor = ThemeV2.CellProperties.Neumorphic.LightShadow.cgColor
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
        updatedConfiguration.textColor = textColor
        updatedConfiguration.name = name
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
	
	
	private lazy var priorityTitleLabel: PaddedLabel = {
		let tf = PaddedLabel(yPadding: 5.0)
        tf.font = ThemeV2.CellProperties.Title1Black
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
		addSubview(descriptionLabel)
		addSubview(priorityTitleLabel)

		
		constraintCheck = descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        constraintCheck?.isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		priorityTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		priorityTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
	}
    

	
	private func apply(configuration: TaskOptionsPriorityContentConfiguration) {
		guard currentConfiguration != configuration else {
			return
		}
		
		// Replace current configuration with new configuration
		currentConfiguration = configuration
        priorityTitleLabel.text = Priority.init(rawValue: currentConfiguration.priority ?? 3)?.stringValue
		descriptionLabel.text = currentConfiguration.caption
        priorityTitleLabel.textColor = currentConfiguration.textColor
        descriptionLabel.textColor = currentConfiguration.textColor

        layer.cornerRadius = 20.0

        clipsToBounds = false
        self.backgroundColor = ThemeV2.Background
	}
	
	func textViewDidChange(_ textView: UITextView) {
		currentConfiguration.name = textView.text ?? ""
	}
}

