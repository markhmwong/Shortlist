//
//  ReviewCollectionViewListModel.swift
//  Shortlist
//
//  Created by Mark Wong on 17/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class ReviewCollectionListViewModel: NSObject {
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskSection, Task>! = nil
	
	// configure diffable data source
	func configureDiffableDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<TaskSection, Task>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		//Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<SupplementaryViewHeader>(elementKind: ReviewCollectionListViewController.headerElementKind) {
			(supplementaryView, string, indexPath) in
			
			if indexPath.section == 0 {
				supplementaryView.updateTitleLabel(with: "Brief")
				supplementaryView.updateBriefLabel(with: "Yesterday's Tasks")
			} else {
				supplementaryView.updateTitleLabel(with: "")
				supplementaryView.updateBriefLabel(with: "")
			}
			
			
			supplementaryView.backgroundColor = .clear
		}
		
		diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
			return collectionView.dequeueConfiguredReusableSupplementary(
					using:headerRegistration, for: index)
		}
		
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(configureSnapshot())
	}
	
	// configure cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<MainTaskCell, Task> {
		let cellConfig = UICollectionView.CellRegistration<MainTaskCell, Task> { (cell, indexPath, item) in
			// configure cell
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// configure diffable datasource snapshot
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<TaskSection, Task> {
		var snapshot = NSDiffableDataSourceSnapshot<TaskSection, Task>()
		snapshot.appendSections(TaskSection.allCases)
		_ = prepareDataSource()
		
		print("to fix with nsfetchedresultscontroller (mainFetcher)")
//		for item in dataSource {
//			snapshot.appendItems([item], toSection: TaskSection.init(rawValue: Int(item.priority.rawValue)))
//		}
		
		return snapshot
	}
	
	func prepareDataSource() -> [TaskItem] {
		// map task to TaskItem
		return [TaskItem(title: "First Task. Fire Merlin Engine at full capacity. Stress test #1", notes: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially 상쾌한. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum fdsfds dfs fds f.", priority: .high, completionStatus: true, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.none)),
			TaskItem(title: "Second Task", notes: "Second task's notes", priority: .medium, completionStatus: true, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.none)),
			TaskItem(title: "Second Task", notes: "Second task's notes", priority: .medium, completionStatus: true, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.none)),
			TaskItem(title: "Second Task", notes: "Second task's notes", priority: .low, completionStatus: true, reminder: "Reminder", redaction: RedactComponent(redactStyle: RedactStyle.none)),
		]
	}
	

}
