//
//  CalendarCell.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Calendar Cell
class CalendarCell: BaseTableListCell<TaskOptionsItem> {
	
	lazy var calendarView: UIDatePicker = {
		let view = UIDatePicker()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.preferredDatePickerStyle = .automatic
		view.datePickerMode = .time
		view.contentHorizontalAlignment = .trailing
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		setupCellViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellViews() {
		super.setupCellViews()
		contentView.addSubview(calendarView)
		
		calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		calendarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
	}
}

class CustomDatePicker: UIDatePicker {
	
}
