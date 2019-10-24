//
//  EditTaskViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 22/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {
	
	enum Sections: Int, CaseIterable {
		case Details = 0
		case Label
		case Time
		case Delete
	}
	
	enum DetailsSection: Int, CaseIterable {
		case Name
		case Details
	}
	
	enum TimeSection: Int, CaseIterable {
		case Reminder
	}
	
	enum DeleteSection: Int, CaseIterable {
		case Delete
	}
	
	enum LabelSection: Int, CaseIterable {
		case Category
	}
	
	var viewModel: EditTaskViewModel?
	
	var persistentContainer: PersistentContainer?
	
	var coordinator: EditTaskCoordinator?
	
	weak var fetchedResultsController: NSFetchedResultsController<Day>?
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = .clear
		view.delegate = self
		view.dataSource = self
		view.separatorStyle = .none
		view.estimatedRowHeight = viewModel?.cellHeight ?? 100.0
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	
	init(viewModel: EditTaskViewModel, persistentContainer: PersistentContainer, fetchedResultsController: NSFetchedResultsController<Day>) {
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		self.fetchedResultsController = fetchedResultsController // to remove
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = Theme.GeneralView.background
		navigationItem.prompt = "Make changes to your Task"
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
		
		viewModel?.registerCells(tableView: tableView)
		view.addSubview(tableView)
		tableView.fillSuperView()
	}
	
	@objc
	func handleCancel() {
		navigationController?.dismiss(animated: true, completion: {
			//
		})
	}
	
	@objc
	func handleDone() {
		
		viewModel?.onDoneSaveToTaskObject(persistentContainer)
		navigationController?.dismiss(animated: true, completion: {
			//
		})
	}

}

extension EditTaskViewController: UITableViewDelegate, UITableViewDataSource {
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if let section = Sections.init(rawValue: indexPath.section) {
			switch section {
				case .Details:
					return UITableView.automaticDimension
				case .Delete:
					return 80.0
				default:
					return 80.0
			}
		}
		
        return UITableView.automaticDimension
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
// to do - viewmodel should hold the count of rows
		if let row = Sections.init(rawValue: section) {
			switch row {
				case .Label:
					return 1
				case .Delete:
					return 1
				case .Details:
					return 2
				case .Time:
					return 1
			}
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel else {
			let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .DefaultCell) as! EditTaskTextViewCell
			cell.nameTextView.textColor = UIColor.white
			cell.nameTextView.text = "Unknown Task"
			return cell
		}
		
		if let section = Sections.init(rawValue: indexPath.section) {
			switch section {
				case .Details:
					if let row = DetailsSection.init(rawValue: indexPath.row) {
						switch row {
							case .Name:
								let cell: EditTaskTextViewCell = viewModel.tableViewTextViewCell(tableView: tableView, indexPath: indexPath)
								cell.updateTask(taskNameString: viewModel.task?.name ?? "A short and descriptive task name")
								cell.persistentContainer = persistentContainer
								cell.saveTask = { (nameStr) in
									viewModel.updateTaskName(self.persistentContainer, updateWithString: nameStr)
								}
								
								cell.updateTaskString = { (taskNameStr, indexPath) in
									viewModel.updateTaskNameString(name: taskNameStr, indexPath: indexPath)
								}
								return cell
							case .Details:
								let cell: EditTaskTextViewCell = viewModel.tableViewTextViewCell(tableView: tableView, indexPath: indexPath)
								cell.updateTask(taskNameString: viewModel.task?.details ?? "Add a short note here")
								cell.persistentContainer = persistentContainer
								
								cell.saveTask = { (nameStr) in
									viewModel.updateTaskName(self.persistentContainer, updateWithString: nameStr)
								}
								
								cell.updateTaskString = { (taskNameStr, indexPath) in
									viewModel.updateTaskNameString(name: taskNameStr, indexPath: indexPath)
								}
								return cell
						}
					}
				case .Time:
					if let row = TimeSection.init(rawValue: indexPath.row) {
						switch row {
							case .Reminder:
								let cell: EditTaskLabelCell = viewModel.tableViewLabelCell(tableView: tableView, indexPath: indexPath)
								cell.updateLabel(name: "Reminder to do")
								return cell
						}
				}
				case .Label:
					if let row = LabelSection.init(rawValue: indexPath.row) {
						switch row {
							case .Category:
								let cell: EditTaskTextViewCell = viewModel.tableViewTextViewCell(tableView: tableView, indexPath: indexPath)
								cell.updateTask(taskNameString: viewModel.task?.category ?? "Unknown Category")
								return cell
						}
					}
				case .Delete:
					if let row = DeleteSection.init(rawValue: indexPath.row) {
						switch row {
							case .Delete:
								let cell: EditTaskLabelCell = viewModel.tableViewLabelCell(tableView: tableView, indexPath: indexPath)
								cell.updateLabel(name: "Delete Task")
								return cell
						}
				}
			}
		}

		let cell = viewModel.defaultCell(tableView: tableView, indexPath: indexPath)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let section = Sections.init(rawValue: indexPath.section) {
			switch section {
				case .Delete:
					// 1. remove task
					guard let viewModel = viewModel else { return }
					let dayManagedObject = self.persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
					
					guard let task = viewModel.task else { return }
					let taskManagedObject = self.persistentContainer?.viewContext.object(with: task.objectID) as! Task
					dayManagedObject.removeFromDayToTask(taskManagedObject)
					dayManagedObject.totalTasks = dayManagedObject.totalTasks - 1
					if task.complete {
						dayManagedObject.totalCompleted = dayManagedObject.totalCompleted - 1
					}
					
					self.persistentContainer?.saveContext()
					
					// 2. dismiss vc
					navigationController?.dismiss(animated: true, completion: {
						//
					})
				default:
				()
			}
		}
	}
}
