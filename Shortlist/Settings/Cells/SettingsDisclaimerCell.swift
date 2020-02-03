//
//  SettingsDisclaimerCell.swift
//  Shortlist
//
//  Created by Mark Wong on 13/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class SettingsDisclaimerCell: CellBase {

	lazy var disclaimerLabel: UILabel = {
		let label = UILabel()
		label.backgroundColor = .clear
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
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
		
		addSubview(disclaimerLabel)
		disclaimerLabel.fillSuperView()
	}
}

