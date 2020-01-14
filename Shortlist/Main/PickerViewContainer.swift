//
//  PickerViewContainer.swift
//  Shortlist
//
//  Created by Mark Wong on 30/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class PickerViewContainer: UIView {
		
	private lazy var pickerView: UIDatePicker = {
		let view = UIDatePicker()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
		view.maximumDate = Date().endOfDay
		view.datePickerMode = .time
		view.setValue(UIColor.yellow, forKey: "textColor")
		return view
	}()
	
	private lazy var saveButton: UIButton = {
		let button = UIButton()
		button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
		button.setTitleColor(Theme.Button.textColor, for: .normal)
		button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private lazy var clearButton: UIButton = {
		let button = UIButton()
		button.setTitle("Clear", for: .normal)
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
		button.setTitleColor(Theme.Button.textColor, for: .normal)
		button.addTarget(self, action: #selector(handleClearButton), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
		
	var delegateProtocol: PickerViewContainerProtocol?
	
	init(delegateP: PickerViewContainerProtocol) {
		self.delegateProtocol = delegateP
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	private func setupView() {
		
		addSubview(pickerView)
		pickerView.fillSuperView()
		
		addSubview(saveButton)
		saveButton.anchorView(top: topAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: -5.0), size: CGSize(width: 70.0, height: 30.0))
		addSubview(clearButton)
		clearButton.anchorView(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 5, bottom: 0.0, right: 0.0), size: CGSize(width: 70.0, height: 30.0))
	}
	
	func getValues() -> Date {
		return pickerView.date
	}

	
	// the actual saving of the local notification is done in the main view controller, look for LocalNotificationService
	// We wait until the task has been posted or we'll need to remove the notification
	@objc
	func handleSaveButton() {
		guard let delegateProtocol = delegateProtocol else { return }
		delegateProtocol.closeTimePicker()
	}
	
	@objc
	func handleClearButton() {
		guard let delegateProtocol = delegateProtocol else { return }
		pickerView.date = Date()
		delegateProtocol.closeTimePicker()
	}
}
