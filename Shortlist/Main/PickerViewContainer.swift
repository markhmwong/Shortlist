//
//  PickerViewContainer.swift
//  Shortlist
//
//  Created by Mark Wong on 30/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class PickerViewContainer: UIView {
	
	var pickerLabels: [Int: UILabel] = [:]
	
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
	
	private lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setTitle("Close", for: .normal)
		button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	weak var delegate: MainViewController?
	
	init(delegate: MainViewController) {
		self.delegate = delegate
		super.init(frame: .zero)
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard let delegate = delegate else { return }
	}
	
	func setupView() {
		
		addSubview(pickerView)
		pickerView.fillSuperView()
		
		addSubview(closeButton)
		closeButton.anchorView(top: topAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 70.0, height: 30.0))
	}
	
	func getValues() {
		guard let delegate = delegate else { return }
		guard let vm = delegate.viewModel else { return }
		vm.timeInterval = pickerView.date.timeIntervalSince(Date())
	}

	@objc
	func handleCloseButton() {
		guard let delegate = delegate else { return }
		getValues()
		delegate.closeTimePicker()
	}
}
