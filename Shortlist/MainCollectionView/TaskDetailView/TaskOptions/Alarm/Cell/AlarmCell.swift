//
//  AlarmCell.swift
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
	static let alarmItem = UIConfigurationStateCustomKey("com.whizbang.state.taskalarm")
}

// MARK: - Calendar Cell
class AlarmCell: BaseListCell<AlarmItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.alarmItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .subtitleCell()
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
	
	private var toggle: UISwitch? = nil
	
	var allDayClosure : ((Bool) -> ())? = nil
	
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

		guard let item = state.alarmItem else {
			print("cannot load alarm item")
			return
		}
		content.text = "\(state.alarmItem?.title ?? "Unknown")"
		content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
		listContentView.configuration = content
		
		addSwitch(with: state.alarmItem)
		addCalendar(with: state.alarmItem)
	}
	
	private func addCalendar(with item: AlarmItem?) {
		if (item?.isCustom ?? false) {
			listContentView.addSubview(calendarView)
			
			calendarView.topAnchor.constraint(equalTo: listContentView.topAnchor).isActive = true
			calendarView.bottomAnchor.constraint(equalTo: listContentView.bottomAnchor).isActive = true
			calendarView.leadingAnchor.constraint(equalTo: listContentView.leadingAnchor).isActive = true
			calendarView.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor).isActive = true
		}
	}
	
	private func addSwitch(with item: AlarmItem?) {
		guard let item = item else { return }

		if let isAllDay = item.isAllDay {
			self.toggle = UISwitch()
			guard let toggle = self.toggle else { return }
			toggle.addTarget(self, action: #selector(handleAllDay), for: .valueChanged)
			toggle.isOn = isAllDay // to do update with data
			let customAccessory = UICellAccessory.CustomViewConfiguration(
			  customView: toggle,
			  placement: .trailing(displayed: .always))
			accessories = [.customView(configuration: customAccessory)]
		}
	}
	
	@objc func handleAllDay() {
		guard let toggle = self.toggle else { return }
		allDayClosure?(toggle.isOn)
	}
}
