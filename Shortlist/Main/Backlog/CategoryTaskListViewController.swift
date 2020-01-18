//
//  File.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class BackLogTaskListViewController: UIViewController, NSFetchedResultsControllerDelegate {
	
	weak var persistentContainer: PersistentContainer?
	
	var viewModel: BackLogTaskListViewModel?
	
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<BackLog>? = {
		// Create Fetch Request
        let fetchRequest: NSFetchRequest<BackLog> = BackLog.fetchRequest()
		
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
		guard let vm = viewModel else {
			fetchRequest.predicate = NSPredicate(format: "name == %@", argumentArray: ["Uncategorized"])
			// Create Fetched Results Controller
			let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.persistentContainer?.viewContext ?? nil)!, sectionNameKeyPath: nil, cacheName: nil)
			
			// Configure Fetched Results Controller
			fetchedResultsController.delegate = self
			return fetchedResultsController
		}
		
		fetchRequest.predicate = NSPredicate(format: "name == %@", argumentArray: [vm.categoryName])

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.persistentContainer?.viewContext ?? nil)!, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.delegate = self
		view.dataSource = self
		view.backgroundColor = UIColor.black
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(persistentContainer: PersistentContainer, viewModel: BackLogTaskListViewModel) {
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.black
		navigationItem.title = "Tasks"
		navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleClose), imageName: "Back", height: self.topBarHeight / 1.8)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(createTestTask))

		guard let vm = viewModel else { return }
		vm.registerTableViewCell(tableView)
		
		view.addSubview(tableView)
		tableView.fillSuperView()
		
		fetchData()
		
//		createTestTask()
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
	
	// create test task
	@objc
	func createTestTask() {
		guard let categoryObject: BackLog = fetchedResultsController?.fetchedObjects?.first else {
			return
		}
		
		let task = BigListTask(context: persistentContainer!.viewContext)
		task.carryOver = false
		task.category = "CategoryA"
		task.complete = false
		task.details = "None"
		task.id = 0
		task.isNew = false
		task.name = "Test Category"
		task.priority = 0
		task.reminder = nil
		task.reminderState = false
		categoryObject.addToBackLogToBigListTask(task)
		
	}
	@objc
	func handleClose() {
		self.dismiss(animated: true, completion: nil)
	}
}

extension BackLogTaskListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let categoryObject: BackLog = fetchedResultsController?.fetchedObjects?.first else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Zero backlogged tasks!")
			return 0
		}
		guard let tasks = categoryObject.backLogToBigListTask else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Zero backlogged tasks!")
			return 0
		}
		
		tableView.restoreBackgroundView()
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let vm = viewModel else {
			return UITableViewCell()
		}
		
		
		
		guard let categoryObject: BackLog = fetchedResultsController?.fetchedObjects?.first else {
			return UITableViewCell()
		}
		
		guard let tasks = categoryObject.backLogToBigListTask else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Zero backlogged tasks!")
			return UITableViewCell()
		}
		
		let taskList = tasks as! Set<BigListTask>
		let sortedSet = taskList.sorted { (taskA, taskB) -> Bool in
			return taskA.name! > taskB.name!
		}
		
		return vm.tableViewCell(tableView, indexPath: indexPath, data: sortedSet[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// select task to add to today's schedule
	}
}
