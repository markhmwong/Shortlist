//
//  TaskDetailHeader.swift
//  Shortlist
//
//  Created by Mark Wong on 31/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
	
	private lazy var completionIcon: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: 40.0)
		let image = UIImage(systemName: "checkmark.circle", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.systemGray.withAlphaComponent(0.4)
		view.contentMode = .scaleAspectFit
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var reminderIcon: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: 13.0)
		let image = UIImage(systemName: "deskclock.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let imageView = UIImageView(image: image)
		imageView.tintColor = UIColor.green.darker()!
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	lazy var photoIcon: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: 13.0)
		let image = UIImage(systemName: "photo.fill.on.rectangle.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let imageView = UIImageView(image: image)
		imageView.tintColor = UIColor.green.darker()!
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	lazy var noteIcon: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: 13)
		let image = UIImage(systemName: "note.text", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let imageView = UIImageView(image: image)
		imageView.tintColor = UIColor.green.darker()!
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	lazy var staticPriorityLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.textColor = .white
		label.text = "Priority"
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		return label
	}()
	
	lazy var priorityLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
		return label
	}()
	
	lazy var dateLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = .black
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .medium)
		return label
	}()
	
	lazy var stackView: UIStackView = {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alignment = .leading
		view.distribution = .fillEqually
		view.spacing = 10.0
		view.axis = .horizontal
		return view
	}()
	
	static let reuseIdentifier = "title-supplementary-reuse-identifier"

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	func configure() {
		addSubview(completionIcon)
		addSubview(priorityLabel)
		addSubview(dateLabel)
		addSubview(staticPriorityLabel)
		
		// temp
		dateLabel.text = "31/7/2020"
		dateLabel.alpha = 0.4
		
		completionIcon.centerYAnchor.constraint(equalTo: priorityLabel.centerYAnchor).isActive = true
		completionIcon.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
		
		NSLayoutConstraint.activate([
			priorityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
			priorityLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0),
			dateLabel.leadingAnchor.constraint(equalTo: priorityLabel.leadingAnchor),
			dateLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor),
			dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),
			staticPriorityLabel.leadingAnchor.constraint(equalTo: priorityLabel.trailingAnchor),
			staticPriorityLabel.topAnchor.constraint(equalTo: priorityLabel.topAnchor)
		])
		
		// Task Completion Button Observer
		NotificationCenter.default.addObserver(self, selector: #selector(handleTaskCompletion), name: Notification.Name("TaskCompletionNotification"), object: nil)
	}
	
	func configureCompletionIcon(with status: Bool) {
		UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut]) {
			self.completionIcon.tintColor = status ? .systemGreen : UIColor.systemGray.withAlphaComponent(0.3)
		} completion: { (complete) in
			//
		}
	}
	
	var tempStatus: Bool = false // temp
	
	@objc func handleTaskCompletion() {
		tempStatus = !tempStatus
		configureCompletionIcon(with: tempStatus)
	}
}

class FooterSupplementaryView: UICollectionReusableView {
	
	private let completeButton: NeuButton = NeuButton(title: "Mark As Complete")
	
	static let reuseIdentifier = "title-supplementary-footer-reuse-identifier"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		fatalError("Footer Invalid")
	}
	
	private func configure() {

		completeButton.contentEdgeInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
		
		addSubview(completeButton)
		completeButton.addTarget(self, action: #selector(handleCompleteButton), for: .touchDown)
		completeButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
		completeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
		completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
		completeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
	}
	
	@objc func handleCompleteButton() {
		completeButton.pressedAnimation()
		print("handle complete")
		NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "TaskCompletionNotification")))
	}
}
