//
//  ViewController.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData
import WatchConnectivity
import os

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    var viewModel: MainViewModel? = nil
    
    var persistentContainer: PersistentContainer?
  
	private lazy var mainInputView: MainInputView = {
		let view = MainInputView(delegate: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = 0.0
		view.backgroundColor = Theme.Cell.textFieldBackground
		return view
	}()
	
//	private lazy var textView: UITextView = {
//		let view = UITextView()
////        view.delegate = self
//        view.backgroundColor = .clear
//        view.keyboardType = UIKeyboardType.default
//        view.keyboardAppearance = UIKeyboardAppearance.dark
//        view.textColor = UIColor.white
//        view.returnKeyType = UIReturnKeyType.done
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.textContainerInset = UIEdgeInsets.zero
//        view.textContainer.lineFragmentPadding = 0
//		view.isEditable = true
//		view.isSelectable = true
//		view.isUserInteractionEnabled = true
//		view.isScrollEnabled = false
//		view.tag = 0
//		return view
//	}()
	
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Day>? = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [Calendar.current.today()])
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
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
        button.setTitle("Add", for: .normal)
		button.setTitleColor(Theme.Button.textColor, for: .normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var taskListHeader: UIView = {
        let view = TaskListHeader(date: Calendar.current.today())
        return view
    }()
	
	var bottomConstraint: NSLayoutConstraint?
    
    init(coreDataManager: CoreDataManager? = nil) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(persistentContainer: PersistentContainer? = nil, viewModel: MainViewModel) {
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
        WatchSessionHandler.shared.initPersistentContainer(with: persistentContainer!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let today: Int16 = Calendar.current.todayToInt()
		
		if let reviewDate = KeychainWrapper.standard.integer(forKey: KeyChainKeys.ReviewDate) {
			if today != Int16(reviewDate) {
				// update keychain
				KeychainWrapper.standard.set(Int(today), forKey: KeyChainKeys.ReviewDate)
				// show preview
				loadReview()
			}
		} else {
			// continues as normal
//			loadReview() //returning from this view needs to reload the tableview
			loadData()
			setupView()
			AppStoreReviewManager.requestReviewIfAppropriate()
		}
		keyboardNotifications()
//        deleteAllData()
//        initialiseSampleData()
//		deleteAllCategoryListData()

//		prepareDayObjectsInAdvance()
		
//        guard let dayArray = persistentContainer?.fetchAllTasksByWeek(forWeek: Calendar.current.startOfWeek(), today: Calendar.current.today()) else {
//            //no data to do
//            return
//        }
        // test watch
//        syncWatch()
    }
	
	func keyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
    private func initialiseSampleData() {
        guard let persistentContainer = persistentContainer else { return }
        let dayInSeconds: TimeInterval = 86400
        let taskLimitArr: [Int] = [5, 10, 15]
        
        for i in 0..<50 {
            let date = Calendar.current.today().addingTimeInterval(Double(i) * -dayInSeconds)
            var dayObject: Day? = persistentContainer.fetchDayEntity(forDate: date) as? Day
            
            if dayObject == nil {
                let count = taskLimitArr.count
                let limit = taskLimitArr[Int.random(in: 0..<count)]
                let range = 2..<limit
                let totalTasks = Int.random(in: range)
                let completedTasksRange = 1..<totalTasks
                let totalCompleted = Int.random(in: completedTasksRange)
                
                dayObject = Day(context: persistentContainer.viewContext)
                dayObject?.taskLimit = Int16(limit)
                dayObject?.createdAt = date as NSDate
                dayObject?.totalCompleted = Int16(totalCompleted)
                dayObject?.totalTasks = Int16(totalTasks)
                dayObject?.month = Calendar.current.monthToInt(date: date, adjust: -i)
                dayObject?.year = Calendar.current.yearToInt()
                dayObject?.day = Int16(Calendar.current.dayDate(date: date))
            }
        }
    }
    
    private func deleteAllData() {
        guard let persistentContainer = persistentContainer else { return }
        persistentContainer.deleteAllRecordsIn(entity: Day.self)
    }
	
	private func deleteAllCategoryListData() {
        guard let persistentContainer = persistentContainer else { return }
        persistentContainer.deleteAllRecordsIn(entity: BigListCategories.self)
	}
    
    // disabled
//    func syncWatch() {
//        let today = Calendar.current.today()
//        let taskList: [TaskStruct] = [
//            TaskStruct(id: 0, name: "Sample Task One", complete: false, priority: 0),
//            TaskStruct(id: 1, name: "Sample Task One", complete: false, priority: 1),
//            TaskStruct(id: 2, name: "Sample Task One", complete: false, priority: 2),
//        ]
//
//        do {
//            let encodedData = try JSONEncoder().encode(taskList)
////            let jsonString = String(data: encodedData, encoding: .utf8)
//            WatchSessionHandler.shared.updateApplicationContext(with: encodedData)
//        } catch (let err) {
//            print("Error encoding taskList \(err)")
//        }
//
//    }
	
    private func setupView() {
        guard let viewModel = viewModel else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List", style: .plain, target: self, action: #selector(handleBigList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
		
		viewModel.registerCell(tableView)

        tableView.tableHeaderView = taskListHeader
        taskListHeader.setNeedsLayout()
        taskListHeader.layoutIfNeeded()

		view.addSubview(tableView)
		view.addSubview(mainInputView)
		view.addSubview(addButton)
		
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
		mainInputView.anchorView(top:nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		bottomConstraint = NSLayoutConstraint(item: mainInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(bottomConstraint!)
    }
	
	// preps for statistics.
	private func fillMissingDayObjects() {
		
	}
    
    private func loadReview() {
        // no longer using coredataManager pass PersistentContainer object instead
//        guard let coreDataManager = coreDataManager else { return }
        
//        let vc = ReviewViewController(coreDataManager: coreDataManager)
//        self.present(vc, animated: true)
        coordinator?.showReview(persistentContainer, mainViewController: self)
    }
    
    func seedCoreDataWhenFirstLaunched() {
        // check with keychain
    }
    
    func loadData() {
        //load today's current data into dayEntity
        guard let persistentContainer = persistentContainer else { return }
        guard let viewModel = viewModel else { return }
        //check if there is data for today, if there isn't then create the day
        let todaysDate = Calendar.current.today()
        var dayObject: Day? = persistentContainer.fetchDayManagedObject(forDate: todaysDate)
        
        if (dayObject == nil) {
            dayObject = Day(context: persistentContainer.viewContext)
            dayObject?.createdAt = Calendar.current.today() as NSDate
            dayObject?.taskLimit = 5 //default limit
            dayObject?.month = Calendar.current.monthToInt() // Stats
            dayObject?.year = Calendar.current.yearToInt() // Stats
            dayObject?.day = Int16(Calendar.current.todayToInt()) // Stats
            // possible loading graphic todo            
            persistentContainer.saveContext()
        }

		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
				viewModel.dayEntity = dayObject
				if (viewModel.dayEntity != nil) {
					self.tableView.reloadData()
				}
			} catch (let err) {
				print("Unable to perform fetch \(err)")
			}
		}
    }
	
	func updateCategory() {
		guard let vm = viewModel else { return }
		DispatchQueue.main.async {
			self.mainInputView.categoryButton.setAttributedTitle(NSMutableAttributedString(string: "\(vm.category ?? "Uncategorized")", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		}
	}
	
	func focusOnNewTask() {
		DispatchQueue.main.async {
			self.mainInputView.taskFirstResponder()
		}
	}
    
    @objc
    func handleAddButton() {
        guard let persistentContainer = persistentContainer else {
            fatalError("Error loading core data manager while loading data")
        }
        guard let vm = viewModel else { return }
        guard let day = vm.dayEntity else { return }
        
        // bug on new day
        os_log("CurrTasks %d, Totaltasks %d", log: Log.task, type: .info, day.totalTasks, day.taskLimit)
		
        if (day.totalTasks < day.taskLimit) {
            //        syncWatch()
			self.focusOnNewTask()
        } else {
            // show alert todo
            coordinator?.showAlertBox("Over the Limit")
        }
    }
	
    @objc
    func handleSettings() {
        guard let coordinator = coordinator else { return }
        coordinator.showSettings(persistentContainer)
    }
    
    @objc
    func handleBigList() {
        guard let coordinator = coordinator else { return }
		coordinator.showBigList(persistentContainer)
    }
	
	@objc
	func handleKeyboardNotification(_ notification : Notification?) {
		
		if let info = notification?.userInfo {
			
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				
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
	
	func keyboardSize(_ notification : Notification?) -> CGSize {

        if let info = notification?.userInfo {

            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey

            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {

                let screenSize = UIScreen.main.bounds

                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached
                let intersectRect = kbFrame.intersection(screenSize)

                if intersectRect.isNull {
                    return CGSize(width: screenSize.size.width, height: 0)
                } else {
                    return intersectRect.size
                }
//                print("Your Keyboard Size \(_kbSize)")
            }
        }
		
		return CGSize.zero
	}
	
	// handle the saving of task from MainInputView
	func saveInput(task: String, category: String) {
        guard let persistentContainer = persistentContainer else {
            fatalError("Error loading core data manager while loading data")
        }
		guard let vm = viewModel else { return }
        guard let day = vm.dayEntity else { return }

		let context = persistentContainer.viewContext
		let dayObject = context.object(with: day.objectID) as! Day
		dayObject.totalTasks += 1
		persistentContainer.createTask(toEntity: dayObject, context: context, idNum: Int(dayObject.totalTasks), taskName: task, categoryName: category)
		persistentContainer.saveContext()
	}
	
	func showCategory() {
		coordinator?.showCategory(persistentContainer, mainViewController: self)
	}
	
	func postTask(task: String, category: String) {
		saveInput(task: task, category: category)
	}
}

extension MainViewController: NSFetchedResultsControllerDelegate {
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
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayObjects = fetchedResultsController?.fetchedObjects else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Start with a new task by selecting Add")
			return 0
		}
		tableView.restoreBackgroundView()
        let first = dayObjects.first
        return first?.dayToTask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskCell
			cell.textLabel?.text = "Unknown Task"
            return cell
        }
        
		let cell: TaskCell = viewModel.tableViewCell(tableView, indexPath: indexPath)

		// move to viewmodel later
		guard let dayObject = fetchedResultsController?.fetchedObjects?.first else {
			return cell
		}
		
		let sortedSet = viewModel.sortTasks(dayObject)
		if (indexPath.row == 0) {
			cell.backgroundColor = UIColor(red:0.29, green:0.08, blue:0.02, alpha:1.0)
		}
		cell.task = viewModel.taskForRow(sortedSet, indexPath: indexPath)
		cell.stateOfTextView()
		
        cell.adjustDailyTaskComplete = { (task) in
            if (task.complete) {
                dayObject.totalCompleted += 1
            } else {
                dayObject.totalCompleted -= 1
            }
            self.persistentContainer?.saveContext()
        }
        
        cell.updateWatch = { (task) in
            //WCSession
            let taskList = self.fetchedResultsController?.fetchedObjects?.first?.dayToTask as! Set<Task>
            var tempTaskStruct: [TaskStruct] = []
            for task in taskList {
                tempTaskStruct.append(TaskStruct(id: task.id, name: task.name!, complete: task.complete, priority: task.priority))
            }
            do {
                let data = try JSONEncoder().encode(tempTaskStruct)
                WatchSessionHandler.shared.updateApplicationContext(with: ReceiveApplicationContextKey.UpdateTaskListFromPhone.rawValue, data: data)
            } catch (let err) {
                print("\(err)")
            }
        }
		
        cell.persistentContainer = persistentContainer
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            let dayManagedObject = self.persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
            
            if let task = cell.task {
                let taskManagedObject = self.persistentContainer?.viewContext.object(with: task.objectID) as! Task
                dayManagedObject.removeFromDayToTask(taskManagedObject)
                dayManagedObject.totalTasks = dayManagedObject.totalTasks - 1
				if task.complete {
					dayManagedObject.totalCompleted = dayManagedObject.totalCompleted - 1
				}
                self.persistentContainer?.saveContext()
            }
            complete(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

		let dayManagedObject = self.persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
        let set = dayManagedObject.dayToTask as? Set<Task>
        let sortedSet = set?.sorted(by: { (taskA, taskB) -> Bool in
            return taskA.priority < taskB.priority
        })

        let sourceTask = sortedSet?[sourceIndexPath.row]
        let destTask = sortedSet?[destinationIndexPath.row]

        let tempDestinationPriority = destTask?.priority
        destTask?.priority = sourceTask!.priority
        sourceTask?.priority = tempDestinationPriority!
        persistentContainer?.saveContext()
		self.loadData()
    }
    
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		//place in viewmodel
		let dayManagedObject = self.persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
        let set = dayManagedObject.dayToTask as? Set<Task>
        let sortedSet = set?.sorted(by: { (taskA, taskB) -> Bool in
            return taskA.priority < taskB.priority
        })
		
		guard let task = sortedSet?[indexPath.row] else { return }
		guard let fetchedResultsController = fetchedResultsController else { return }
		coordinator?.showEditTask(persistentContainer, task: task, fetchedResultsController: fetchedResultsController)
		tableView.deselectRow(at: indexPath, animated: true)
	}
}