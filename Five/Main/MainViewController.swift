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
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
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
        let view = TaskListHeader()
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
//        tableView.register(TaskCell.self, forCellWithReuseIdentifier: viewModel.taskListCellId)
//        tableView.register(TaskListHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TaskListHeaderId")
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        
        addButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
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
        
        if (viewModel.taskDataSource.count < 101) {
            addSampleTask(toEntity: viewModel.dayEntity!)
            CoreDataManager.shared.saveContext()
//            CoreDataManager.shared.printTodaysRecordIn(entity: Day.self)
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
        task.id = Int16(dataSourceCount)
        day.addToDayToTask(task)

        viewModel.taskDataSource.append(task)
    }
}

extension Calendar {
    func today() -> Date {
        return self.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
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
    
}

//extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.taskDataSource.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.taskListCellId, for: indexPath) as! TaskCell
//        cell.backgroundColor = .clear
//        cell.task = viewModel.taskDataSource[indexPath.item]
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.bounds.width - 20.0, height: 50.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.bounds.width, height: 200.0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TaskListHeaderId", for: indexPath)
//        return header
//    }
//}

