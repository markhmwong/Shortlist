//
//  PriorityLimitViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 3/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

// MARK: - View Controller
class PriorityLimitViewController: UIViewController, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
	
    // Core Data
    private lazy var fetchedResultsController: NSFetchedResultsController<Day> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [Calendar.current.today()])
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
	private var item: SettingsListItem
	
	private var viewModel: PriorityLimitViewModel
	
    private var mainFetcher: MainFetcher<Day>! = nil

	private lazy var collectionView: BaseCollectionView = {
		let view = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: false))
		view.delegate = self
		return view
	}()
	
	init(item: SettingsListItem, viewModel: PriorityLimitViewModel) {
		self.viewModel = viewModel
		self.item = item
		super.init(nibName: nil, bundle: nil)
		self.collectionView.allowsMultipleSelection = false
        self.mainFetcher = MainFetcher(controller: fetchedResultsController)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		collectionView.backgroundColor = ThemeV2.Background
        mainFetcher.initFetchedObjects()
		view.addSubview(collectionView)
		
		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewModel.configureDiffableDataSource(collectionView: collectionView, resultsController: mainFetcher)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		viewModel.updatePriorityLimit(indexPath: indexPath)
	}
}

extension PriorityLimitViewController {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        viewModel.updateSnapshot()
    }
}
