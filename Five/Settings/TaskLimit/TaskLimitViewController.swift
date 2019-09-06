//
//  TaskLimitViewController.swift
//  Five
//
//  Created by Mark Wong on 5/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class TaskLimitViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.backgroundColor = .black
        return view
    }()
    
    weak var coordinator: TaskLimitCoordinator?
    
    var persistentContainer: PersistentContainer?
    
    var viewModel: TaskLimitViewModel?
    
    init(persistentContainer: PersistentContainer, coordinator: TaskLimitCoordinator, viewModel: TaskLimitViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        title = "Daily Limit"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskLimitCellId")
        view.addSubview(tableView)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc
    func handleBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func currentTaskLimit() -> Int {
        if let taskLimit = KeychainWrapper.standard.integer(forKey: "DailyTaskLimit") {
            return taskLimit
        }
        return 3
    }
}

extension TaskLimitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.limits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskLimitCellId", for: indexPath)
        cell.backgroundColor = .clear
        // uninitialised view model
        guard let viewModel = viewModel else {
            cell.textLabel?.text = "\(0)"
            cell.textLabel?.textColor = UIColor.white
            return cell
        }
        
        cell.accessoryType = .none
        if (currentTaskLimit() == indexPath.row) {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = "\(viewModel.limits[indexPath.row])"
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // find and uncheck the previous limit
        let cell = tableView.cellForRow(at: IndexPath(row: currentTaskLimit(), section: 0))
        cell?.accessoryType = .none
        
        // checkmark the new limit
        let newCell = tableView.cellForRow(at: indexPath)
        newCell?.accessoryType = .checkmark
        
        // save
        KeychainWrapper.standard.set(indexPath.row, forKey: "DailyTaskLimit")
        let today = persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
        guard let viewModel = viewModel else { return }
        today.taskLimit = Int16(viewModel.limits[indexPath.row])
        persistentContainer?.saveContext()
        
        // remove selected highlight in table
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
}
