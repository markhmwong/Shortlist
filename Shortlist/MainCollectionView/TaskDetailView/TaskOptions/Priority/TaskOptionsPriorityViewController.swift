//
//  TaskOptionsPriorityViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 18/2/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class TaskOptionsPriorityViewController: BaseCollectionViewController, NSFetchedResultsControllerDelegate {
	
    // Core Data
    private lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [viewModel.task.createdAt ?? Date()])

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
	var viewModel: TaskOptionsPriorityViewModel
	
	private var coordinator: TaskOptionsCoordinator
	
    private var mainFetcher: MainFetcher<Task>! = nil

	init(coordinator: TaskOptionsCoordinator, viewModel: TaskOptionsPriorityViewModel) {
		self.viewModel = viewModel
		self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: false))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.mainFetcher = MainFetcher(controller: fetchedResultsController)

        mainFetcher.initFetchedObjects()
		viewModel.configureDataSource(collectionView: collectionView, resultsController: mainFetcher)
	}
	
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.savePriority(Int16(indexPath.item))
    }
}

extension TaskOptionsPriorityViewController {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        viewModel.configureSnapshot()
    }
}
