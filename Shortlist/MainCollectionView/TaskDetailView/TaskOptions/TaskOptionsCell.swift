//
//  TaskOptionsCell.swift
//  Shortlist
//
//  Created by Mark Wong on 13/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

// MARK: - Extension
// These two extensions must be individually classified for each cell. You'll also find these extensions at WhatsNewCell and PermissionsCell
// Declare an extension on the cell state struct to provide a typed property for this custom state.
extension UICellConfigurationState {
	var taskOptionsItem: TaskOptionsItem? {
		set { self[.taskOptionsItem] = newValue }
		get { return self[.taskOptionsItem] as? TaskOptionsItem }
	}
}

fileprivate extension UIConfigurationStateCustomKey {
	static let taskOptionsItem = UIConfigurationStateCustomKey("com.whizbang.shortlist.cell.taskOptions")
}

// MARK: - Cell
class TaskOptionsCell: BaseListCell<TaskOptionsItem> {
	
	override var configurationState: UICellConfigurationState {
		var state = super.configurationState
		state.taskOptionsItem = self.item
		return state
	}
	
	private func defaultListContentConfiguration() -> UIListContentConfiguration {
		return .sidebarHeader()
	}
	
	private var viewConstraintCheck: NSLayoutConstraint? = nil
	
	private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
	
	private lazy var titleLabel: BaseLabel = {
		let label = BaseLabel()
		label.textAlignment = .center
		label.font = UIFont.preferredFont(forTextStyle: .headline).with(weight: .bold)
		return label
	}()
	
	private lazy var descriptionLabel: BaseLabel = {
		let label = BaseLabel()
		label.font = UIFont.preferredFont(forTextStyle: .caption1).with(weight: .regular)
		return label
	}()
	
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
		content.text = "\(state.taskOptionsItem?.title ?? "Unknown")"
		content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
		content.secondaryText = "\(state.taskOptionsItem?.description ?? "Unknown")" // add task options description
		content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption2)
		content.image = UIImage(systemName: state.taskOptionsItem?.image ?? "bandage.fill")

		guard let item = item else {
			listContentView.configuration = content
			return
		}
		
		if (item.delete != nil || item.delete == true) {
			accessories = []
			let bgView = UIView()
			bgView.backgroundColor = .clear
			backgroundView = bgView
			content.textProperties.color = UIColor.systemRed.adjust(by: -30)!
			content.imageProperties.tintColor = UIColor.systemRed.adjust(by: -30)!
			content.secondaryTextProperties.color = UIColor.systemRed.adjust(by: -30)!
            layer.cornerRadius = 8
            layer.borderWidth = 2
            layer.borderColor = UIColor.systemRed.adjust(by: -30)!.cgColor
		} else {
			accessories = [.disclosureIndicator()]
		}
		
        content.imageProperties.tintColor = item.type.color
		listContentView.configuration = content
        
    
	}
	
	// not required?
	private func addSwitch(with item: TaskOptionsItem?) {
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
		
		if let isRedacted = item.isRedacted {
			let enableAllDayAlarm = UISwitch()
			enableAllDayAlarm.addTarget(self, action: #selector(handleRedacted), for: .valueChanged)
			enableAllDayAlarm.isOn = isRedacted // to do update with data
			let customAccessory = UICellAccessory.CustomViewConfiguration(
			  customView: enableAllDayAlarm,
			  placement: .trailing(displayed: .always))
			accessories = [.customView(configuration: customAccessory)]
		}
	}
    
    
	
	@objc private func handleAllDay() {
		print("Handle all day")
	}
	
	@objc private func handleRedacted() {
		print("Handle all day")
	}
}
