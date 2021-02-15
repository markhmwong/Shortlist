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

protocol MainViewControllerProtocol: AnyObject {
	func showAlert(_ message: String)
	func reloadTableView()
	func showCategory()
	func showTimePicker()
	func updateCategory()
	func syncWithAppleWatch()
	func postTask(taskName: String, category: String, priorityLevel: Int)
	var viewModel: MainViewModel? { get set }
}

class MainViewController: UIViewController, PickerViewContainerProtocol, MainViewControllerProtocol {
    
	private var connectivity: Connectivity? = Connectivity()
	
    weak var coordinator: MainCoordinator? = nil
    
    var viewModel: MainViewModel? = nil
    
    weak var persistentContainer: PersistentContainer? = nil
  
    lazy var fetchedResultsController: NSFetchedResultsController<Day>? = {
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
	
	private lazy var mainInputView: MainInputView = {
		let view = MainInputView(delegate: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.alpha = 0.0
		view.backgroundColor = Theme.Cell.textFieldBackground
		return view
	}()
	
	private lazy var pickerViewContainer: PickerViewContainer = {
		let view = PickerViewContainer(delegateP: self)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
//    lazy var tableView: UITableView = {
//        let view = UITableView()
//        view.delegate = self
//        view.dataSource = self
//        view.dragDelegate = self
//        view.dropDelegate = self
//        view.dragInteractionEnabled = true
//		view.backgroundColor = Theme.GeneralView.background
//        view.separatorStyle = .none
//        view.isEditing = false
//        view.estimatedRowHeight = viewModel?.cellHeight ?? 100.0
//        view.rowHeight = UITableView.automaticDimension
//        view.translatesAutoresizingMaskIntoConstraints = false
//		view.keyboardDismissMode = .onDrag
//        return view
//    }()
	
	var collectionView: UICollectionView! = nil
    
    lazy var addButton: StandardButton = {
        let button = StandardButton(title: "AddTask")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
		button.setAttributedTitle(NSAttributedString(string: "Add Task", attributes: [NSAttributedString.Key.font : UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor : Theme.Button.textColor]), for: .normal)
		
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var taskListHeader: UIView = {
        let view = TaskListHeader(date: Calendar.current.today())
        return view
    }()
	
	lazy var newsFeed: NewsFeed = {
		let feed = NewsFeed()
		return feed
	}()
	
	private var bottomConstraint: NSLayoutConstraint?
    
	private var pickerViewBottomConstraint: NSLayoutConstraint?
    
	var newsFeedTopAnchor: NSLayoutYAxisAnchor?
	
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
		loadData()
		setupView()
		AppStoreReviewManager.requestReviewIfAppropriate()
		prepareKeyboardNotifications()
		initialiseStatEntity()
		
		// Apple watch observer
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).dataDidFlow(_:)),
			name: .watchDidUpdate, object: nil
        )
    }
	
	// MARK: - Data Initialisation
	
	func initialiseData(_ dayObject: Day) {
		guard let _viewModel = viewModel else { return }
		_viewModel.sortedSet = _viewModel.sortTasks(dayObject)
	}
	
	//only created if it doesn't exist
	func initialiseStatEntity() {
		guard let _persistentContainer = persistentContainer else { return }
		guard _persistentContainer.fetchStatEntity() != nil else {
			let stat = Stats(context: _persistentContainer.viewContext)
			stat.id = Int64(0)
			stat.favoriteTimeToComplete = nil
			stat.totalCompleteTasks = 0
			stat.totalTasks = 0
			stat.totalIncompleteTasks = 0
			stat.statsToComplete = Set<StatsCategoryComplete>() as NSSet
			stat.statsToIncomplete = Set<StatsCategoryIncomplete>() as NSSet
			
			let complete = StatsCategoryComplete(context: _persistentContainer.viewContext)
			complete.name = "Uncategorized"
			complete.completeCount = 0
			stat.addToStatsToComplete(complete)
			
			let incomplete = StatsCategoryIncomplete(context: _persistentContainer.viewContext)
			incomplete.name = "Uncategorized"
			incomplete.incompleteCount = 0
			stat.addToStatsToIncomplete(incomplete)
			
			_persistentContainer.saveContext()
			return
		}
	}
	
	func prepareKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
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
				dayObject?.dayToStats?.highPriority = Int64(Int.random(in: 1...3))
				dayObject?.dayToStats?.mediumPriority = Int64(Int.random(in: 1...5))
				dayObject?.dayToStats?.lowPriority = Int64(Int.random(in: 1...5))
                dayObject?.createdAt = date as NSDate
				dayObject?.dayToStats?.totalCompleted = Int64(totalCompleted)
				dayObject?.dayToStats?.totalTasks = Int64(totalTasks)
                dayObject?.month = Calendar.current.monthToInt(date: date, adjust: -i)
                dayObject?.year = Calendar.current.yearToInt()
                dayObject?.day = Int16(Calendar.current.dayDate(date: date))
            }
        }
		persistentContainer.saveContext()
    }

    private func setupView() {
		guard viewModel != nil else { return }
		navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleSettings), imageName: "ellipsis")
		navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleSettings), imageName: "gear")
		
//		viewModel.registerCell(tableView)

//        tableView.tableHeaderView = taskListHeader
//        taskListHeader.setNeedsLayout()
//        taskListHeader.layoutIfNeeded()
		
		collectionView = createCollectionView()
		
		view.addSubview(collectionView)
//		view.addSubview(tableView)
		view.addSubview(mainInputView)
		view.addSubview(addButton)
		view.addSubview(newsFeed)
		
		collectionView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		
//		tableView.anchorView(top: newsFeed.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		
		let addButtonWidth: CGFloat = addButton.titleLabel?.text?.widthOfString(usingFont: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!) ?? 0.0
        addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -80.0, right: 0.0), size: CGSize(width: addButtonWidth + 40, height: 0.0))
		mainInputView.anchorView(top:nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		bottomConstraint = NSLayoutConstraint(item: mainInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		guard let _bottomConstraint = bottomConstraint else { return }
		view.addConstraint(_bottomConstraint)
		newsFeedTopAnchor = view.safeAreaLayoutGuide.topAnchor
		
		newsFeed.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: 0.0, height: 0.0))		
    }
    
    func loadData() {
        //load today's current data into dayEntity
        guard let persistentContainer = persistentContainer else { return }
        guard let viewModel = viewModel else { return }
        //check if there is data for today, if there isn't then create the day
        let todaysDate = Calendar.current.today()
        var dayObject: Day? = persistentContainer.fetchDayManagedObject(forDate: todaysDate)

        if let _dayObject = dayObject {
			/// day object exists
			initialiseData(_dayObject)
		} else {
			/// first time loading new day
            dayObject = Day(context: persistentContainer.viewContext)
			let dayStats = DayStats(context: persistentContainer.viewContext)

			guard let day = dayObject else { return }

            day.createdAt = Calendar.current.today() as NSDate
			day.highPriorityLimit = 1
			day.mediumPriorityLimit = 3
			day.lowPriorityLimit = 3

			dayStats.totalTasks = 0
			dayStats.accolade = ""
			dayStats.totalCompleted = 0

			dayStats.highPriority = 0
			dayStats.mediumPriority = 0
			dayStats.lowPriority = 0

			day.dayToStats = dayStats
            day.month = Calendar.current.monthToInt() // Stats
            day.year = Calendar.current.yearToInt() // Stats
            day.day = Int16(Calendar.current.todayToInt()) // Stats
			day.dayToTask = Set<Task>() as NSSet

		}
		persistentContainer.saveContext()
		//https://stackoverflow.com/questions/14803205/nsfetchedresultscontroller-fetch-in-a-background-thread
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
				viewModel.dayEntity = dayObject
				if (viewModel.dayEntity != nil) {
//					self.tableView.reloadData()
				}
			} catch (_) {
				
			}
		}
    }
	
	func updateCategory() {
		mainInputView.updateInputState(.writing)
		guard let vm = viewModel else { return }
		DispatchQueue.main.async {
			self.mainInputView.categoryButton.setAttributedTitle(NSMutableAttributedString(string: "\(vm.category ?? "Uncategorized")", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor.adjust(by: -70)!, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b4).value)!]), for: .normal)
		}
	}
	
	func focusOnNewTask() {
		DispatchQueue.main.async {
			self.mainInputView.taskFirstResponder()
		}
	}
	
	//move to viewmodel
	func postTask(taskName: String, category: String, priorityLevel: Int) {
		// to do add priority
        guard let persistentContainer = persistentContainer else {
            fatalError("Error loading core data manager while loading data")
        }
		
		guard let viewModel = viewModel else { return }
        guard let dayEntity = viewModel.dayEntity else { return }

		// check the number of priority level tasks
		let priorityLimitState = viewModel.checkPriorityLimit(persistentContainer: persistentContainer, priorityLevel: priorityLevel, delegate: self)
		
		if (priorityLimitState) {
			let context: NSManagedObjectContext  = persistentContainer.viewContext
			let dayObject: Day = context.object(with: dayEntity.objectID) as! Day
			let createdAt: Date = Date()
			let reminderDate: Date = pickerViewContainer.getValues()

			guard let stats = dayObject.dayToStats else { return }
			stats.totalTasks += 1
			let task: Task = Task(context: context)
			task.create(context: context, taskName: taskName, categoryName: category, createdAt: createdAt, reminderDate: reminderDate, priority: priorityLevel, redact: 0)
			
			dayObject.addToDayToTask(task)
			
			// check if category exists then add the task to that category
			if (persistentContainer.categoryExistsInBackLog(category)) {
				if let backLog: BackLog = persistentContainer.fetchBackLog(forCategory: category) {
					backLog.addToBackLogToTask(task)
				}
			} else {
				// create category
				let backLog: BackLog = BackLog(context: persistentContainer.viewContext)
				backLog.create(name: category)
				backLog.addToBackLogToTask(task)
				let categoryList: CategoryList = CategoryList(context: persistentContainer.viewContext)
				categoryList.create(name: category)
			}

			//create notification
			if (reminderDate.timeIntervalSince(createdAt) > 0.0) {
				task.reminderState = true
				if let priority = Priority.init(rawValue: Int16(priorityLevel)) {
					LocalNotificationsService.shared.addReminderNotification(dateIdentifier: createdAt, notificationContent: [LocalNotificationKeys.Body : taskName, LocalNotificationKeys.Title : priority.stringValue], timeRemaining: reminderDate.timeIntervalSince(createdAt))
				}
			}
			
			// add to stats
			if let stats: Stats = persistentContainer.fetchStatEntity() {
				stats.addToTotalTasks(numTasks: 1)
				stats.addToTotalIncompleteTasks(numTasks: 1)
			}
			dayObject.dayToStats = stats
			persistentContainer.saveContext()
			
			mainInputView.resignFirstResponder()
			mainInputView.resetTextView()
			
			//sync watch
			viewModel.syncWithWatchData(fetchedResultsController: fetchedResultsController)
		}
	}
	
	// MARK: - Keybaord methods. Open and close time picker for reminder/alarm and category
	func showTimePicker() {
		mainInputView.taskResignFirstResponder()
		guard let viewModel = viewModel else { return }
		
		view.addSubview(pickerViewContainer)
		pickerViewContainer.anchorView(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: viewModel.keyboardSize.height))
		pickerViewBottomConstraint = NSLayoutConstraint(item: pickerViewContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(pickerViewBottomConstraint!)
	}

	func closeTimePicker() {
		guard let viewModel = viewModel else { return }
		pickerViewBottomConstraint?.constant = viewModel.keyboardSize.height
		UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
			self.view.layoutIfNeeded()
			self.focusOnNewTask()
		}) { (complete) in
			//
		}
	}
	
	func showCategory() {
		coordinator?.showCategory(persistentContainer, mainViewController: self)
	}
	
	func showAlert(_ message: String) {
		coordinator?.showAlertBox(message)
	}
	
	// MARK: - Add button and animation
    @objc
    func handleAddButton() {
        guard let viewModel = viewModel else { return }
		
		// set the default and initial category as Uncategorized
		viewModel.category = "Uncategorized"
		
		// attention is brought to the text label
		self.focusOnNewTask()
		
//        os_log("CurrTasks %d, Totaltasks %d", log: Log.task, type: .info, day.totalTasks, day.taskLimit)
    }
	
	func emphasiseAddButton() {
		DispatchQueue.main.async {
			self.addButton.backgroundColor = Theme.Button.donationButtonBackgroundColor
			self.addButton.setAttributedTitle(NSAttributedString(string: "Add Task", attributes: [NSAttributedString.Key.font : UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!, NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor]), for: .normal)
			
			UIView.animate(withDuration: 1.2, delay: 0.7, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
				self.addButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
			}) { (state) in
				
			}
		}
	}
	
	// MARK: - Top navigation bar button selectors
    @objc func handleSettings() {
        guard let coordinator = coordinator else { return }
        coordinator.showSettings(persistentContainer)
    }
    
    @objc func handleOptions() {
		// change from backlog to show a list of options
		
		guard let coordinator = self.coordinator else { return }
		coordinator.showOptions(persistentContainer)
    }
	
	// MARK: - Keyboard Notification
	@objc func handleKeyboardNotification(_ notification : Notification?) {
		
		if let info = notification?.userInfo {
			
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			guard let viewModel = viewModel else { return }
			
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				viewModel.keyboardSize = kbFrame
				
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
	
	// MARK: - Table View Reload
	@objc func dataDidFlow(_ notification: Notification) {
		DispatchQueue.main.async {
//			self.tableView.reloadData()
		}
	}
	
	func reloadTableView() {
		DispatchQueue.main.async {
//			self.tableView.reloadData()
		}
	}
	
	// MARK: Table View preview parameter when dragging
    private func previewParameters(forItemAt indexPath:IndexPath, tableView:UITableView) -> UIDragPreviewParameters?     {
        let previewParameters = UIDragPreviewParameters()
        previewParameters.backgroundColor = .black
        return previewParameters
    }
	
	// MARK: - Apple Watch
	func syncWithAppleWatch() {
		guard let viewModel = viewModel else { return }
		viewModel.syncWithWatchData(fetchedResultsController: fetchedResultsController)
	}
	
		// padding done inside stats
	//	private func createMockStatisticalData() {
	//        guard let persistentContainer = persistentContainer else { return }
	//		for day in 1...30 {
	//			let date = Calendar.current.forSpecifiedDay(value: -day)
	//			if (persistentContainer.fetchDayEntity(forDate: date) == nil) {
	//
	//				// create empty day
	//				let dayObj = Day(context: persistentContainer.viewContext)
	//				dayObj.createMockDay(date: date)
	//				persistentContainer.saveContext()
	//			}
	//		}
	//	}
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		do {
            try fetchedResultsController?.performFetch()
			// organise dictionary here
			guard let viewModel = viewModel else { return }
			guard let dayObject = fetchedResultsController?.fetchedObjects?.first else {
				return
			}

			let sortedSet = viewModel.sortTasks(dayObject)
			viewModel.sortedSet = sortedSet
			
//            DispatchQueue.main.async {
////                self.tableView.reloadData()
//            }
        } catch (_) {
            
        }
    }
}

// MARK: - Collection View Methods
extension MainViewController {
	private func createCollectionView() -> UICollectionView {
		guard let viewModel = viewModel else {
			let collectionView = UICollectionView()
			collectionView.translatesAutoresizingMaskIntoConstraints = false
			return collectionView
		}
		let layout = viewModel.createCompositionalLayout()
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}
}


// MARK: - Table View Delegate Methods, DataSource, DragDelegate, DropDelegate
//extension MainViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		guard let _viewModel = viewModel else {
//			tableView.separatorColor = .clear
//			tableView.setEmptyMessage("Start something great by tapping the 'Add' button below")
//			emphasiseAddButton()
//			return 0
//		}
//
//        guard let _dayObjects = fetchedResultsController?.fetchedObjects else {
//			tableView.separatorColor = .clear
//			tableView.setEmptyMessage(_viewModel.getRandomTip())
//			return 0
//		}
//
//		if let _day = _dayObjects.first {
//			if (_day.dayToTask?.count == 0) {
//				emphasiseAddButton()
//				tableView.separatorColor = .clear
//				tableView.setEmptyMessage(_viewModel.getRandomTip())
//				return 0
//			} else {
//				tableView.restoreBackgroundView()
//				return _day.dayToTask?.count ?? 0
//			}
//		} else {
//			return 0
//		}
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let _viewModel = viewModel else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskCell
//			cell.textLabel?.text = "Unknown Task"
//            return cell
//        }
//		let cell: TaskCell = _viewModel.tableViewCell(tableView, indexPath: indexPath, fetchedResultsController: fetchedResultsController, persistentContainer: persistentContainer)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, view, complete) in
//            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
//			guard let persistentContainer = self.persistentContainer else { return }
//            let dayManagedObject = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as! Day
//
//            if let task = cell.task {
//                let taskManagedObject = persistentContainer.viewContext.object(with: task.objectID) as! Task
//                dayManagedObject.removeFromDayToTask(taskManagedObject)
//
//				dayManagedObject.dayToStats?.totalTasks = (dayManagedObject.dayToStats?.totalTasks ?? 0) - 1
//
//				let backLog = persistentContainer.fetchBackLog(forCategory: taskManagedObject.category)
//				backLog?.removeFromBackLogToTask(taskManagedObject)
//
//				if task.complete {
//					dayManagedObject.dayToStats?.totalCompleted = (dayManagedObject.dayToStats?.totalCompleted ?? 0) - 1
//				}
//
//				if let stats: Stats = self.persistentContainer?.fetchStatEntity() {
//					stats.removeFromTotalTasks(numTasks: 1)
//					if (task.complete) {
//						stats.removeFromTotalCompleteTasks(numTasks: 1)
//					} else {
//						stats.removeFromTotalIncompleteTasks(numTasks: 1)
//					}
//				}
//
//                self.persistentContainer?.saveContext()
//
//				// perform sync with watch
//				if let viewModel = self.viewModel {
//					viewModel.syncWithWatchData(fetchedResultsController: self.fetchedResultsController)
//				}
//
//            }
//            complete(true)
//        }
//        return UISwipeActionsConfiguration(actions: [delete])
//    }
//
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//		guard let viewModel = viewModel else { return }
//		guard let sortedSet = viewModel.sortedSet else { return }
//        let sourceTask = sortedSet[sourceIndexPath.section]
//        let destTask = sortedSet[destinationIndexPath.section]
//        let tempDestinationPriority = destTask.priority
//        destTask.priority = sourceTask.priority
//        sourceTask.priority = tempDestinationPriority
//        persistentContainer?.saveContext()
//		self.loadData()
//    }
//
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        return [UIDragItem(itemProvider: NSItemProvider())]
//    }
//
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        //
//    }
//
//    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        return previewParameters(forItemAt: indexPath, tableView: tableView)
//    }
//
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		guard let persistentContainer = persistentContainer else { return }
//		guard let viewModel = viewModel else { return }
//		guard let task = viewModel.sortedSet?[indexPath.row] else { return }
//		guard let fetchedResultsController = fetchedResultsController else { return }
//
//		coordinator?.showEditTask(persistentContainer, task: task, fetchedResultsController: fetchedResultsController, mainViewController: self)
//		tableView.deselectRow(at: indexPath, animated: true)
//	}
//}
