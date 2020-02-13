//
//  CategoryCell.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol CellProtocol {
	func setupCellLayout()
}

class BackLogCell: UITableViewCell, CellProtocol {
	
	var name: String? = "Unknown"
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setupCellLayout() {
		backgroundColor = .clear
		textLabel?.textColor = UIColor.white
		layer.cornerRadius = 10.0
	}
}
