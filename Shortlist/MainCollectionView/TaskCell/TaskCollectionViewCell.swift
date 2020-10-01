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
class TaskCellV2: BaseListCell<Task> {
	
	private let completeText: String = "Complete"
	
	private let incompleteText: String = "Incomplete"
	
	private lazy var categoryLabel: UILabel = {
		let label = UILabel()
		label.text = "Category • Complete"
		label.textColor = ThemeV2.TextColor.DefaultColorWithAlpha1
		label.font = ThemeV2.CellProperties.SecondaryFont
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
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .subtitleCell()
	}
	
	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())

	private var viewConstraintCheck: NSLayoutConstraint? = nil

	private var priorityMarker: PriorityIndicator = PriorityIndicator(frame: .zero, priority: .none)

	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		backgroundColor = ThemeV2.CellProperties.Background
		layer.cornerRadius = 10.0
		clipsToBounds = true
		
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(listContentView)
		contentView.addSubview(categoryLabel)
		contentView.addSubview(priorityMarker)
		
		categoryLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
		categoryLabel.leadingAnchor.constraint(equalTo: listContentView.layoutMarginsGuide.leadingAnchor, constant: 0.0).isActive = true
		categoryLabel.trailingAnchor.constraint(equalTo: listContentView.layoutMarginsGuide.trailingAnchor).isActive = true

		listContentView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 0).isActive = true
		viewConstraintCheck = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0.0)
		viewConstraintCheck?.isActive = true
		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0).isActive = true
		listContentView.trailingAnchor.constraint(equalTo: priorityMarker.leadingAnchor, constant: -10.0).isActive = true
		
		priorityMarker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
		priorityMarker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0).isActive = true
		priorityMarker.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
		priorityMarker.widthAnchor.constraint(equalToConstant: 20.0).isActive = true

		layer.borderWidth = 2.0
		layer.borderColor = ThemeV2.CellProperties.Border.cgColor
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		var content = defaultListContentConfiguration().updated(for: state)
		content.textProperties.color = ThemeV2.TextColor.DefaultColor

		if let style = state.taskItem?.redactionStyle() {
			/// Path for 2.0 shortlist users
			// Category label

			categoryLabel.attributedText = state.taskItem?.redactedText(with:"Category • \(completionText(state.taskItem?.complete ?? false))")
			// Content label
			// apply redaction style to font
			content.attributedText = state.taskItem?.redactedText(with: state.taskItem?.name ?? "None")

			// if redacted, then hide the priority color with grey
			switch style {
				case .highlight, .star:
					priorityMarker.updatePriorityColor(with: .none)
				case .none:
					categoryLabel.alpha = 0.6
					if let priority = Priority.init(rawValue: Int16(state.taskItem?.priority ?? 0)) {
						priorityMarker.updatePriorityColor(with: priority)
					}
			}
		} else {
			/// A path for pre-2.0 Shortlist users where redaction was not a feature.
			
			// Category label
			categoryLabel.text = "Category • Complete"
			
			// Content label
			content.text = state.taskItem?.name ?? "None"
			
			if let priority = Priority.init(rawValue: Int16(state.taskItem?.priority ?? 0)) {
				priorityMarker.updatePriorityColor(with: priority)
			}
		}
		
		listContentView.configuration = content
//		// enable disable icons
//		guard let item = state.taskItem else { return }
//		featureStack.enableIcons(with: item)

	}
	
	func completionText(_ state: Bool) -> String {
		if (state) {
			return completeText
		} else {
			return incompleteText
		}
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
