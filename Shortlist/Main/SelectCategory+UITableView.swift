//
//  SelectCategory+UITableView.swift
//  Shortlist
//
//  Created by Mark Wong on 24/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let categories = fetchedResultsController?.fetchedObjects else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Add a new category by selecting the top right button!")
			return 0
		}
		tableView.restoreBackgroundView()
		
		
		return categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryCellId", for: indexPath)
			cell.textLabel?.text = "No Categories"
			cell.backgroundColor = UIColor.red
			cell.textLabel?.textColor = UIColor.white
			return cell
		}
		
		guard let results = fetchedResultsController?.fetchedObjects else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryCellId", for: indexPath)
			cell.textLabel?.text = "No Categories"
			cell.backgroundColor = UIColor.red
			cell.textLabel?.textColor = UIColor.white
			return cell
		}
		
		
		
		return viewModel.tableViewCell(tableView, indexPath: indexPath, category: results[indexPath.row].name ?? "Unknown")
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let cell = tableView.cellForRow(at: indexPath)
		guard let mvc = delegate else { return }
		guard let vm = mvc.viewModel else { return }
		vm.category = cell?.textLabel?.text
		coordinator?.dimiss(nil)
	}
}
