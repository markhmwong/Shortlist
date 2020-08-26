//
//  MainViewModelWithCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class MainViewModelWithCollectionView: NSObject {
	
	// change to cache
	private var tempDataSource: [TaskItem] = []
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskSection, TaskItem>! = nil
	
	override init() {
		super.init()
		prepareDataSource()
	}
	
	// MARK: - Configure Datasource
	func configureDataSource(collectionView: BaseCollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<TaskSection, TaskItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		
		// BUG: using this apply method refreshes the collectionview twice. however using the method with the animating differences won't allow for dynamic heights
		diffableDataSource.apply(configureSnapshot())
//		diffableDataSource.apply(configureSnapshot(), animatingDifferences: false) {
			//
//		}
	}
	
	// MARK: - Register
	private func configureCellRegistration() -> UICollectionView.CellRegistration<TaskCollectionViewCell, TaskItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskCollectionViewCell, TaskItem> { (cell, indexPath, item) in
			// configure cell
			cell.configureCell(with: item)

			// item 2, 3, 4, buttons for completing task, photo, category, delete

			// slide left to complete

			// slide right to delete
		}
		return cellConfig
	}
	
	// MARK: - Snapshot
	private func configureSnapshot() -> NSDiffableDataSourceSnapshot<TaskSection, TaskItem> {
		var snapshot = NSDiffableDataSourceSnapshot<TaskSection, TaskItem>()
		snapshot.appendSections([.high, .medium, .low])
		for (_, item) in tempDataSource.enumerated() {
			snapshot.appendItems([item], toSection: TaskSection.init(rawValue: Int(item.priority.rawValue)))
		}
		return snapshot
	}
	
	// MARK: - Layout
	func createCollectionViewLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			let estimatedHeight: CGFloat = 50.0

			let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

			let item = NSCollectionLayoutItem(layoutSize: size)
			item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
			
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
			group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

			return NSCollectionLayoutSection(group: group)
		}
		return layout
	}
	
	func itemForSelection(indexPath: IndexPath) -> TaskItem {
		guard let item = diffableDataSource.itemIdentifier(for: indexPath) else {
			return TaskItem(title: "Unknown", notes: "Unknown", priority: .high, completionStatus: true, reminder: "Reminder", redacted: .disclose)
		}
		return item
	}
	
	// MARK: - Prepare data source
	private func prepareDataSource() {
		tempDataSource = [
			TaskItem(title: "First Task. Fire Merlin Engine at full capacity. Stress test #1", notes: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum fdsfds dfs fds f.", priority: .high, completionStatus: true, reminder: "Reminder", redacted: .censor),
			TaskItem(title: "Second Task. A longer title to test the dynamic height of the Task Collection View Cell. Second Task. A longer title to test the dynamic height of the Task Collection View Cell. ", notes: "Note two", priority: .medium, completionStatus: false, reminder: "Reminder", redacted: .disclose),
			TaskItem(title: "Third Task", notes: "Note three", priority: .high, completionStatus: false, reminder: "Reminder", redacted: .disclose),
			TaskItem(title: "Fourth Task", notes: "Note four", priority: .low, completionStatus: true, reminder: "Reminder", redacted: .disclose),
		]
	}
}
