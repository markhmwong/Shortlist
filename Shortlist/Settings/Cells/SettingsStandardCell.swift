//
//  SettingsStandardCell.swift
//  Shortlist
//
//  Created by Mark Wong on 14/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsStandardCell: UITableViewCell, SettingsStandardCellProtocol {
	
	lazy var chevron: UIImageView? = {
		let image = UIImage(named: "ChevronRight.png")?.withRenderingMode(.alwaysTemplate)
		let chevron = UIImageView(frame: .zero)
		chevron.image = image
		return chevron
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupCellLayout() {
		guard let _chevron = chevron else { return }
		_chevron.frame = CGRect(x: 0, y: 0, width: frame.height * 0.5, height: frame.height * 0.5)
		accessoryView = _chevron
		tintColor = Theme.Cell.iconColor
		backgroundColor = .clear
		textLabel?.textColor = Theme.Font.DefaultColor
	}
	
	func updateIcon(_ iconName: String) {
		imageView?.image = UIImage(systemName: iconName)?.withRenderingMode(.alwaysTemplate)
		imageView?.tintColor = Theme.Cell.iconColor
	}
	
	func updateName(_ name: String) {
		textLabel?.text = name
	}
}
