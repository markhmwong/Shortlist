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
// MARK: - Task Cell Version 2
class TaskCellV2: BaseCell<Task> {
	
	private let completeText: String = "Complete"
	
	private let incompleteText: String = "Incomplete"
	
    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "High"
        label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
        label.font = ThemeV2.CellProperties.Title1Black
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
	
	private lazy var categoryLabel: UILabel = {
		let label = UILabel()
		label.text = "Category • Complete"
		label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
		label.font = ThemeV2.CellProperties.SecondaryFont
		label.translatesAutoresizingMaskIntoConstraints = false
		label.layoutMargins = .zero
		label.alpha = 0.7
		return label
	}()
	
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
	
	private lazy var featureStack: TaskFeatureIcons = TaskFeatureIcons(frame: .zero)

	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.taskItem = self.item
		return state
	}

	private var viewConstraintCheck: NSLayoutConstraint? = nil

	private lazy var dividerLine: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.black.adjust(by: 90)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private func setupViewsIfNeeded() {
//		guard viewConstraintCheck == nil else { return }
//		let lateralPadding: CGFloat = 25.0
//		let topAndBottomPadding: CGFloat = 0.0

		backgroundColor = .green
//		layer.cornerRadius = 40.0
//		clipsToBounds = false
//		layer.borderWidth = 0.0
//		layer.borderColor = ThemeV2.CellProperties.Border.cgColor
        
//		contentView.backgroundColor = .clear
		
//		let bg = UIView()
//        bg.backgroundColor = ThemeV2.Background
//		backgroundView = bg
//
//        // neumorphic
//
//        let cornerRadius: CGFloat = 15
//        let shadowRadius: CGFloat = 2
//
//        let darkShadow = CALayer()
//        darkShadow.frame = bounds
//        darkShadow.backgroundColor = ThemeV2.Background.cgColor
//        darkShadow.shadowColor = UIColor(red: 0.87, green: 0.89, blue: 0.93, alpha: 1.0).cgColor
//        darkShadow.cornerRadius = cornerRadius
//        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
//        darkShadow.shadowOpacity = 1
//        darkShadow.shadowRadius = shadowRadius
//        backgroundView?.layer.insertSublayer(darkShadow, at: 0)
//
//        let lightShadow = CALayer()
//        lightShadow.frame = bounds
//        lightShadow.backgroundColor = ThemeV2.Background.cgColor
//        lightShadow.shadowColor = UIColor.white.cgColor
//        lightShadow.cornerRadius = cornerRadius
//        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
//        lightShadow.shadowOpacity = 1
//        lightShadow.shadowRadius = shadowRadius
//        backgroundView?.layer.insertSublayer(lightShadow, at: 0)
//        print(bounds)

		contentView.addSubview(taskNameLabel)
        contentView.addSubview(priorityLabel)
//		contentView.addSubview(categoryLabel)
		contentView.addSubview(completeStatus)

//        priorityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topAndBottomPadding).isActive = true
//        priorityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: lateralPadding).isActive = true
//        priorityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//
//        viewConstraintCheck = taskNameLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 0.0)
//        viewConstraintCheck?.isActive = true
//		taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: lateralPadding).isActive = true
//		taskNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -55).isActive = true
//
//
//		completeStatus.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//		completeStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -lateralPadding).isActive = true
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
		} else {
			/// A path for pre-2.0 Shortlist users where redaction was not a feature.
			
			// Category label
//			categoryLabel.text = "Category • Complete"
			
            // Priority Label
            priorityLabel.text = "Unknown"
            
			// Content label
			taskNameLabel.text = state.taskItem?.name ?? "None"
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



// MARK: - Deprecated to be removed
class TaskCollectionViewCell: BaseNeuCollectionViewCell<TaskItem> {
	
	// stackview with icons to show the task features
	
//	private lazy var imageView: UIImageView = createImageView()
	
//	private lazy var completionButton: UIButton = createCompletionButton()

//	private lazy var cameraButton: UIButton = createCameraButton()
	
	// horizontal stackview
	private lazy var featureStack: TaskFeatureIcons = TaskFeatureIcons(frame: .zero)
	
	private lazy var titleLabel: RedactedLabel = {
		guard let item = item else {
			// default state
			let label = RedactedLabel()
			return label
		}
		let label = RedactedLabel()
		return label
	}()
	
	private let lightShadow: CALayer = CALayer()
	
	private let darkShadow: CALayer = CALayer()
	
	private var priorityMarker: PriorityIndicator = PriorityIndicator(frame: .zero, priority: .none)
	
//	private var item: TaskItem? = nil
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		self.setupViewAdditionalViews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		configureCell(with: .none)
	}
	
	// MARK: - Setup sub views
	private func setupViewAdditionalViews() {
        
		contentView.addSubview(titleLabel)
		contentView.addSubview(priorityMarker)
		contentView.addSubview(featureStack)
		
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: priorityMarker.leadingAnchor, constant: -10.0).isActive = true
		let titlePriority = titleLabel.bottomAnchor.constraint(equalTo: featureStack.topAnchor, constant: -10.0)
		titlePriority.isActive = true
		
		let featureStackTopConstraintPriority = featureStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.0)
		featureStackTopConstraintPriority.priority = UILayoutPriority(999)
		featureStackTopConstraintPriority.isActive = true
		featureStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0.0).isActive = true
		
		let bottomConstraintPriority = featureStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
		bottomConstraintPriority.isActive = true
		
		priorityMarker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
		priorityMarker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0).isActive = true

		priorityMarker.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
		priorityMarker.widthAnchor.constraint(equalToConstant: 10.0).isActive = true
	}
	
	/// Button Handlers
	@objc func handleCompleteButton() {
		print("taskCompleteButton")
	}
	
	@objc func handleCameraButton() {
		print("Camera")
	}
	
	//temp
	private var state: RedactState?
	
	// MARK: - Configure Cell
	override func configureCell(with item: TaskItem?) {
		
		// blank cell
		guard let item = item else {
			self.titleLabel.text = "No Title"
			return
		}
		// a fully configure cell
		
		// highlight the priority marker with the correct color
		self.priorityMarker.updatePriorityColor(with: item.priority)
		
		// censor text
//		self.titleLabel.redactText(with: "\(item.title)", redactWithEffect: item.redaction.effect)
//		self.titleLabel.redactText(with: item.title, state: item.redacted, style: RedactStyle.stars, rType: RSStars())
		// in core data make a new entity for redact style, 1-1
		
		// enable disable icons
//		featureStack.enableIcons(with: item)
	}
}
