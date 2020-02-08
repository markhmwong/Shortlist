//
//  File.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class BackLogTaskListViewController: UIViewController {
	
	private weak var persistentContainer: PersistentContainer?
	
	private weak var coordinator: CategoryTasksCoordinator?
	
	var viewModel: CategoryTaskListViewModel?
	
    private lazy var fetchedResultsController: NSFetchedResultsController<BackLog>? = {
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
		
		//relationship query needs fix for all predicates in app
		fetchRequest.predicate = NSPredicate(format: "name == %@", argumentArray: [vm.categoryName])

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
	
	init(persistentContainer: PersistentContainer, viewModel: CategoryTaskListViewModel, coordinator: CategoryTasksCoordinator) {
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.black
		navigationItem.title = "Tasks"
		navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleClose), imageName: "Back", height: self.topBarHeight / 1.8)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Copy", style: .plain, target: self, action: #selector(handleCopyTask))

		guard let _vm = viewModel else { return }
		_vm.registerTableViewCell(tableView)
		
		view.addSubview(tableView)
		tableView.fillSuperView()
		
		fetchData()
//		prepareData()

		
//		createTestTask()
	}
	
	func prepareData() {
		guard let _vm = viewModel else { return }
		guard let categoryObject: BackLog = fetchedResultsController?.fetchedObjects?.first else {
			return
		}
		guard let tasks = categoryObject.backLogToTask else {
			return
		}
		
		_vm.initaliseData(data: tasks as! Set<Task>)
		

	}
	
	func fetchData() {
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
				self.prepareData() // needs fix by updating the predicate query
				self.tableView.reloadData()
			} catch (let err) {
				print("Unable to perform fetch \(err)")
			}
		}
	}
	
	// testing purposes
	// create test task
	@objc
	func createTestTask() {
		guard let backLog: BackLog = fetchedResultsController?.fetchedObjects?.first else {
			return
		}
		
	}
	
	@objc
	func handleClose() {
		coordinator?.dismiss()
	}
	
	@objc func handleCopyTask() {
		copyMarkedTasks()
	}
	
	// marked tasks are placed inside the carryOverTaskObjectsArr
	func copyMarkedTasks() {
		guard let viewModel = viewModel else { return }
		guard let pc = persistentContainer else { return }
		let today: Day = pc.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		
		// create new day here, incase the app is running in the back ground and a new day hasn't been created in the interim
//		for (_, task) in viewModel.carryOverTaskObjectsArr {
//			let copiedTask = Task(context: pc.viewContext)
//			copiedTask.create(context: pc.viewContext, idNum: Int(task.id), taskName: task.name ?? "Error", categoryName: task.category, createdAt: task.createdAt! as Date, reminderDate: task.reminder! as Date, priority: Int(task.priority))
//			today.addToDayToTask(copiedTask)
//
//			let newReminderDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: task.reminder! as Date)!
//
//			//create notification
//			if (newReminderDate.timeIntervalSince(task.createdAt! as Date) > 0.0) {
//				LocalNotificationsService.shared.addReminderNotification(dateIdentifier: task.createdAt! as Date, notificationContent: [NotificationKeys.Title : task.name ?? ""], timeRemaining: newReminderDate.timeIntervalSince(Date()))
//			}
//		}
	}
}

extension BackLogTaskListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let categoryObject: BackLog = fetchedResultsController?.fetchedObjects?.first else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Zero backlogged tasks!")
			return 0
		}
		guard let tasks = categoryObject.backLogToTask else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Zero backlogged tasks!")
			return 0
		}
		
		tableView.restoreBackgroundView()
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let _vm = viewModel else {
			return UITableViewCell()
		}
		
		return _vm.tableViewCell(tableView, indexPath: indexPath)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// select task to add to today's schedule
		guard let _viewModel = viewModel else { return }
		let cell = _viewModel.tableCellAt(tableView: tableView, indexPath: indexPath)
		
	}
}

extension BackLogTaskListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		do {
            try fetchedResultsController?.performFetch()
			// organise dictionary here
			guard let _viewModel = viewModel else { return }
			guard let categoryObject = fetchedResultsController?.fetchedObjects?.first else {
				return
			}
			
			guard let tasks = categoryObject.backLogToTask else {
				return
			}

			_viewModel.initaliseData(data: tasks as! Set<Task>)
			
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch (let err) {
            print("\(err)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
}
