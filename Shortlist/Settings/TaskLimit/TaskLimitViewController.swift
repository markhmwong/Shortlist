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
    
	// parentViewController
	weak var pvc: SettingsViewController? = nil
	
	init(persistentContainer: PersistentContainer, coordinator: TaskLimitCoordinator, viewModel: TaskLimitViewModel, parentViewController: SettingsViewController?) {
        self.coordinator = coordinator
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
		self.pvc = parentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let vm = viewModel else { return }
		
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleDismiss), imageName: "Back", height: self.topBarHeight / 2)
        title = "Daily Limit"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: vm.cellId)
        view.addSubview(tableView)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc
    func handleDismiss() {
		guard let _pvc = pvc else {
			coordinator?.dismiss()
			return
		}
		coordinator?.dismiss()
		_pvc.reloadData()
    }
	
	deinit {
		print("task limit deinit")
		coordinator?.cleanUpChildCoordinator()
	}
}

extension TaskLimitViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let _viewModel = viewModel else { return nil }
		return _viewModel.headerForSection(section: section)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let viewModel = viewModel else { return 3 }
		return viewModel.numSections()
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 1
        }
		return viewModel.rowsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let _viewModel = viewModel else {
			// to do
			let cell = tableView.dequeueReusableCell(withIdentifier: viewModel?.cellId ?? "TaskLimitCellId", for: indexPath)
			cell.backgroundColor = .clear
			cell.accessoryType = .none
			cell.textLabel?.text = "\(indexPath.row)"
			cell.textLabel?.textColor = UIColor.white
			return cell
		}
		return _viewModel.tableViewCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let _viewModel = viewModel else { return }
		guard let _persistentContainer = persistentContainer else { return }
		
		let currTaskLimit = _viewModel.taskLimitFor(section: indexPath.section) - 1 // we -1 to adjust for the row
		
        // find and uncheck the previous limit
		let cell = tableView.cellForRow(at: IndexPath(row: currTaskLimit, section: indexPath.section))
		cell?.accessoryType = .none
        
        // checkmark the new limit
        let newCell = tableView.cellForRow(at: indexPath)
        newCell?.accessoryType = .checkmark
        
        // save
		_viewModel.updateKeychain(indexPath: indexPath)
		_viewModel.updateDayObject(persistentContainer: _persistentContainer)
		
        persistentContainer?.saveContext()
        
        // remove selected highlight in table
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
}
