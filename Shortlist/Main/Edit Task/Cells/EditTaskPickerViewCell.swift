//
//  EditTaskPickerView.swift
//  Shortlist
//
//  Created by Mark Wong on 4/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskPickerViewCell: CellBase {

	var viewModel: EditTaskViewModel?
	
	private lazy var pickerView: UIDatePicker = {
		let view = UIDatePicker()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
		view.maximumDate = Date().endOfDay
		view.datePickerMode = .time
		view.setValue(UIColor.white, forKey: "textColor")
		view.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		backgroundColor = .clear
		addSubview(pickerView)
		pickerView.fillSuperView()
	}
	
	func getTime() -> Date {
		return pickerView.date
	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
		guard let viewModel = viewModel else { return }
		if (viewModel.reminderToggle) {
			pickerView.isHidden = false
		} else {
			pickerView.isHidden = true
		}
	}
	
	@objc
	func handleDatePicker(_ sender: Any) {
		guard let viewModel = viewModel else { return }
		viewModel.reminderDate = pickerView.date
	}
}


