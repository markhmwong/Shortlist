//
//  SettingsToggleCell.swift
//  Shortlist
//
//  Created by Mark Wong on 16/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsToggleCell: CellBase, SettingsStandardCellProtocol {
	lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = Theme.Font.Color
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	lazy var iconImage: UIImageView = {
		let image = UIImageView(frame: .zero)
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	lazy var chevron: UIImageView? = nil
	
	lazy var toggle: UISwitch = {
		let toggle = UISwitch()
		toggle.isOn = false // get from keychain
		toggle.addTarget(self, action: #selector(handleToggle), for: .touchUpInside)
		toggle.translatesAutoresizingMaskIntoConstraints = false
		return toggle
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
		tintColor = UIColor.white
		addSubview(toggle)
		addSubview(nameLabel)
		addSubview(iconImage)
		
		toggle.anchorView(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -20.0), size: .zero)
		iconImage.anchorView(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: -10.0, right: -5.0), size: CGSize(width: bounds.height - 20.0, height: bounds.height - 20.0))
		nameLabel.anchorView(top: topAnchor, bottom: bottomAnchor, leading: iconImage.trailingAnchor, trailing: toggle.leadingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0), size: .zero)
	}
	
	
	@objc func handleToggle() {
		// also ask user if they want to turn on notifications
		// to do
		// remind every hour
		let hoursRemaining = Date().hoursRemaining()
		
		if (hoursRemaining < 2) {
			toggle.isOn = false
			// pop up warning to do
		} else {
			// don't trigger if hoursRemiaining is less than 2. 2 hours remaining in the day means it's close to 10pm rendering the feature redundant.
			if (toggle.isOn) {
				for hour in 0..<hoursRemaining {
					let id = 24 - (hoursRemaining - hour)
					let timeToNextHour = Date().timeRemainingToHour()
					let timeRemaining = timeToNextHour + Double(60 * hour)
					LocalNotificationsService.shared.addAllDayNotification(id: "\(id)", notificationContent: [NotificationKeys.Title : "Frequent Reminder"], timeRemaining: timeRemaining) // add content/body to notification
				}
			} else {
				// remove all notifications
				for hour in 0..<hoursRemaining {
					let id = 24 - (hoursRemaining - hour)
					LocalNotificationsService.shared.removeNotification(id: "\(id)")
				}
			}
		}
	}
	
	func updateName(_ name: String) {
		nameLabel.text = name
	}
	
	func updateIcon(_ iconName: String) {
		iconImage.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
	}
}

