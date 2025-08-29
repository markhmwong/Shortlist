//
//  TextFieldTableViewCellDelegate.swift
//  Shortlist
//
//  Created by Mark Wong on 30/6/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//


// Custom UITableViewCell with a UITextField for editing text, suitable for the task name row
import UIKit

class SelectableTableViewCell: UITableViewCell {

	public static let identifier = "SelectableTableViewCell"

	func configure(viewModel: TaskDetailCellContentViewModel) {
		self.contentConfiguration = viewModel.contentConfiguration()
	}
}
