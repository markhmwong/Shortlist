//
//  SelectCategoryViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 23/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class SelectCategoryViewModel {
	
	let cellId = "SelectCategoryCellId"
	
	init() {
		
	}
	
	func tableViewRegisterCell(_ tableView: UITableView) {
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath, category: String) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		cell.backgroundColor = UIColor.clear
		cell.textLabel?.attributedText = NSAttributedString(string: "\(category)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b1).value)!])
		return cell
	}
	
}
