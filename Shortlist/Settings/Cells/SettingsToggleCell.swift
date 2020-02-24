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
	
//	lazy var nameLabel: UILabel = {
//		let label = UILabel()
//		label.textColor = Theme.Font.DefaultColor
//		label.translatesAutoresizingMaskIntoConstraints = false
//		return label
//	}()
//
//	lazy var iconImage: UIImageView = {
//		let image = UIImageView(frame: .zero)
//		image.translatesAutoresizingMaskIntoConstraints = false
//		return image
//	}()
	
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
		contentView.addSubview(toggle)
		toggle.anchorView(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: nil, trailing: contentView.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -20.0), size: .zero)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageView?.bounds = CGRect(x: 0.0, y: 0.0, width: bounds.height * 0.6, height: bounds.height * 0.6)

	}
	
	override func layoutIfNeeded() {
		super.layoutIfNeeded()
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
		imageView?.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
	}
}

