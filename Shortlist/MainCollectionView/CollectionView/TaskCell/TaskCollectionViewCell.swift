//
//  MainCollectionViewCell.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// to do
// task title
// notes
// complete button

class TaskCollectionViewCell: BaseNeuCell<TaskItem> {
	
	// stackview with icons to show the task features
	
//	private lazy var imageView: UIImageView = createImageView()
	
//	private lazy var completionButton: UIButton = createCompletionButton()

//	private lazy var cameraButton: UIButton = createCameraButton()
	
	// horizontal stackview
	private lazy var featureStack: TaskFeatureIcons = TaskFeatureIcons(frame: .zero)
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.font = UIFont.init(name: "HelveticaNeue", size: 20)?.with(weight: .bold)
		label.textColor = UIColor.black.lighter(by: 30)!
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let lightShadow: CALayer = CALayer()
	
	private let darkShadow: CALayer = CALayer()
	
	private var priorityMarker: PriorityIndicator = PriorityIndicator(frame: .zero, priority: .none)
	
	private var item: TaskItem? = nil
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupSubviews()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		configureCellItem(with: .none)
	}
	
	// MARK: - Setup sub views
	private func setupSubviews() {
		contentView.addSubview(titleLabel)
		contentView.addSubview(priorityMarker)
//		contentView.addSubview(featureStack)
		
		featureStack.isUserInteractionEnabled = false
		titleLabel.isUserInteractionEnabled = false
		
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: priorityMarker.leadingAnchor, constant: -10.0).isActive = true
		let titlePriority = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		titlePriority.isActive = true
		
//		let featureStackTopConstraintPriority = featureStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.0)
//		featureStackTopConstraintPriority.priority = UILayoutPriority(999)
//		featureStackTopConstraintPriority.isActive = true
//		featureStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0.0).isActive = true
		
//		let bottomConstraintPriority = featureStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
//		bottomConstraintPriority.isActive = true
		
		priorityMarker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0).isActive = true
		priorityMarker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.0).isActive = true

		priorityMarker.heightAnchor.constraint(equalToConstant: 10.0).isActive = true
		priorityMarker.widthAnchor.constraint(equalToConstant: 10.0).isActive = true
	}
	
	func createCompletionButton() -> UIButton {
		let button = UIButton()
		button.addTarget(self, action: #selector(handleCompleteButton), for: .touchDown)
		let config = UIImage.SymbolConfiguration(pointSize: 20.0)
		let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
		
		image?.withTintColor(.green, renderingMode: .alwaysOriginal)
		button.setImage(image, for: .normal)

		button.tintColor = UIColor.green.darker(by: 10.0)!
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func createCameraButton() -> UIButton {
		let button = UIButton()
		button.addTarget(self, action: #selector(handleCompleteButton), for: .touchDown)
		let config = UIImage.SymbolConfiguration(pointSize: 20.0)
		
		let image = UIImage(systemName: "camera.fill", withConfiguration: config)
		image?.withTintColor(.green, renderingMode: .alwaysOriginal)
		button.setImage(image, for: .normal)

		button.tintColor = UIColor.green.darker(by: 10.0)!
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	func createImageView() -> UIImageView {
		let config = UIImage.SymbolConfiguration(pointSize: 20.0)
		let image = UIImage(systemName: "folder.fill", withConfiguration: config)
		image?.withTintColor(.brown, renderingMode: .alwaysOriginal)
		let view = UIImageView(image: image)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
	
	/// Button Handlers
	@objc func handleCompleteButton() {
		print("taskCompleteButton")
	}
	
	@objc func handleCameraButton() {
		print("Camera")
	}
	
}

extension TaskCollectionViewCell {
	// MARK: - Configure Cell
	func configureCellItem(with item: TaskItem?) {
		// blank cell
		guard let item = item else {
			self.titleLabel.text = "No Title"
			return
		}
		// a fully configure cell
//		titleLabel.numberOfLines = 0
//		titleLabel.font = UIFont.init(name: "HelveticaNeue", size: 20)?.with(weight: .bold)
//		titleLabel.textColor = UIColor.black.lighter(by: 30)!
		
//		DispatchQueue.main.async {
			self.titleLabel.text = "\(item.title)"
			self.priorityMarker.updatePriorityColor(with: item.priority)
//		}
	}
}