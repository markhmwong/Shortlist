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
	
	var task: Task
	
	var persistentContainer: PersistentContainer
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskOptionsPrioritySection, TaskOptionsPriorityItem>! = nil
	
	init(task: Task, persistentContainer: PersistentContainer) {
		self.task = task
		self.persistentContainer = persistentContainer
		super.init()
	}
	
	// MARK: - Diffable Datasource
	func configureSnapshot() {
		guard let diffableDataSource = diffableDataSource else { return }
		
		var snapshot = NSDiffableDataSourceSnapshot<TaskOptionsPrioritySection, TaskOptionsPriorityItem>()
		snapshot.appendSections(TaskOptionsPrioritySection.allCases)
        
		let data = prepareDataSource()
		
		for d in data {
			snapshot.appendItems([d], toSection: .main)
		}

		diffableDataSource.apply(snapshot, animatingDifferences: false) { }
	}
    
    // MARK: - Register Cell
    private func configureCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, TaskOptionsPriorityItem> {
        let cellConfig = UICollectionView.CellRegistration<UICollectionViewListCell, TaskOptionsPriorityItem> { (cell, indexPath, item) in
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            content.text = item.priority.stringValue
            content.textProperties.font = ThemeV2.CellProperties.PrimaryFont
            cell.contentConfiguration = content
            
            if item.isSelected {
                cell.accessories = [.checkmark()]
            } else {
                cell.accessories = []
            }
            
        }
        return cellConfig
    }
    
	func configureDataSource(collectionView: UICollectionView, resultsController: MainFetcher<Task>) {
        let cellRegistration = self.configureCellRegistration()
		// Setup datasource and cells
		diffableDataSource = UICollectionViewDiffableDataSource<TaskOptionsPrioritySection, TaskOptionsPriorityItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
			return cell
		}
		
		configureSnapshot()
	}
	
	private func prepareDataSource() -> [TaskOptionsPriorityItem] {
        if let p = Priority(rawValue: task.priority) {

            let highItem = TaskOptionsPriorityItem(name: "1", caption: "Get it done today. This may be your last day.", priority: .high, isSelected: p == .high)
            let medItem = TaskOptionsPriorityItem(name: "2", caption: "Keep on top of it, do some every day.", priority: .medium, isSelected: p == .medium)
            let lowItem = TaskOptionsPriorityItem(name: "3", caption: "Could be left for another day, meh", priority: .low, isSelected: p == .low)
            return [highItem, medItem, lowItem]
        }
        return []
	}
	
    func savePriority(_ item: Int16) {
        self.task.priority = item
        let updateDate = Date()
        self.task.updateAt = updateDate
        self.task.taskToDay?.updatedAt = updateDate as NSDate
        self.persistentContainer.saveContext()
    }
}

