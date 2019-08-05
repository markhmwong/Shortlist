//
//  ReviewViewController.swift
//  Five
//
//  Created by Mark Wong on 22/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit


// A Review of the day before.
// It shows incomplete / complete tasks
// Allows to carry over tasks to today.
class ReviewViewController: UIViewController {
 
    var coreDataManager: CoreDataManager?

    var viewModel: ReviewViewModel = ReviewViewModel()
    
    lazy var closeButton: CloseButton = {
        let button = CloseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .green
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        return button
    }()
    
    lazy var taskListHeader: UIView = {
        let view = TaskListHeader(date: Calendar.current.yesterday(), reviewState: true, delegate: self)
        return view
    }()
    
    init(coreDataManager: CoreDataManager) {
        super.init(nibName: nil, bundle: nil)
        self.coreDataManager = coreDataManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        loadData()
        //        CoreDataManager.shared.deleteAllRecordsIn(entity: Day.self)
        tableView.reloadData()
        // Do any additional setup after loading the view.
        tableView.tableHeaderView = taskListHeader
        taskListHeader.setNeedsLayout()
        taskListHeader.layoutIfNeeded()
        view.addSubview(tableView)
        view.addSubview(closeButton)
        view.addSubview(doneButton)
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: viewModel.reviewCellId)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        
        closeButton.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: -20.0), size: .zero)
        doneButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadData() {
        guard let coreDataManager = self.coreDataManager else {
            fatalError("Error loading core data manager while loading data")
        }
        
        var dayEntity: Day? = coreDataManager.fetchDayEntity(forDate: viewModel.targetDate) as? Day
        if (dayEntity == nil) {
            dayEntity = Day(context: coreDataManager.mainManagedObjectContext)
            let date = Calendar.current.today()
            dayEntity?.createdAt = date as NSDate
            dayEntity?.taskLimit = 5 //default limit
            coreDataManager.saveChanges()
        }
        
        self.viewModel.dayEntity = dayEntity
        self.tableView.reloadData()
    }
    
    @objc
    func handleClose() {
        self.dismiss(animated: true) {
            //
        }
    }
    
    //todo
    @objc
    func handleDone() {
        //get tasks to carry over to the next day
//        let tasks = viewModel.taskDataSource
//        let dayEntity = CoreDataManager.shared.fetchDayEntity(forDate: Calendar.current.today())
//        for task in tasks {
//            //shift task over to the new day
//            if (task.carryOver) {
//                let newTask = Task(context: CoreDataManager.shared.fetchContext()!)
//                newTask.carryOver = false
//                newTask.complete = false
//                newTask.id = task.id
//                newTask.name = task.name
//                dayEntity?.addToDayToTask(newTask)
//            }
//        }
//        CoreDataManager.shared.saveContext()

        self.dismiss(animated: false, completion: nil)
    }
}



extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.reviewCellId, for: indexPath) as! ReviewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .blue
        cell.task = viewModel.taskDataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, view, complete) in
            
            let cell = tableView.cellForRow(at: indexPath) as! ReviewCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReviewCell
        guard let task = cell.task else {
            return
        }

        task.carryOver = !task.carryOver
        if task.carryOver {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

