//  CategorySelectionViewModel.swift
//  Shortlist
//
//  Created by Assistant on 6/7/2025.
//

import UIKit

public class CategorySelectionViewModel {

	public static let categoryCellIdentifier = "CategoryCell"

	public enum Section: Int {
		case main
	}

	public let task : SLTask

	public let cds: CoreDataStack

	public var items: [CategoryItem] = []

	public var dataSource: UITableViewDiffableDataSource<Section, CategoryItem>!

	public struct CategoryItem: Hashable {
		public let id: UUID = UUID()
		public var rawCategory: AssetManager.Category.RawValue
		public var isSelected: Bool = false

		public init(category: AssetManager.Category, isSelected: Bool = false) {
			self.rawCategory = category.rawValue
			self.isSelected = isSelected
		}
	}

	public init(task: SLTask, cds: CoreDataStack) {
		// Use all cases of CategoryAssets
		self.task = task
		self.cds = cds
	}

	public func createCategoryItems() {
		for category in AssetManager.Category.allCases {
			var item = CategoryItem(category: category)
			item.isSelected = category.rawValue == task.taskToCategory?.type ? true : false
			items.append(item)
		}
	}

	public func setupDataSource(tableView: UITableView) {
		dataSource = UITableViewDiffableDataSource<Section, CategoryItem>(tableView: tableView) { [weak self] tableView, indexPath, item in
			guard let self = self else { return nil }
			let cell = tableView.dequeueReusableCell(
				withIdentifier: CategorySelectionViewModel.categoryCellIdentifier,
				for: indexPath
			)

			cell.textLabel?.text = AssetManager.Category(rawValue: item.rawCategory)?.name.capitalized
			cell.imageView?.image = UIImage(systemName: AssetManager.Category(rawValue: item.rawCategory)?.symbol ?? "questionmark")

			// Checkmark reflects current selection stored on the task
			let selectedType = self.task.taskToCategory?.type
			cell.accessoryType = (selectedType == item.rawCategory) ? .checkmark : .none

			return cell
		}
		dataSource.defaultRowAnimation = .fade
	}

	public func applySnapshot(animating: Bool = false) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, CategoryItem>()
		snapshot.appendSections([.main])
		snapshot.appendItems(items, toSection: .main)
		dataSource.apply(snapshot, animatingDifferences: animating)
	}
}
