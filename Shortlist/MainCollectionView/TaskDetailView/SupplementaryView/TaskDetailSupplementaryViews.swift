//
//  TaskDetailHeader.swift
//  Shortlist
//
//  Created by Mark Wong on 31/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
	
	var data: Task? {
		didSet {
			self.reminderText()
			self.priorityLabel.text = "\(data?.priorityText() ?? "None")"
			self.configureCompletionIcon(with: data?.complete ?? false)
		}
	}
	
	private lazy var completionIcon: UIImageView = {
		let config = UIImage.SymbolConfiguration(pointSize: 40.0)
		let image = UIImage(systemName: "checkmark.circle", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
		let view = UIImageView(image: image)
		view.tintColor = UIColor.systemGray.withAlphaComponent(0.4)
		view.contentMode = .scaleAspectFit
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var alarmLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = ThemeV2.CellProperties.HeadingBoldFont
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.text = "None"
		return label
	}()
	
	private lazy var priorityFont: UIFont = UIFont.preferredFont(forTextStyle: .largeTitle).with(weight: .bold)
	
	private lazy var staticPriorityLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.text = " Priority"
		label.font = priorityFont
		return label
	}()
	
	lazy var priorityLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		label.font = priorityFont
		return label
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
		addSubview(alarmLabel)
		addSubview(completionIcon)
		addSubview(priorityLabel)
		addSubview(staticPriorityLabel)
		
		completionIcon.centerYAnchor.constraint(equalTo: priorityLabel.centerYAnchor).isActive = true
		completionIcon.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15.0).isActive = true
		
		NSLayoutConstraint.activate([
			priorityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
			priorityLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15.0),
			alarmLabel.leadingAnchor.constraint(equalTo: priorityLabel.leadingAnchor),
			alarmLabel.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor),
			alarmLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0),
			staticPriorityLabel.leadingAnchor.constraint(equalTo: priorityLabel.trailingAnchor),
			staticPriorityLabel.topAnchor.constraint(equalTo: priorityLabel.topAnchor)
		])
		
		// Task Completion Button Observer
		NotificationCenter.default.addObserver(self, selector: #selector(handleTaskCompletion), name: Notification.Name("TaskCompletionNotification"), object: nil)
		
		
	}
	
	func reminderText() {
		if let reminder = data?.taskToReminder?.reminder {
			alarmLabel.text = reminder.timeToStringInHrMin()
		} else {
			alarmLabel.text = ""
		}
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

