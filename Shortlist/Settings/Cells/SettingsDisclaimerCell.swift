//
//  SettingsDisclaimerCell.swift
//  Shortlist
//
//  Created by Mark Wong on 13/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsDisclaimerCell: CellBase {
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		isUserInteractionEnabled = false
		backgroundColor = .clear
		
		textLabel?.textColor = Theme.Font.FadedColor
		textLabel?.numberOfLines = 0
		textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
		textLabel?.font = UIFont(name: Theme.Font.Bold, size: Theme.Font.StandardSizes.b3.rawValue)
	}
	
	func updateLabel(string: String) {
		textLabel?.text = string
	}
}

