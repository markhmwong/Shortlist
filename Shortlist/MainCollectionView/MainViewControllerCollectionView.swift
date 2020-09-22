//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData

protocol FetchedDataProtocol {
	associatedtype T: NSFetchRequestResult
	var controller: NSFetchedResultsController<T> { get }
}

struct MainFetcher<T: NSFetchRequestResult>: FetchedDataProtocol {
	var controller: NSFetchedResultsController<T>
	
	init(controller: NSFetchedResultsController<T>) {
		self.controller = controller
	}
	
	func initFetchedObjects() {
		do {
			try self.controller.performFetch()
		} catch(let err) {
			
		}
		
	}
	
	// Objects requested by the origina descriptors and predicates formed in the fetchedResultsController
	func fetchRequestedObjects() -> [T]? {
		return controller.fetchedObjects
	}
}

class MainViewControllerWithCollectionView: UIViewController {

	// Core Data
	private lazy var fetchedResultsController: NSFetchedResultsController<Day> = {
		// Create Fetch Request
		let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
		
		// Configure Fetch Request
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
		fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [Calendar.current.today()])
		
		// Create Fetched Results Controller
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		
		// Configure Fetched Results Controller
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	// Core Data
	private var mainFetcher: MainFetcher<Day>! = nil

	// public variables
	var coordinator: MainCoordinator?
	
	// private variables
	private var viewModel: MainViewModelWithCollectionView! = nil
	
	private var collectionView: BaseCollectionView! = nil
	
	private var persistentContainer: PersistentContainer
	
	init(viewModel: MainViewModelWithCollectionView, persistentContainer: PersistentContainer) {
		self.viewModel = viewModel
		self.persistentContainer = persistentContainer
		super.init(nibName: nil, bundle: nil)
		self.mainFetcher = MainFetcher(controller: fetchedResultsController)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.transparent()
		navigationItem.leftBarButtonItem = UIBarButtonItem().optionsButton(target: self, action: #selector(handleSettings))
		navigationItem.rightBarButtonItem = UIBarButtonItem().donateButton(target: self, action: #selector(handleDonation))
		// make collectionview
		createCollectionView()

		// prep data
//		viewModel.addMockData(persistentContainer: persistentContainer)
		mainFetcher.initFetchedObjects() // must be called first

		viewModel.configureDataSource(collectionView: collectionView, resultsController: mainFetcher)
//		coordinator?.showReview(nil, automated: false) // add persistent container
	}
	
	// collectionview
	func createCollectionView() {
		collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createCollectionViewLayout())
		collectionView.delegate = self
		view.addSubview(collectionView)
		// layout
		collectionView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
	}
	
	/*
	
		MARK: - Navigation Selectors
	
	*/
	@objc func handleDonation() {
		guard let c = coordinator else { return }
		c.showTipJar()
	}
	
	@objc func handleSettings() {
		guard let c = coordinator else { return }
		c.showSettings(persistentContainer)
	}
	
	func biometrics(item: Task) {
		let context = LAContext()
		var error: NSError?

		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Identify yourself!"

			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
				[weak self] success, authenticationError in
				guard let self = self else { return }
				DispatchQueue.main.async {
					if success {
						guard let coordinator = self.coordinator else { return }
						coordinator.showTaskDetails(with: item, persistentContainer: self.persistentContainer)
					} else {
						// error
						context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, authenticationError) in
							print("numpad")
						}
					}
				}
			}
		} else {
			// no biometrics
		}
	}
}

// MARK: - Collection View Methods
extension MainViewControllerWithCollectionView: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let item: Task = viewModel.itemForSelection(indexPath: indexPath)
		
		switch item.redactionStyle() {
			case .disclose:
				guard let coordinator = coordinator else { return }
				coordinator.showTaskDetails(with: item, persistentContainer: persistentContainer)
			case .star, .highlight:
				// run biometrics to request an unlock
				biometrics(item: item)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
			
			// from camera or camera roll
			let camera = UIAction(title: "Attach Photo", image: UIImage(systemName: "camera.fill"), identifier: UIAction.Identifier(rawValue: "camera")) {_ in
//				self.handleCamera()
			}
			
			let complete = UIAction(title: "Mark as Complete", image: UIImage(systemName: "checkmark.circle.fill"), identifier: UIAction.Identifier(rawValue: "complete")) {_ in
				print("complete")
			}
			
			let open = UIAction(title: "View Task", image: UIImage(systemName: "eye.fill"), identifier: UIAction.Identifier(rawValue: "open"), discoverabilityTitle: nil, attributes: [], state: .off, handler: {action in
				print("open")
			})
			
			let delete = UIAction(title: "Delete Task", image: UIImage(systemName: "minus.circle.fill"), identifier: UIAction.Identifier(rawValue: "delete"), discoverabilityTitle: nil, attributes: .destructive, state: .off, handler: {action in
				print("delete ")
			})

			return UIMenu(title: "Task Menu", image: nil, identifier: nil, children: [open, camera, complete, delete])
		}
		
		return config
	}
}

extension MainViewControllerWithCollectionView: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		print("did change content")
		// won't be structs, will need to change it to the NSManagedObjectID
//		var snapshot = snapshot as NSDiffableDataSourceSnapshot<TaskSection, Task>
//		if let day = self.mainFetcher.fetchRequestedObjects()?.first {
//			if let tasks = day.sortTasks() {
//				for task in tasks {
//					let section = TaskSection.init(rawValue: Int(task.priority))
//					snapshot.appendItems([task], toSection: section)
//				}
//			}
//		}
		
	}
}
