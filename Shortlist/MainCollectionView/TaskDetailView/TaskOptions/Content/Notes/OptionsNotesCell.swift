//
//  NotesCell.swift
//  Shortlist
//
//  Created by Mark Wong on 1/10/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

private extension UICellConfigurationState {
	var optionNotesItem: OptionsNotesItem? {
		set { self[.optionNotesItem] = newValue }
		get { return self[.optionNotesItem] as? OptionsNotesItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let optionNotesItem = UIConfigurationStateCustomKey("com.whizbang.state.optionsNotesItem")
}

class EditNoteView: UIView, UIContentView {
	var configuration: UIContentConfiguration
	
	lazy var textView: UITextField = {
		let view = UITextField(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.text = "Test"
		view.textColor = ThemeV2.TextColor.DefaultColor
		view.backgroundColor = .systemOrange
		return view
	}()
	
	init(config: UIContentConfiguration) {
		self.configuration = config
		super.init(frame: .zero)
		self.addSubview(textView)
		textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		textView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
		textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

struct Config: UIContentConfiguration {
	var text: String = "Text String"
	
	func makeContentView() -> UIView & UIContentView {
		return EditNoteView(config: self)
	}
	
	func updated(for state: UIConfigurationState) -> Config {
		return self
	}
}

// MARK: - Calendar Cell
class OptionsNotesCell: BaseListCell<OptionsNotesItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.optionNotesItem = self.item
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
		
		var config = Config()
		config.text = "New Text"
//		listContentView.configuration = config
		self.contentConfiguration = config
//		var content: UIListContentConfiguration = defaultListContentConfiguration().updated(for: state)
		
//		guard let item = state.alarmItem else {
//			print("cannot load alarm item")
//			return
//		}
//		content.text = "\(state.alarmItem?.title ?? "Unknown")"
//		content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
//		listContentView.configuration = content
//
//		addSwitch(with: state.alarmItem)
//		addCalendar(with: state.alarmItem)
	}
//
//	private func addCalendar(with item: OptionsNotesItem?) {
//		if (item?.isCustom ?? false) {
//			listContentView.addSubview(calendarView)
//
//			calendarView.topAnchor.constraint(equalTo: listContentView.topAnchor).isActive = true
//			calendarView.bottomAnchor.constraint(equalTo: listContentView.bottomAnchor).isActive = true
//			calendarView.leadingAnchor.constraint(equalTo: listContentView.leadingAnchor).isActive = true
//			calendarView.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor).isActive = true
//		}
//	}
	
//	private func addSwitch(with item: AlarmItem?) {
//		guard let item = item else { return }
//
//		if let isAllDay = item.isAllDay {
//			self.toggle = UISwitch()
//			guard let toggle = self.toggle else { return }
//			toggle.addTarget(self, action: #selector(handleAllDay), for: .valueChanged)
//			toggle.isOn = isAllDay // to do update with data
//			let customAccessory = UICellAccessory.CustomViewConfiguration(
//			  customView: toggle,
//			  placement: .trailing(displayed: .always))
//			accessories = [.customView(configuration: customAccessory)]
//		}
//	}
	
	@objc func handleAllDay() {
		guard let toggle = self.toggle else { return }
		allDayClosure?(toggle.isOn)
	}
}
