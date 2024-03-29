//
//  SelectCategoryViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 23/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryInputViewProtocol: AnyObject {
	var bottomConstraint: NSLayoutConstraint? { get set }
	
	func addCategory()
	func keyboardNotifications()
}

class SelectCategoryViewController: UIViewController, CategoryInputViewProtocol {	
	
	// fetchedresultscontroller
    lazy var fetchedResultsController: NSFetchedResultsController<BackLog>? = {
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
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = Theme.GeneralView.background
		view.delegate = self
		view.dataSource = self
		view.estimatedRowHeight = 100.0
		view.rowHeight = UITableView.automaticDimension
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var inputContainer: SelectCategoryInputView = {
		let view = SelectCategoryInputView(type: .category, delegate: self, persistentContainer: persistentContainer ?? nil)
		view.alpha = 0.0
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	weak var coordinator: SelectCategoryCoordinator?
	
	var viewModel: SelectCategoryViewModel?
	
	weak var persistentContainer: PersistentContainer?
	
	var bottomConstraint: NSLayoutConstraint?
	
	var tableViewBottomConstraint: NSLayoutConstraint?
	
	var delegate: MainViewControllerProtocol
	
	
	init(_ persistentContainer: PersistentContainer?, coordinator: SelectCategoryCoordinator, viewModel: SelectCategoryViewModel, mainViewController: MainViewControllerProtocol) {
		self.delegate = mainViewController
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadCategories()
		guard let viewModel = viewModel else { return }
		keyboardNotifications()
		
		navigationItem.title = "Categories"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddCategory))
		navigationItem.leftBarButtonItem = UIBarButtonItem().backButton(target: self, action: #selector(handleDismiss))

		viewModel.tableViewRegisterCell(tableView)
		view.addSubview(tableView)
		view.addSubview(inputContainer)
		
		tableView.anchorView(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		tableViewBottomConstraint = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		
		
		view.addConstraint(tableViewBottomConstraint!)
		inputContainer.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		bottomConstraint = NSLayoutConstraint(item: inputContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(bottomConstraint!)
	}
	
	func loadCategories() {
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
				self.tableView.reloadData()
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
			}
		}
	}
	
	@objc
	func handleDismiss() {
		let category = "Uncategorized"
		guard let vm = delegate.viewModel else { return }
		vm.category = category
		inputContainer.updateField(category)
		coordinator?.dismissCurrentView()
	}
	
	@objc
	func handleAddCategory() {
		inputContainer.focusField()
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
					tableViewBottomConstraint?.constant = -kbFrame.height - inputContainer.bounds.height
				} else {
					inputContainer.alpha = 0.0
					bottomConstraint?.constant = 0.0
					tableViewBottomConstraint?.constant = 0.0
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
