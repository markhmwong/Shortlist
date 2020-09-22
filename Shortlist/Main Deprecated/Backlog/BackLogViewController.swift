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
// Uses the Big List entity despite the name

class BackLogViewController: UIViewController, CategoryInputViewProtocol {
	
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<BackLog>? = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<BackLog> = BackLog.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

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
		view.backgroundColor = Theme.GeneralView.background
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var viewModel: BackLogViewModel?
	
	var coordinator: BackLogCoordinator?
	
	private var persistentContainer: PersistentContainer?
	
	var bottomConstraint: NSLayoutConstraint?
	
	private lazy var inputContainer: SelectCategoryInputView = {
		let view = SelectCategoryInputView(delegate: self, persistentContainer: persistentContainer ?? nil)
		view.alpha = 0.0
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	init(persistentContainer: PersistentContainer?, coordinator: BackLogCoordinator, viewModel: BackLogViewModel) {
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
		view.backgroundColor = Theme.GeneralView.background
		navigationItem.title = "Backlog"
		
		keyboardNotifications()
		prepareNavigationItem()
		
		guard let _viewModel = viewModel else { return }
		
		_viewModel.registerTableViewCell(tableView)
		
		view.addSubview(tableView)
		tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		
		view.addSubview(inputContainer)
		inputContainer.anchorView(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		bottomConstraint = NSLayoutConstraint(item: inputContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(bottomConstraint!)

		fetchData()
	}
	
	func prepareNavigationItem() {
		navigationItem.leftBarButtonItem = UIBarButtonItem().backButton(target: self, action: #selector(handleDismiss))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(handleAddCategory))
		navigationController?.title = "List"
	}
	
	func fetchData() {		
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
//				self.tableView.reloadData()
			} catch (let err) {
				print("Unable to perform fetch \(err)")
			}
		}
	}
	
	func keyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	// consolidate adding code to this function so both the Add button in the navigation bar and add button on the input container (above the keyboard)  can use the same code
	func addCategory() {
		guard let persistentContainer = persistentContainer else { return }
		
		// check if existing category exists
		
		guard let category: String = inputContainer.getCategoryFromInputField() else { return }
		
		if (inputContainer.getCategoryFromInputField() != nil) {
			// add category
			if (!persistentContainer.categoryExistsInBackLog(category)) {
				persistentContainer.createCategoryInBackLog(category, context: persistentContainer.viewContext)
				persistentContainer.saveContext()
				inputContainer.reisgnInputText()
			} else {
				coordinator?.showAlertBox("Category already exists")
			}
		}
	}
	
	// Raises the keyboard. Adding a category is the job of the addCateogry function.
	@objc
	func handleAddCategory() {
		inputContainer.focusField()
	}
	
	@objc
	func handleDismiss() {
		inputContainer.shutDownTimer()
		coordinator?.dismiss()
	}
	
	@objc
	func handleKeyboardNotification(_ notification : Notification?) {
		if let info = notification?.userInfo {
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				
				if (isKeyboardShowing) {
					inputContainer.alpha = 1.0
					bottomConstraint?.constant = -kbFrame.height
				} else {
					inputContainer.alpha = 0.0
					bottomConstraint?.constant = 0.0
				}
				
				UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
					self.view.layoutIfNeeded()
				}) { (completed) in
					
				}
			}
		}
	}
	
	deinit {
		coordinator?.cleanUpChildCoordinator()
	}
}

extension BackLogViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let objects = fetchedResultsController?.fetchedObjects else {
			tableView.separatorStyle = .none
			tableView.setEmptyMessage("Add a new category")
			return 0
		}
		
		tableView.restoreBackgroundView()
		return objects.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "BackLogCellId", for: indexPath)
			return cell
		}
		
		guard let objects: [BackLog] = fetchedResultsController?.fetchedObjects else {
			return viewModel.tableViewErrorCell(tableView, indexPath: indexPath)
		}
		return viewModel.tableViewCell(tableView, indexPath: indexPath, data: objects[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard let objects = fetchedResultsController?.fetchedObjects else {
			tableView.separatorStyle = .none
			tableView.setEmptyMessage("Add a new category")
			return
		}

		let category = objects[indexPath.row]
		
		guard let coordinator = coordinator else { return }
		coordinator.showCategoryTasks(persistentContainer, name: category.name, parentViewController: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
			
			let cell = tableView.cellForRow(at: indexPath) as! BackLogCell
			
			guard let name = cell.name else {
				// to do - couldn't delete
				return
			}
			
			if let exists = self.persistentContainer?.categoryExistsInBackLog(name) {
				if (exists) {
					_ = self.persistentContainer?.deleteCategory(forName: name)
					self.persistentContainer?.saveContext()
				}
			}
            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

extension BackLogViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		do {
            try fetchedResultsController?.performFetch()
            DispatchQueue.main.async {
//                self.tableView.reloadData()
            }
        } catch (let err) {
            print("\(err)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
			//
    }
}
