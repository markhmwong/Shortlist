//
//  RedactStyleViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 28/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class RedactStyleViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

	// Core Data
	private lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
		// Create Fetch Request
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

		// Configure Fetch Request
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [viewModel.data.createdAt ?? Date()])

		// Create Fetched Results Controller
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

		// Configure Fetched Results Controller
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	private var viewModel: RedactStyleViewModel
	
	private var mainFetcher: MainFetcher<Task>! = nil
	
	init(viewModel: RedactStyleViewModel) {
		self.viewModel = viewModel
		super.init(collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: true, header: false, headerElementKind: "", footer: false, footerElementKind: ""))
		self.mainFetcher = MainFetcher(controller: fetchedResultsController)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.offWhite
		navigationItem.title = "Redact Style"
		mainFetcher.initFetchedObjects()
		viewModel.configureDataSource(collectionView: self.collectionView, resultsController: mainFetcher)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel.setStyle(style: Int16(indexPath.row))
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		viewModel.updateSnapshot()
	}
}

// MARK: - Meta Table Data
enum RedactStyleSection: CaseIterable {
	case main
}

struct RedactStyleItem: Hashable {
	var id: UUID = UUID()
	var name: String
	var style: RedactStyle
	var enabled: Bool
}

class RedactStyleViewModel: NSObject {
	
	private var dataSource: [RedactStyleItem] = []
	
	private var snapshot: NSDiffableDataSourceSnapshot<RedactStyleSection, RedactStyleItem>! = nil
	
	var diffableDataSource: UICollectionViewDiffableDataSource<RedactStyleSection, RedactStyleItem>! = nil
	
	var data: Task
	
	var persistentContainer: PersistentContainer
	
	private var mainFetcher: MainFetcher<Task>! = nil
	
	init(data: Task, persistentContainer: PersistentContainer) {
		self.data = data
		self.persistentContainer = persistentContainer
		super.init()
	}
	
	func setStyle(style: Int16) {
		data.redactStyle = style
		persistentContainer.saveContext()
	}
	
	// inject data - TO DO
	func prepareDataSource() -> [RedactStyleItem] {
		dataSource.removeAll()
		for (index, style) in RedactStyle.allCases.enumerated() {
			var state: Bool = false
			if (index == Int(data.redactStyle)) {
				state = true
			}
			
			dataSource.append(RedactStyleItem(name: style.stringValue, style: style, enabled: state))
		}
		return dataSource
	}
	
	// MARK: ConfigureDataSource
	func configureDataSource(collectionView: UICollectionView, resultsController: MainFetcher<Task>) {
		mainFetcher = resultsController
		
		diffableDataSource = UICollectionViewDiffableDataSource<RedactStyleSection, RedactStyleItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		updateSnapshot()
	}
	
	// MARK: ConfigureSnapshot
	func updateSnapshot()  {
		self.snapshot = NSDiffableDataSourceSnapshot<RedactStyleSection, RedactStyleItem>()
		snapshot.appendSections(RedactStyleSection.allCases)
		snapshot.appendItems(prepareDataSource())
		if let d = diffableDataSource {
			d.apply(snapshot, animatingDifferences: false, completion: nil)
		}
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, RedactStyleItem> {
		let cellConfig = UICollectionView.CellRegistration<UICollectionViewListCell, RedactStyleItem> { (cell, indexPath, item) in

			// configure cell
			var content: UIListContentConfiguration = cell.defaultContentConfiguration()
			content.text = item.name
			cell.contentConfiguration = content
			if item.enabled {
				cell.accessories = [.checkmark()]
			}
			
		}
		return cellConfig
	}
}
