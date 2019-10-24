//
//  MultlistViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 16/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Big List
// Backlog categories
//  - tasks

class MultiListViewController: UIViewController {
	
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<BigListCategories>? = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<BigListCategories> = BigListCategories.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [Calendar.current.today()])
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.persistentContainer?.viewContext ?? nil)!, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
	
	private lazy var tableView: UITableView = {
		let view = UITableView()
		view.delegate = self
		view.dataSource = self
		view.backgroundColor = .black
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var viewModel: MultiListViewModel?
	
	var coordinator: MultiListCoordinator?
	
	var persistentContainer: PersistentContainer?
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	init(persistentContainer: PersistentContainer?, coordinator: MultiListCoordinator, viewModel: MultiListViewModel) {
		super.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.coordinator = coordinator
		self.persistentContainer = persistentContainer
	}
	
	required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .black
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleDismiss))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(handleAddCategory))
		navigationController?.title = "List"
		viewModel?.registerTableViewCell(tableView)
		view.addSubview(tableView)
		tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		
		fetchData()
	}
	
	func fetchData() {		
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
				
				self.tableView.reloadData()
			} catch (let err) {
				print("Unable to perform fetch \(err)")
			}
		}
	}
	
	@objc
	func handleAddCategory() {
        guard let persistentContainer = persistentContainer else {
            fatalError("Error loading core data manager while loading data")
        }
		let context = persistentContainer.viewContext
		
		// check if category exists
		let exists = persistentContainer.categoryExists("Todo")

		if (!exists) {
			persistentContainer.createCategory("Todo", context: context)
			persistentContainer.saveContext()
			fetchData()
		} else {
			//show warning to do
			coordinator?.showAlertBox("Category already exists")
		}
	}
	
	@objc
	func handleDismiss() {
		coordinator?.dismiss()
	}
}

extension MultiListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let objects = fetchedResultsController?.fetchedObjects else { return 0 }
		return objects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "MultiListCellId", for: indexPath)
			return cell
		}
		
		guard let objects: [BigListCategories] = fetchedResultsController?.fetchedObjects else {
			return viewModel.tableViewErrorCell(tableView, indexPath: indexPath)
		}
		return viewModel.tableViewCell(tableView, indexPath: indexPath, data: objects[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let coordinator = coordinator else { return }
		coordinator.showCategoryTasks(persistentContainer)
	}
	
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
            
			let cell = tableView.cellForRow(at: indexPath) as! CategoryCell
			
			guard let name = cell.name else {
				//couldn't delete
				return
			}
			
			if let exists = self.persistentContainer?.categoryExists(name) {
				if (exists) {
					let deleteStatus = self.persistentContainer?.deleteCategory(forName: name)
					self.persistentContainer?.saveContext()
				}
			}
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension MultiListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		do {
            try fetchedResultsController?.performFetch()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch (let err) {
            print("\(err)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
			//
    }
}
