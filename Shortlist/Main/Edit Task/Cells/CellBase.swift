//
//  EditTaskCellBase.swift
//  Shortlist
//
//  Created by Mark Wong on 25/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

protocol CellBaseProtocol {
	func setupCellLayout()
}

class CellBase: UITableViewCell, CellBaseProtocol {
	
	
	let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!]
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure() {
		
	}
	
	func setupCellLayout() {
		let backgroundView = UIView()
		backgroundView.backgroundColor = .clear
		selectedBackgroundView = backgroundView
	}
}
