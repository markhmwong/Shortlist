//
//  TaskOptionsPriorityViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 18/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

enum TaskOptionsPrioritySection: CaseIterable {
	case main
}

struct TaskOptionsPriorityItem: Hashable {
	var id: UUID = UUID()
	var name: String
	var caption: String
	var priority: Priority
	var isSelected: Bool
}

class TaskOptionsPriorityViewModel: NSObject {
	
	private var task: Task
	
	var persistentContainer: PersistentContainer
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskOptionsPrioritySection, TaskOptionsPriorityItem>! = nil
	
	init(task: Task, persistentContainer: PersistentContainer) {
		self.task = task
		self.persistentContainer = persistentContainer
		super.init()
	}
	
	// MARK: - Diffable Datasource
	private func configureSnapshot() {
		guard let diffableDataSource = diffableDataSource else { return }
		
		var snapshot = NSDiffableDataSourceSnapshot<TaskOptionsPrioritySection, TaskOptionsPriorityItem>()
		snapshot.appendSections(TaskOptionsPrioritySection.allCases)
		
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: .main)
		}

		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}
	
	func configureDataSource(collectionView: UICollectionView) {
		
		// Setup datasource and cells
		diffableDataSource = UICollectionViewDiffableDataSource<TaskOptionsPrioritySection, TaskOptionsPriorityItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		configureSnapshot()
	}
	
	private func prepareDataSource() -> [TaskOptionsPriorityItem] {
		let highItem = TaskOptionsPriorityItem(name: "1", caption: "Get it done today. This may be your last day.", priority: .high, isSelected: true)
		let medItem = TaskOptionsPriorityItem(name: "2", caption: "Keep on top of it, do some every day.", priority: .medium, isSelected: false)
		let lowItem = TaskOptionsPriorityItem(name: "3", caption: "Could be left for another day, meh", priority: .low, isSelected: false)
		return [highItem, medItem, lowItem]
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<TaskOptionsPriorityCell, TaskOptionsPriorityItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskOptionsPriorityCell, TaskOptionsPriorityItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
		}
		return cellConfig
	}
}

