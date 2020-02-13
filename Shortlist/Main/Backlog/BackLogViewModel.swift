//
//  MultilistViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 16/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import UIKit

class BackLogViewModel {
	
	let cellId = "BackLogCellId"
		
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath, data: BackLog) -> BackLogCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! BackLogCell
		cell.textLabel?.text = data.name
		cell.name = data.name
		return cell
	}
	
	func registerTableViewCell(_ tableView: UITableView) {
		tableView.register(BackLogCell.self, forCellReuseIdentifier: cellId)
	}
	
	func tableViewErrorCell(_ tableView: UITableView, indexPath: IndexPath) -> BackLogCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! BackLogCell
		cell.textLabel?.text = "Unknown Cell"
		return cell
	}
}
