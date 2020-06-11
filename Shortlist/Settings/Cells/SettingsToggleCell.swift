//
//  SettingsToggleCell.swift
//  Shortlist
//
//  Created by Mark Wong on 16/11/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SettingsToggleCell: CellBase, SettingsStandardCellProtocol {
	
	var showWarning: (() -> ())? = nil
	
	var toggleFunction: ((UISwitch) -> ())? = nil
	
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
		backgroundColor = Theme.GeneralView.background
		tintColor = Theme.Font.DefaultColor
		accessoryView = toggle
	}

	
	@objc func handleToggle() {
		toggleFunction?(toggle)
	}
	
	func updateToggle(_ state: Bool) {
		toggle.isOn = state
	}
	
	func updateName(_ name: String) {
		textLabel?.text = name
	}
	
	func updateIcon(_ iconName: String) {
		imageView?.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
		imageView?.tintColor = Theme.Cell.iconColor
	}
}

