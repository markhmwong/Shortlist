//
//  MultilistViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 16/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import UIKit

class MultiListViewModel {
	
	let cellId = "MultiListCellId"
	
	func tableViewCell(_ tableView: UITableView, indexPath: IndexPath, data: BigListCategories) -> CategoryCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! CategoryCell
		cell.textLabel?.text = data.name
		cell.name = data.name
		return cell
	}
	
	func registerTableViewCell(_ tableView: UITableView) {
		tableView.register(CategoryCell.self, forCellReuseIdentifier: cellId)
	}
	
	func tableViewErrorCell(_ tableView: UITableView, indexPath: IndexPath) -> CategoryCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! CategoryCell
		cell.textLabel?.text = "Unknown Cell"
		return cell
	}
}
