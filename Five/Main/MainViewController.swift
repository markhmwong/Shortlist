//
//  ViewController.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModel = MainViewModel()
    
    var coreDataManager: CoreDataManager?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.estimatedRowHeight = 50.0
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let saveOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
//        CoreDataManager.shared.deleteAllRecordsIn(entity: Day.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("test")
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
//        loadReview()
    }
    
    func setupView() {
        tableView.tableHeaderView = taskListHeader
        taskListHeader.setNeedsLayout()
        taskListHeader.layoutIfNeeded()
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: viewModel.taskListCellId)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
    }
    
    func loadReview() {
        let vc = ReviewViewController()
        self.present(vc, animated: true) {
            //
        }
    }

    // Deal with the situation when the user hasn't used the application for a few days. The review will open
    // yesterday's review however there won't be an entity.
    // Solution: Create the day or don't open for review. Empty/nil entities are considered 0 task days.
    
    
    func seedCoreDataWhenFirstLaunched() {
        // check with keychain
    }
    
    func loadData() {
        coreDataManager = CoreDataManager(modelName: "FiveModel", completion: {
            self.setupView()
            guard let coreDataManager = self.coreDataManager else {
                fatalError("Error loading core data manager while loading data")
            }
            var dayEntity: Day? = coreDataManager.fetchDayEntity(forDate: Calendar.current.today()) as? Day
            if (dayEntity == nil) {
                dayEntity = Day(context: coreDataManager.mainManagedObjectContext)
                let date = Calendar.current.today()
                dayEntity?.date = date as NSDate
                dayEntity?.taskLimit = 5 //default limit
                coreDataManager.saveChanges()
            }
            print("testa")
            //load the entity into the viewModel
            // this will trigger the didSet operation for the property and sorts the data
            self.viewModel.dayEntity = dayEntity
            print(self.viewModel.dayEntity)
            self.tableView.reloadData()

//            let context = CoreDataManager.shared.fetchContext()
//            if (!CoreDataManager.shared.doesEntityExist(forDate: Calendar.current.today())) {
//                //create date entity
//                dayEntity = Day(context: context!)
//                let date = Calendar.current.today()
//                dayEntity?.date = date as NSDate
//                dayEntity?.taskLimit = 5
//                CoreDataManager.shared.saveContext()
//            } else {
//                dayEntity = CoreDataManager.shared.fetchDayEntity(forDate: Calendar.current.today())
//            }
//
//            viewModel.dayEntity = dayEntity

        })
        
//        // Create Private Child Managed Object Context
//
//        let managedObjectContext = (coreDataManager?.privateChildManagedObjectContext())!
//
//        // Initialize Operation
//        let task = TaskSaver(managedObjectContext: managedObjectContext)
//
//        // Add Operation to Operation Queue
//        saveOperations.coreDataQueue.addOperation(task)
        
//        print("core data manager: \(coreDataManager?.mainManagedObjectContext)")
    }
    
    @objc
    func handleAddButton() {
        //addTask
        
        if (viewModel.taskDataSource.count < viewModel.taskSizeLimit) {
            addSampleTask(toEntity: viewModel.dayEntity!)
//            CoreDataManager.shared.saveContext()
            coreDataManager?.saveChanges()
            //reload row not entire collection view
            tableView.reloadData()
        } else {
            //show alert error
            print("over 10 tasks")
        }

    }
    
    func addSampleTask(toEntity day: Day) {
        guard let coreDataManager = coreDataManager else {
            fatalError("Error loading core data manager")
        }
        let task: Task = Task(context: coreDataManager.mainManagedObjectContext)
        let dataSourceCount = viewModel.taskDataSource.count
        task.name = "Sample Task \(dataSourceCount)"
        task.complete = false
        task.carryOver = false
        task.id = Int16(viewModel.taskDataSource.count)
        day.addToDayToTask(task)
        viewModel.taskDataSource.append(task)
//        let context = CoreDataManager.shared.fetchContext()
//        let task: Task = Task(context: context!)
//        let dataSourceCount = viewModel.taskDataSource.count
//        task.name = "Sample Task \(dataSourceCount)"
//        task.complete = false
//        task.carryOver = false
//        task.id = Int16(dataSourceCount)
//        day.addToDayToTask(task)
//
//        viewModel.taskDataSource.append(task)
    }
}



extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.taskListCellId, for: indexPath) as! TaskCell
        cell.backgroundColor = .clear
        cell.task = viewModel.taskDataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, view, complete) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            if let task = cell.task {
                //remove from datasource
                self?.viewModel.taskDataSource.remove(at: indexPath.row)
                
                //remove from core data
                self?.viewModel.dayEntity?.removeFromDayToTask(task)
                
//                CoreDataManager.shared.saveContext()
            }

            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

