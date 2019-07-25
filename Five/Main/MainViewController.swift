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
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
//        CoreDataManager.shared.deleteAllRecordsIn(entity: Day.self)
        tableView.reloadData()
        // Do any additional setup after loading the view.
        tableView.tableHeaderView = taskListHeader
        taskListHeader.setNeedsLayout()
        taskListHeader.layoutIfNeeded()
        view.addSubview(tableView)
        view.addSubview(addButton)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: viewModel.taskListCellId)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
        

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
        loadReview()
    }
    
    func loadReview() {
        let vc = ReviewViewController()
        self.present(vc, animated: true) {
            //
        }
    }
    

    
    func loadData() {
        var dayEntity: Day? = nil
        let context = CoreDataManager.shared.fetchContext()
        if (!CoreDataManager.shared.doesEntityExist(forDate: Calendar.current.today())) {
            //create date entity
            dayEntity = Day(context: context!)
            let date = Calendar.current.today()
            dayEntity?.date = date as NSDate
            dayEntity?.taskLimit = 5
            CoreDataManager.shared.saveContext()
        } else {
            dayEntity = CoreDataManager.shared.fetchDayEntity(forDate: Calendar.current.today())
        }
        
        viewModel.dayEntity = dayEntity
    }
    
    @objc
    func handleAddButton() {
        //addTask
        
        if (viewModel.taskDataSource.count < viewModel.taskSizeLimit) {
            addSampleTask(toEntity: viewModel.dayEntity!)
            CoreDataManager.shared.saveContext()

            //reload row not entire collection view
            tableView.reloadData()
        } else {
            //show alert error
            print("over 10 tasks")
        }

    }
    
    func addSampleTask(toEntity day: Day) {
        let context = CoreDataManager.shared.fetchContext()
        let task: Task = Task(context: context!)
        let dataSourceCount = viewModel.taskDataSource.count
        task.name = "Sample Task \(dataSourceCount)"
        task.complete = false
        task.carryOver = false
        task.id = Int16(dataSourceCount)
        day.addToDayToTask(task)

        viewModel.taskDataSource.append(task)
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
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { [weak self] (action, view, complete) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            if let task = cell.task {
                //remove from datasource
                self?.viewModel.taskDataSource.remove(at: indexPath.row)
                
                //remove from core data
                self?.viewModel.dayEntity?.removeFromDayToTask(task)
                
                CoreDataManager.shared.saveContext()
            }

            complete(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

