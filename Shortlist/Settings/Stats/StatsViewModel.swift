//
//  StatsViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 17/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class StatsViewModel {
	
	var completeSorted: [StatsCategoryComplete] = []
	
	var incompleteSorted: [StatsCategoryIncomplete] = []
	
	init() {}
	
	func completeCategoryList(persistentContainer: PersistentContainer) {
		if let stat = persistentContainer.fetchStatEntity() {
			let completeCategories = stat.statsToComplete?.filtered(using: NSPredicate(format: "completeCount >= %i", 0)) as! Set<StatsCategoryComplete>
			// sort by completed tasks
			let sortedComplete = completeCategories.sorted(by: { (categoryA, categoryB) -> Bool in
				return categoryA.completeCount > categoryB.completeCount
			})
			
			//grab the top 3
			for (index, category) in sortedComplete.enumerated() {
				if (index <= 2) {
					completeSorted.append(category)
				}
			}
		}
	}
	
	func incompleteCategoryList(persistentContainer: PersistentContainer) {
		if let stat = persistentContainer.fetchStatEntity() {
			let completeCategories = stat.statsToIncomplete?.filtered(using: NSPredicate(format: "incompleteCount > %i", 0)) as! Set<StatsCategoryIncomplete>
			// sort by completed tasks
			let sortedComplete = completeCategories.sorted(by: { (categoryA, categoryB) -> Bool in
				return categoryA.incompleteCount > categoryB.incompleteCount
			})
			
			//grab the top 3
			for (index, category) in sortedComplete.enumerated() {
				if (index <= 2) {
					incompleteSorted.append(category)
				}
			}
		}
	}
}
