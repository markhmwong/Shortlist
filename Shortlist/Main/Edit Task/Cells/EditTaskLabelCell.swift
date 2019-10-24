//
//  EditTaskLabelCell.swift
//  Shortlist
//
//  Created by Mark Wong on 25/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class EditTaskLabelCell: EditTaskCellBase {

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCellLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func setupCellLayout() {
		super.setupCellLayout()
		textLabel?.textAlignment = .center
	}
	
	func updateLabel(name: String) {
		textLabel?.attributedText = NSAttributedString(string: name, attributes: attributes)
	}
	
}
