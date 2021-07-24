//
//  MainCollectionViewCell.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
// To do
// complete button
// long press actions

// These two extensions must be individually classified for each cell. You'll also find these extensions at WhatsNewCell and PermissionsCell
// Declare an extension on the cell state struct to provide a typed property for this custom state.
private extension UICellConfigurationState {
	var taskItem: Task? {
		set {
			self[.taskItem] = newValue
		}
		get { return self[.taskItem] as? Task }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let taskItem = UIConfigurationStateCustomKey("com.whizbang.state.task")
}
// MARK: - Main Task Cell Version
class MainTaskCell: BaseCell<Task> {
	
	private let completeText: String = "Complete"
	
	private let incompleteText: String = "Incomplete"
	
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "High"
        label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
        label.font = ThemeV2.CellProperties.Title1Regular
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        label.alpha = 0.7
        return label
    }()
    
	lazy var completeStatus: UIImageView = {
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.Title2Regular)
		let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.systemGreen.darker(by: 0)!
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
//	private lazy var categoryLabel: UILabel = {
//		let label = UILabel()
//		label.text = "Category • Complete"
//		label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
//		label.font = ThemeV2.CellProperties.SecondaryFont
//		label.translatesAutoresizingMaskIntoConstraints = false
//		label.layoutMargins = .zero
//		label.alpha = 0.7
//		return label
//	}()
	
	private lazy var taskNameLabel: UILabel = {
		let label = UILabel()
		label.text = ""
		label.numberOfLines = 0
		label.textColor = ThemeV2.TextColor.DefaultColor
        label.font = ThemeV2.CellProperties.Title1Black //changed dynamically, not controlled here
		label.translatesAutoresizingMaskIntoConstraints = false
		label.layoutMargins = .zero
		return label
	}()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.alpha = 0.8
        label.textColor = ThemeV2.TextColor.DefaultColor
        label.font = ThemeV2.CellProperties.TertiaryFont //changed dynamically, not controlled here
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutMargins = .zero
        return label
    }()
	
	private lazy var featureStack: TaskFeatureIcons = TaskFeatureIcons(frame: .zero)

	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.taskItem = self.item
		return state
	}

	private var viewConstraintCheck: NSLayoutConstraint? = nil

    private var darkShadow = CALayer()
    
    private var lightShadow = CALayer()
    
    
	private func setupViewsIfNeeded() {
        self.contentView.backgroundColor = ThemeV2.Background.adjust(by: -5)
		guard viewConstraintCheck == nil else { return }
		let lateralPadding: CGFloat = 25.0
		let topAndBottomPadding: CGFloat = 50.0

//		backgroundColor = .clear
        contentView.layer.cornerRadius = 40.0
		clipsToBounds = false
		layer.borderWidth = 0.0

        self.setupNeumorphic()

		contentView.addSubview(taskNameLabel)
        contentView.addSubview(priorityLabel)
		contentView.addSubview(completeStatus)
        contentView.addSubview(notesLabel)
        
        priorityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topAndBottomPadding).isActive = true
        priorityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: lateralPadding).isActive = true
        priorityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        viewConstraintCheck = taskNameLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: topAndBottomPadding)
        viewConstraintCheck?.isActive = true
		taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: lateralPadding).isActive = true
		taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55).isActive = true

        notesLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 20).isActive = true
        notesLabel.leadingAnchor.constraint(equalTo: taskNameLabel.leadingAnchor, constant: 0).isActive = true
        notesLabel.trailingAnchor.constraint(equalTo: taskNameLabel.trailingAnchor, constant: 0).isActive = true

		completeStatus.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
		completeStatus.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
	}
    
    func setupNeumorphic() {
        // neumorphic
        let shadowRadius: CGFloat = 9.0
        let cornerRadius: CGFloat = 40.0
        
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        darkShadow.shadowColor = ThemeV2.CellProperties.Neumorphic.DarkShadow.cgColor
        lightShadow.shadowColor = ThemeV2.CellProperties.Neumorphic.LightShadow.cgColor
    }
    
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		
        guard state.taskItem != nil else {
			
			return
		}
		
        if (state.taskItem?.redactionStyle()) != nil {
			/// Path for 2.0 shortlist users
			// Category label

//			categoryLabel.attributedText = state.taskItem?.redactedText(with:"Category • \(completionText(state.taskItem?.complete ?? false)) • \(reminderText(state.taskItem))")
//            categoryLabel.attributedText = state.taskItem?.redactedText(with:"Category • \(priorityText(Priority(rawValue: state.taskItem?.priority ?? 0) ?? .low)) • \(reminderText(state.taskItem))")
            priorityLabel.attributedText = state.taskItem?.redactedText(with:"\(priorityText(Priority(rawValue: state.taskItem?.priority ?? 0) ?? .low))")
            
			// Content label
			// apply redaction style to font
			taskNameLabel.attributedText = state.taskItem?.redactedText(with: state.taskItem?.name ?? "None")
			
			if let priority = Priority.init(rawValue: state.taskItem?.priority ?? 0) {
				// text size
				switch priority {
					case .high:
						taskNameLabel.font = ThemeV2.Priority.HighPriorityFont
					case .medium:
						taskNameLabel.font = ThemeV2.Priority.MediumPriorityFont
					case .low:
						taskNameLabel.font = ThemeV2.Priority.LowPriorityFont
					default:
						taskNameLabel.font = ThemeV2.Priority.HighPriorityFont
				}
                priorityLabel.textColor = priority.color
			}
            
            if let note = state.taskItem?.taskToNotes?.firstObject as? TaskNote {
                notesLabel.attributedText = state.taskItem?.redactedText(with: note.note ?? "Unknown Note")
            }
            
            
		} else {
			/// A path for pre-2.0 Shortlist users where redaction was not a feature.
			
			// Category label
//			categoryLabel.text = "Category • Complete"
			
            // Priority Label
            priorityLabel.text = "Unknown"
            
			// Content label
			taskNameLabel.text = state.taskItem?.name ?? "None"
            
            // note label
            notesLabel.text = "Unknown"
		}
		
		completeStatus.tintColor = state.taskItem?.complete ?? false ? UIColor.systemGreen : UIColor.systemGray
		
	}
	
	func completionText(_ state: Bool) -> String {
		if (state) {
			return completeText
		} else {
			return incompleteText
		}
	}
	
	func reminderText(_ task: Task?) -> String {
		if let reminderDate = task?.taskToReminder?.reminder {
			return "\(reminderDate.timeToStringInHrMin())"
		} else {
			return ""
		}
	}
	
	func priorityText(_ priority: Priority) -> String {
		return priority.stringValue
	}
}
