//
//  ViewController.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    var viewModel: MainViewModel? = nil
    
    var coreDataManager: CoreDataManager?
    
    var persistentContainer: PersistentContainer?
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
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
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        // test watch
        syncWatch()
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
        

    }
    
    func syncWatch() {
        let today = Calendar.current.today()
        let taskList = TaskList(date: today)
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(taskList)
//            let jsonString = String(data: jsonData, encoding: .utf8)
            print("send")
//            print(WatchSessionHandler.shared.isReachable())
//            WatchSessionHandler.shared.sendObjectWith(jsonData: jsonData)
            WatchSessionHandler.shared.updateApplicationContext(with: jsonData)
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
    }
    
    func loadReview() {
        guard let coreDataManager = coreDataManager else { return }
        
        let vc = ReviewViewController(coreDataManager: coreDataManager)
        self.present(vc, animated: true)
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
        var dayEntity: Day? = persistentContainer.fetchDayManagedObject(forDate: todaysDate)

        if (dayEntity == nil) {
            let privateContext = persistentContainer.newBackgroundContext()
            dayEntity = Day(context: privateContext)
            dayEntity?.date = todaysDate as NSDate
            dayEntity?.taskLimit = 5 //default limit

            // possible loading graphic

            privateContext.performAndWait {
                do {
                    try privateContext.save()
                } catch (let err) {
                    print("\(err) trouble saving")
                }
            }
        }

        viewModel.dayEntity = dayEntity
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
        syncWatch()
//        guard let viewModel = viewModel else { return }
//        if (viewModel.taskDataSource.count < viewModel.taskSizeLimit) {
//            persistentContainer.performBackgroundTask { (context) in
//                let dayObject = context.object(with: viewModel.dayEntity!.objectID) as! Day
//                persistentContainer.createSampleTask(toEntity: dayObject, context: context, idNum: viewModel.taskDataSource.count)
//                persistentContainer.saveContext(backgroundContext: context)
//                self.loadData()
//            }
//        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.taskDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellId", for: indexPath) as! TaskCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.taskListCellId, for: indexPath) as! TaskCell
        cell.task = viewModel.taskDataSource[indexPath.row]
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
                self.viewModel?.taskDataSource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                let taskManagedObject = self.persistentContainer?.viewContext.object(with: task.objectID) as! Task
                dayManagedObject.removeFromDayToTask(taskManagedObject)
                self.persistentContainer?.saveContext()
            }

            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

