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

//MARK: - Alarm Cell Header
class AlarmHeaderCell: BaseListCell<AlarmItem> {
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.alarmItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .cell()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		backgroundColor = .clear
		contentView.layer.backgroundColor = UIColor.clear.cgColor
		contentView.backgroundColor = .clear
		isUserInteractionEnabled = false
		
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
		
		listContentView.backgroundColor = .clear
		
		
		viewConstraintCheck = bottomConstraint
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		setupViewsIfNeeded()
		var content: UIListContentConfiguration = defaultListContentConfiguration().updated(for: state)

		guard let item = state.alarmItem else {
			print("cannot load alarm item")
			return
		}
		content.text = "\(item.title)"
		content.textProperties.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		content.textProperties.alignment = .center
		content.textProperties.color = ThemeV2.TextColor.DefaultColor
		listContentView.configuration = content
	}

}

class MyDatePicker: UIDatePicker {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("touched")
	}
	
}

// MARK: - Alarm Cell
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
	
	lazy var calendarView: MyDatePicker = {
		let view = MyDatePicker()
		view.preferredDatePickerStyle = .compact
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.datePickerMode = .time
		view.contentHorizontalAlignment = .trailing
		view.addTarget(self, action: #selector(handleDatePicker), for: .editingDidEnd)
		return view
	}()
	
	private var toggle: UISwitch? = nil
	
	var isEnabledClosure: ((Bool) -> ())? = nil
	
	var isAllDayClosure: ((Bool) -> ())? = nil
	
	var dateChange: ((Date) -> ())? = nil
	
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
		content.text = "\(item.title)"
		content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
		listContentView.configuration = content
		
		if (item.isPreset ?? false && (item.presetType != nil && item.presetType != -1)) {
			accessories = [.checkmark()]
		}		
		
		addSwitch(with: state.alarmItem)
		addCalendar(with: state.alarmItem)
	}
	
	private func addCalendar(with item: AlarmItem?) {
		if (item?.section ?? .Custom == .Custom) {
			listContentView.addSubview(calendarView)
			
			calendarView.topAnchor.constraint(equalTo: listContentView.topAnchor).isActive = true
			calendarView.bottomAnchor.constraint(equalTo: listContentView.bottomAnchor).isActive = true
			calendarView.leadingAnchor.constraint(equalTo: listContentView.leadingAnchor).isActive = true
			calendarView.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor).isActive = true
		}
	}
	
	// add switches to the "all day" item and "enabled" item
	private func addSwitch(with item: AlarmItem?) {
		guard let item = item else { return }

		switch item.section {
			case .AllDay:
				self.toggle = UISwitch()
				guard let toggle = self.toggle else { return }
				toggle.addTarget(self, action: #selector(handleAllDay), for: .valueChanged)
				let customAccessory = UICellAccessory.CustomViewConfiguration(
				  customView: toggle,
				  placement: .trailing(displayed: .always))
				accessories = [.customView(configuration: customAccessory)]
				
				if item.reminder != nil {
					if item.isAllDay ?? false {
						toggle.isOn = item.isAllDay ?? false
					} else {
						toggle.isOn = item.isAllDay ?? false
					}
				} else {
					toggle.isOn = item.isAllDay ?? false
				}
			case .Enabled:
				self.toggle = UISwitch()
				guard let toggle = self.toggle else { return }
				toggle.addTarget(self, action: #selector(handleEnabled), for: .valueChanged)
				let customAccessory = UICellAccessory.CustomViewConfiguration(
				  customView: toggle,
				  placement: .trailing(displayed: .always))
				accessories = [.customView(configuration: customAccessory)]
				
				if item.reminder != nil {
					toggle.isOn = true // to do update with data
				} else {
					toggle.isOn = false
				}
			default:
				()
		}
	}
	
	/*
	
		Handlers
	
	*/
	@objc func handleEnabled() {
		guard let toggle = self.toggle else { return }
		isEnabledClosure?(toggle.isOn)
	}
	
	@objc func handleAllDay() {
		guard let toggle = self.toggle else { return }
		isAllDayClosure?(toggle.isOn)
	}
	
	@objc func handleDatePicker() {
		dateChange?(calendarView.date)
	}
}
