//
//  Cell.swift
//  Shortlist
//
//  Created by Mark Wong on 8/2/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class BackLogTaskListTableViewCell: UITableViewCell, CellProtocol {
	
	var task : Task?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupCellLayout() {
		backgroundColor = .clear
		textLabel?.textColor = Theme.Font.DefaultColor
		layer.cornerRadius = 10.0
	}
}
