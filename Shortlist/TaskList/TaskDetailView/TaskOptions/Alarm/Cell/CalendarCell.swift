//
//  CalendarCell.swift
//  Shortlist
//
//  Created by Mark Wong on 25/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

private extension UICellConfigurationState {
	var alarmItem: AlarmItem? {
		set { self[.alarmItem] = newValue }
		get { return self[.alarmItem] as? AlarmItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let alarmItem = UIConfigurationStateCustomKey("com.whizbang.state.whatsnew")
}

// MARK: - Calendar Cell
class AlarmCell: BaseListCell<AlarmItem> {
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .sidebarHeader()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	lazy var calendarView: UIDatePicker = {
		let view = UIDatePicker()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.preferredDatePickerStyle = .automatic
		view.datePickerMode = .time
		view.contentHorizontalAlignment = .trailing
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViewsIfNeeded() {
		guard viewConstraintCheck == nil else { return }
		contentView.addSubview(listContentView)
		
		listContentView.translatesAutoresizingMaskIntoConstraints = false
		listContentView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
		let bottomConstraint = listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bottomConstraint.isActive = true
		listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
		listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
		
		viewConstraintCheck = bottomConstraint
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		var content: UIListContentConfiguration = defaultListContentConfiguration().updated(for: state)
		content.text = "\(state.alarmItem?.title ?? "Unknown")"
		content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
		content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption2)
		listContentView.configuration = content
		
		guard let item = item else { return }

		addSwitch(with: state.alarmItem)
	}
	
	private func addSwitch(with item: AlarmItem?) {
		guard let item = item else { return }

		if let isAllDay = item.isAllDay {
			let enableAllDayAlarm = UISwitch()
			enableAllDayAlarm.addTarget(self, action: #selector(handleAllDay), for: .valueChanged)
			enableAllDayAlarm.isOn = isAllDay // to do update with data
			let customAccessory = UICellAccessory.CustomViewConfiguration(
			  customView: enableAllDayAlarm,
			  placement: .trailing(displayed: .always))
			accessories = [.customView(configuration: customAccessory)]
		}
	}
	
	@objc func handleAllDay() {
		
	}
}

class CustomDatePicker: UIDatePicker {
	
}
