//
//  PreplanViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 22/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class PreplanViewController: UIViewController, MainViewControllerProtocol, PickerViewContainerProtocol {
	
    private lazy var fetchedResultsController: NSFetchedResultsController<Day>? = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
		fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [viewModel?.tomorrow ?? Calendar.current.forSpecifiedDay(value: 1)])
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.persistentContainer?.viewContext ?? nil)!, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
	
	private lazy var pickerViewContainer: PickerViewContainer = {
		let view = PickerViewContainer(delegateP: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var bottomConstraint: NSLayoutConstraint?
    
	var pickerViewBottomConstraint: NSLayoutConstraint?
	
	var viewModel: MainViewModel?
		
	weak var persistentContainer: PersistentContainer?
	
	weak var coordinator: PreplanCoordinator?
	
	private lazy var mainInputView: MainInputView = {
		let view = MainInputView(delegate: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = 0.0
		view.backgroundColor = Theme.Cell.textFieldBackground
		return view
	}()
	
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
		button.setAttributedTitle(NSAttributedString(string: "Add Task", attributes: [NSAttributedString.Key.font : UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor : Theme.Button.textColor]), for: .normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
	
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.dragDelegate = self
        view.dropDelegate = self
        view.dragInteractionEnabled = true
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.isEditing = false
        view.estimatedRowHeight = viewModel?.cellHeight ?? 100.0
        view.rowHeight = UITableView.automaticDimension
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
	
    lazy var taskListHeader: UIView = {
		let view = TaskListHeader(date: viewModel?.tomorrow ?? Calendar.current.forSpecifiedDay(value: 1))
        return view
    }()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
	}
	
	init(persistentContainer: PersistentContainer?, coordinator: PreplanCoordinator, viewModel: MainViewModel) {
		self.persistentContainer = persistentContainer
		self.coordinator = coordinator
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let _viewModel = viewModel else { return }
		view.backgroundColor = .black
		title = "Preplan"
        
		tableView.tableHeaderView = taskListHeader
        taskListHeader.setNeedsLayout()
        taskListHeader.layoutIfNeeded()
		_viewModel.registerCell(tableView)
		
		view.addSubview(tableView)
		view.addSubview(addButton)
		view.addSubview(mainInputView)
		
		tableView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
		mainInputView.anchorView(top:nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		bottomConstraint = NSLayoutConstraint(item: mainInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(bottomConstraint!)
		prepareTomorrowsDayInCoreData()
		keyboardNotifications()

	}
	
	func keyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func prepareTomorrowsDayInCoreData() {
		guard let _pc = persistentContainer else { return }
		guard let _viewModel = viewModel else { return }
		
		var dayObject: Day? = _pc.fetchDayManagedObject(forDate: viewModel?.tomorrow ?? Calendar.current.forSpecifiedDay(value: 1))
		if let _dayObject = dayObject {
			initialiseData(_dayObject)
		} else {
            dayObject = Day(context: _pc.viewContext)
			guard let day = dayObject else { return }
			day.createdAt = viewModel?.tomorrow as NSDate? ?? Calendar.current.forSpecifiedDay(value: 1) as NSDate
			
			// we'll use the same limit imposed on tomorrow's day object as today's day object
			if let highLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) {
				day.highPriorityLimit = Int16(highLimit)
			} else {
				day.highPriorityLimit = 0
			}
			
			if let mediumLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) {
				day.mediumPriorityLimit = Int16(mediumLimit)
			} else {
				day.mediumPriorityLimit = 0
			}
			
			if let lowLimit = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) {
				day.lowPriorityLimit = Int16(lowLimit)
			} else {
				day.lowPriorityLimit = 0
			}

            day.month = Calendar.current.monthToInt() // Stats
            day.year = Calendar.current.yearToInt() // Stats
            day.day = Int16(Calendar.current.todayToInt()) // Stats
			day.dayToTask = Set<Task>() as NSSet
			
			initialiseData(day)
		}
		_pc.saveContext()
		_viewModel.dayEntity = dayObject
		
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()

				if (_viewModel.dayEntity != nil) {
					self.tableView.reloadData()
				}
			} catch (let err) {
				print("Unable to perform fetch \(err)")
			}
		}
	}
	
	func initialiseData(_ dayObject: Day) {
		guard let _viewModel = viewModel else { return }
		_viewModel.sortedSet = _viewModel.sortTasks(dayObject)
	}
	
	func focusOnNewTask() {
		DispatchQueue.main.async {
			self.mainInputView.taskFirstResponder()
		}
	}
	
	@objc
	func handleAddButton() {
		guard let vm = viewModel else { return }
//		guard let day = vm.dayEntity else { return }
		vm.category = "Uncategorized"
		self.focusOnNewTask()
		
//		if (day.totalTasks < day.taskLimit) {
//			//        syncWatch()
//			self.focusOnNewTask()
//		} else {
//			// show alert todo
//			coordinator?.showAlertBox("Over the Limit")
//		}
	}
	
	func closeTimePicker() {
		guard let vm = viewModel else { return }
		pickerViewBottomConstraint?.constant = vm.keyboardSize.height
		UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
			self.view.layoutIfNeeded()
			self.focusOnNewTask()
		}) { (complete) in
			//
		}
	}
	
	func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	@objc
	func handleKeyboardNotification(_ notification : Notification?) {
		
		if let info = notification?.userInfo {
			
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			guard let vm = viewModel else { return }
			
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				vm.keyboardSize = kbFrame
				
				if (isKeyboardShowing) {
					mainInputView.alpha = 1.0
					bottomConstraint?.constant = -kbFrame.height
				} else {
					mainInputView.alpha = 0.0
					bottomConstraint?.constant = 0
				}
				
				UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
					self.view.layoutIfNeeded()
				}) { (completed) in
					
				}
			}
		}
	}
	
	func updateCategory() {
		guard let vm = viewModel else { return }
		DispatchQueue.main.async {
			self.mainInputView.categoryButton.setAttributedTitle(NSMutableAttributedString(string: "\(vm.category ?? "Uncategorized")", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		}
	}
	
	
	func postTask(taskName: String, category: String, priorityLevel: Int) {
		guard let persistentContainer = persistentContainer else {
		 fatalError("Error loading core data manager while loading data")
		}
		 
		guard let vm = viewModel else { return }
		guard let day = vm.dayEntity else { return }

		let totalTasks = vm.totalTasksForPriority(day, priorityLevel: priorityLevel)
		
		//move to view model
		if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) ?? totalTasks) {
			// warning
			coordinator?.showAlertBox("High Priority Limit Reached")
			return
		} else if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.MediumPriorityLimit) ?? totalTasks) {
			coordinator?.showAlertBox("Medium Priority Limit Reached")
		} else if (totalTasks >= KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.LowPriorityLimit) ?? totalTasks) {
			// warning
			coordinator?.showAlertBox("Low Priority Limit Reached")
		} else {
			let context: NSManagedObjectContext  = persistentContainer.viewContext
			let dayObject: Day = context.object(with: day.objectID) as! Day
			let createdAt: Date = Date()
			let reminderDate: Date = pickerViewContainer.getValues()
			
			dayObject.totalTasks += 1
			let task: Task = Task(context: context)
			task.create(context: context, idNum: Int(dayObject.totalTasks), taskName: taskName, categoryName: category, createdAt: createdAt, reminderDate: reminderDate, priority: priorityLevel)
			dayObject.addToDayToTask(task)
			
			// check if category exists
			if (persistentContainer.categoryExistsInBackLog(category)) {
				if let bigListCategory: BackLog = persistentContainer.fetchBigListCategory(forDate: category) {
					let bigListTask: BigListTask = BigListTask(context: persistentContainer.viewContext)
					bigListTask.create(context: context, idNum: Int(dayObject.totalTasks), taskName: taskName, categoryName: category, createdAt: createdAt, reminderDate: reminderDate)
					bigListCategory.addToBackLogToBigListTask(bigListTask)
				} else {
					//failed - pop up
				}
			} else {
				
				// create category
				let bigListCategory: BackLog = BackLog(context: persistentContainer.viewContext)
				bigListCategory.create(name: category)
				let bigListTask: BigListTask = BigListTask(context: persistentContainer.viewContext)
				bigListTask.create(context: context, idNum: Int(dayObject.totalTasks), taskName: taskName, categoryName: category, createdAt: createdAt, reminderDate: reminderDate)
				bigListCategory.addToBackLogToBigListTask(bigListTask)
				let categoryList: CategoryList = CategoryList(context: persistentContainer.viewContext)
				categoryList.create(name: category)
			}

			//create notification
			if (reminderDate.timeIntervalSince(createdAt) > 0.0) {
				LocalNotificationsService.shared.addReminderNotification(dateIdentifier: createdAt, notificationContent: [NotificationKeys.Title : taskName], timeRemaining: reminderDate.timeIntervalSince(createdAt))
			}
			
			// add to stats
			if let stats: Stats = persistentContainer.fetchStatEntity() {
				stats.addToTotalTasks(numTasks: 1)
				stats.addToTotalIncompleteTasks(numTasks: 1)
			}
			persistentContainer.saveContext()
		}

		

	}
	
	func showCategory() {
		coordinator?.showCategory(persistentContainer, mainViewController: self)
	}
	
	func showTimePicker() {
		mainInputView.taskResignFirstResponder()
		guard let vm = viewModel else { return }
		
		view.addSubview(pickerViewContainer)
		pickerViewContainer.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: vm.keyboardSize.height))
		pickerViewBottomConstraint = NSLayoutConstraint(item: pickerViewContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(pickerViewBottomConstraint!)
	}
}

extension PreplanViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		do {
            try fetchedResultsController?.performFetch()
			// organise dictionary here
			guard let _viewModel = viewModel else { return }
			guard let dayObject = fetchedResultsController?.fetchedObjects?.first else {
				return
			}

			let sortedSet = _viewModel.sortTasks(dayObject)
			_viewModel.sortedSet = sortedSet
//			print(sortedSet?.count)
			
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

extension PreplanViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
	//set up cells
	func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		return [UIDragItem(itemProvider: NSItemProvider())]
	}
	
	func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
		//
	}
	
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return previewParameters(forItemAt: indexPath, tableView: tableView)
    }
	
    private func previewParameters(forItemAt indexPath:IndexPath, tableView:UITableView) -> UIDragPreviewParameters?     {
        let previewParameters = UIDragPreviewParameters()
        previewParameters.backgroundColor = .black
        return previewParameters
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let dayObjects = fetchedResultsController?.fetchedObjects else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Start something great by tapping the 'Add' button below")
			return 0
		}
		
		if let day = dayObjects.first {
			if (day.dayToTask?.count == 0) {
				tableView.separatorColor = .clear
				tableView.setEmptyMessage("Start something great by tapping the 'Add' button below")
				return 0
			} else {
				tableView.restoreBackgroundView()
				return day.dayToTask?.count ?? 0
			}
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let _viewModel = viewModel else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskCell
			cell.textLabel?.text = "Unknown Task"
            return cell
        }
		let cell: TaskCell = _viewModel.tableViewCell(tableView, indexPath: indexPath, fetchedResultsController: fetchedResultsController, persistentContainer: persistentContainer)
        return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let persistentContainer = persistentContainer else { return }
		//place in viewmodel
		let dayManagedObject = self.persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
        let set = dayManagedObject.dayToTask as? Set<Task>
        let sortedSet = set?.sorted(by: { (taskA, taskB) -> Bool in
            return taskA.priority < taskB.priority
        })
		
		guard let task = sortedSet?[indexPath.row] else { return }
		guard let fetchedResultsController = fetchedResultsController else { return }
		coordinator?.showEditTask(persistentContainer, task: task, fetchedResultsController: fetchedResultsController, mainViewController: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}