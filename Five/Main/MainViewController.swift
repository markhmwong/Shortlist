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

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    var viewModel: MainViewModel? = nil
    
    var persistentContainer: PersistentContainer?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Day> = {
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
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.isEditing = true
        view.estimatedRowHeight = viewModel?.cellHeight ?? 50.0
        view.rowHeight = UITableView.automaticDimension
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .green
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return button
    }()
    
    lazy var taskListHeader: UIView = {
        let view = TaskListHeader(date: Calendar.current.today())
        return view
    }()
    
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
//        deleteAllData()
//        initialiseSampleData()
        
        loadData()
        setupView()
        AppStoreReviewManager.requestReviewIfAppropriate()
        let localTime = DateFormatter().localDateTime()
        print(Calendar.current.sevenDaysFromDate(currDate: localTime))

//        guard let dayArray = persistentContainer?.fetchAllTasksByWeek(forWeek: Calendar.current.startOfWeek(), today: Calendar.current.today()) else {
//            //no data to do
//            return
//        }
        // test watch
//        syncWatch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Calendar.current.today()
        let todayStr = today.toString()
        //initialise date
        guard let date = KeychainWrapper.standard.string(forKey: "Date") else {
            KeychainWrapper.standard.set(todayStr, forKey: "Date")
            return
        }
        
        if (date != todayStr) {
            //load review
            loadReview()
            //update
            KeychainWrapper.standard.set(todayStr, forKey: "Date")
        }
//        loadReview() //to test
        persistentContainer?.saveContext()
    }
    
    func initialiseSampleData() {
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
    
    func deleteAllData() {
        guard let persistentContainer = persistentContainer else { return }
        persistentContainer.deleteAllRecordsIn(entity: Day.self)
    }
    
    // disabled
    func syncWatch() {
        let today = Calendar.current.today()
        let taskList: [TaskStruct] = [
            TaskStruct(id: 0, name: "Sample Task One", complete: false),
            TaskStruct(id: 1, name: "Sample Task One", complete: false),
            TaskStruct(id: 2, name: "Sample Task One", complete: false),
        ]

        do {
            let encodedData = try JSONEncoder().encode(taskList)
//            let jsonString = String(data: encodedData, encoding: .utf8)
            WatchSessionHandler.shared.updateApplicationContext(with: encodedData)
        } catch (let err) {
            print("Error encoding taskList \(err)")
        }
        
    }
    
    func setupView() {
        guard let viewModel = viewModel else { return }
        tableView.tableHeaderView = taskListHeader
        taskListHeader.setNeedsLayout()
        taskListHeader.layoutIfNeeded()
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: viewModel.taskListCellId)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stats", style: .plain, target: self, action: #selector(handleStats))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))

    }
    
    @objc
    func handleSettings() {
        guard let coordinator = coordinator else { return }
        coordinator.showSettings(persistentContainer)
    }
    
    @objc
    func handleStats() {
        guard let coordinator = coordinator else { return }
        coordinator.showStats(persistentContainer)
    }
    
    func loadReview() {
        // no longer using coredataManager pass PersistentContainer object instead
//        guard let coreDataManager = coreDataManager else { return }
        
//        let vc = ReviewViewController(coreDataManager: coreDataManager)
//        self.present(vc, animated: true)
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
        do {
            try fetchedResultsController.performFetch()
        } catch (let err) {
            print("Unable to perform fetch \(err)")
        }
        
        if (dayObject == nil) {
            let privateContext = persistentContainer.newBackgroundContext()
            dayObject = Day(context: privateContext)
            var today = Calendar.current.today() as NSDate
            dayObject?.createdAt = Calendar.current.today() as NSDate
            dayObject?.taskLimit = 5 //default limit
            dayObject?.month = Calendar.current.monthToInt() // Stats
            dayObject?.year = Calendar.current.yearToInt() // Stats
            dayObject?.day = Int16(Calendar.current.todayToInt()) // Stats
            // possible loading graphic todo
            
            privateContext.performAndWait {
                do {
                    try privateContext.save()
                } catch (let err) {
                    print("\(err) trouble saving")
                }
            }
        }
        viewModel.dayEntity = dayObject
        if (viewModel.dayEntity != nil) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc
    func handleAddButton() {
        guard let persistentContainer = persistentContainer else {
            fatalError("Error loading core data manager while loading data")
        }
        guard let vm = viewModel else { return }
        guard let day = vm.dayEntity else { return }


        if (day.totalTasks < day.taskLimit) {
            //        syncWatch()
            persistentContainer.performBackgroundTask { (context) in
                
                let dayObject = context.object(with: day.objectID) as! Day
                dayObject.totalTasks += 1
                persistentContainer.createSampleTask(toEntity: dayObject, context: context, idNum: vm.taskDataSource.count)
                
                persistentContainer.saveContext(backgroundContext: context)
                self.loadData()
            }
        } else {
            // show alert todo
            coordinator?.showAlertBox("Over the Limit")
        }
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        do {
            try fetchedResultsController.performFetch()
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayObjects = fetchedResultsController.fetchedObjects else { return 0 }
        let first = dayObjects.first
        return first?.dayToTask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.taskListCellId, for: indexPath) as! TaskCell
        let dayObject = fetchedResultsController.fetchedObjects?.first
        let set = dayObject?.dayToTask as? Set<Task>
        
        if (!set!.isEmpty) {
            let sortedSet = set?.sorted(by: { (taskA, taskB) -> Bool in
                return taskA.id < taskB.id
            })
            cell.task = sortedSet?[indexPath.row]
        }
        
        cell.adjustDailyTaskComplete = { (task) in
            if (task.complete) {
                dayObject?.totalCompleted += 1
            } else {
                dayObject?.totalCompleted -= 1
            }
            self.persistentContainer?.saveContext()
        }
        
        cell.updateWatch = { (task) in
            //WCSession
            let taskList = self.fetchedResultsController.fetchedObjects?.first?.dayToTask as! Set<Task>
            var tempTaskStruct: [TaskStruct] = []
            for task in taskList {
                tempTaskStruct.append(TaskStruct(id: task.id, name: task.name!, complete: task.complete))
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
                //remove from table view datasource
                let taskManagedObject = self.persistentContainer?.viewContext.object(with: task.objectID) as! Task
                dayManagedObject.removeFromDayToTask(taskManagedObject)
                dayManagedObject.totalTasks = dayManagedObject.totalTasks - 1
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
            return taskA.id < taskB.id
        })
        
        let sourceTask = sortedSet?[sourceIndexPath.row]
        let destTask = sortedSet?[destinationIndexPath.row]

        let tempDestinationPriority = destTask?.priority
        destTask?.priority = sourceTask!.priority
        sourceTask?.priority = tempDestinationPriority!
        persistentContainer?.saveContext()

        for task in sortedSet! {
            print(task.name, task.priority)
        }
    }
}

