//
//  EditTaskViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 22/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController, PickerViewContainerProtocol {
	func closeTimePicker() {
		// close
	}
	
	// use the global enum or move to view model
	enum Sections: Int, CaseIterable {
		case Details = 0
		case Priority
		case Label
		case Reminder
		case Delete
	}
	
	enum DetailsSection: Int, CaseIterable {
		case Name
		case Details
	}
	
	enum ReminderSection: Int, CaseIterable {
		case ReminderToggle
		case Reminder
	}
	
	enum DeleteSection: Int, CaseIterable {
		case Delete
		case DeleteDisclaimer
	}
	
	enum LabelSection: Int, CaseIterable {
		case Category
	}
	
	enum PrioritySection: Int, CaseIterable {
		case PriorityLevel
	}
	
	var viewModel: EditTaskViewModel?
	
	weak var persistentContainer: PersistentContainer?
	
	var coordinator: EditTaskCoordinator?
	
	weak var fetchedResultsController: NSFetchedResultsController<Day>?
	
	var delegate: MainViewControllerProtocol?
	
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
	

	
	init(viewModel: EditTaskViewModel, persistentContainer: PersistentContainer, fetchedResultsController: NSFetchedResultsController<Day>, delegate: MainViewControllerProtocol, coordinator: EditTaskCoordinator) {
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		self.fetchedResultsController = fetchedResultsController // to remove
		self.delegate = delegate
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
			
		navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleCancel), imageName: "Back", height: self.topBarHeight / 1.8)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
		view.backgroundColor = Theme.GeneralView.background
		navigationItem.prompt = "Make changes to your Task"
		
		guard let vm = viewModel else { return }
		vm.registerCells(tableView: tableView)
		view.addSubview(tableView)
		tableView.fillSuperView()
	}
	
	@objc
	func handleCancel() {
		guard let viewModel = viewModel else { return }
		guard let _coordinator = coordinator else { return }
		// confirm to cancel
		_coordinator.discardBox(viewModel: viewModel, persistentContainer: persistentContainer)

	}
	
	@objc
	func handleSave() {
		guard let delegate = delegate, let viewModel = viewModel else { return }
		viewModel.onDoneSaveToTaskObject(persistentContainer)
		delegate.reloadTableView()
		navigationController?.dismiss(animated: true, completion: {
			//
		})
	}
	
	deinit {
		coordinator?.cleanUpChildCoordinator()
	}
}

extension EditTaskViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel?.sectionTitles[section]
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let view = view as! UITableViewHeaderFooterView
		
		if #available(iOS 10, *) {
			view.contentView.backgroundColor = .black
		} else {
			view.backgroundView?.backgroundColor = .black
		}
		
		let size: CGFloat = Theme.Font.FontSize.Standard(.b4).value
		view.textLabel?.font = UIFont(name: Theme.Font.Bold, size: size)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UITableViewHeaderFooterView()
		view.textLabel?.textColor = .white
		view.backgroundView?.backgroundColor = .black
		return view
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if let section = Sections.init(rawValue: indexPath.section) {
			switch section {
				case .Details:
					return UITableView.automaticDimension
				case .Priority:
					return UITableView.automaticDimension
				case .Delete:
					return 60.0
				case .Reminder:
					if let row = ReminderSection.init(rawValue: indexPath.row) {
						switch row {
							case .Reminder:
								guard let viewModel = viewModel else { return UITableView.automaticDimension }
								if (viewModel.reminderToggle) {
									return UITableView.automaticDimension
								} else {
									return 0.0
								}
							case .ReminderToggle:
								return UITableView.automaticDimension
						}
					}
				case .Label:
					return UITableView.automaticDimension
			}
		}
        return UITableView.automaticDimension
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let vm = viewModel else { return 4 }
		return vm.numberOfSections()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
// to do - viewmodel should hold the count of rows
//		guard let vm = viewModel else { return 0 }
		if let row = Sections.init(rawValue: section) {
			switch row {
				case .Label:
					return LabelSection.allCases.count
				case .Delete:
					return DeleteSection.allCases.count
				case .Details:
					return DetailsSection.allCases.count
				case .Priority:
					return PrioritySection.allCases.count
				case .Reminder:
					return ReminderSection.allCases.count
//					return vm.rowsInSections[EditTaskSections.Reminder] ?? 1 // to do could be 1 or 2 based on reminder state
			}
		}
		return 1
	}
	
//	selecting the label textfield should give the option for the user to see a list of saved categories and should create a new category if it hasn't been done already.
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				
		guard let viewModel = viewModel else {
			let cell = EditTaskCellFactory.shared().getEditTaskCellType(tableView: tableView, indexPath: indexPath, cellType: .DefaultCell) as! EditTaskTextViewCell
			cell.inputTextView.textColor = UIColor.white
			cell.inputTextView.text = "Unknown Task"
			return cell
		}
		
		if let section = Sections.init(rawValue: indexPath.section) {
			switch section {
				case .Details:
					if let row = DetailsSection.init(rawValue: indexPath.row) {
						switch row {
							case .Name:
								let cell: EditTaskTextViewCell = viewModel.tableViewTextViewCell(tableView: tableView, indexPath: indexPath, fontSize: Theme.Font.FontSize.Standard(.b1).value)
								cell.inputTextView.tag = EditTaskTextViewType.Name.rawValue
								cell.updateTask(taskNameString: viewModel.task?.name ?? "A short and descriptive task name")
								cell.persistentContainer = persistentContainer
								cell.updateTaskString = { (taskNameStr, indexPath) in
									viewModel.updateTaskNameString(name: taskNameStr, indexPath: indexPath)
								}
								return cell
							case .Details:
								let cell: EditTaskTextViewCell = viewModel.tableViewTextViewCell(tableView: tableView, indexPath: indexPath, fontSize: Theme.Font.FontSize.Standard(.b2).value)
								cell.inputTextView.tag = EditTaskTextViewType.Details.rawValue
								cell.updateTask(taskNameString: viewModel.task?.details ?? "Additional notes")
								cell.persistentContainer = persistentContainer
								
								cell.updateTaskString = { (taskNameStr, indexPath) in
									viewModel.updateTaskNameString(name: taskNameStr, indexPath: indexPath)
								}
								return cell
						}
					}
				case .Priority:
					if let row = PrioritySection.init(rawValue: indexPath.row) {
						switch row {
							case .PriorityLevel:
								let cell: EditTaskPriorityCell = viewModel.tableViewPriorityCell(tableView: tableView, indexPath: indexPath)
								cell.viewModel = viewModel
								return cell
						}
					}
				case .Reminder:
					if let row = ReminderSection.init(rawValue: indexPath.row) {
						switch row {
							case .ReminderToggle:
								let cell: EditTaskToggleCell = viewModel.tableViewToggle(tableView: tableView, indexPath: indexPath)
								cell.viewModel = viewModel
								return cell
							case .Reminder:
								let cell: EditTaskPickerViewCell = viewModel.tableViewPickerViewCell(tableView: tableView, indexPath: indexPath)
								cell.viewModel = viewModel
								return cell
						}
				}
				case .Label:
					if let row = LabelSection.init(rawValue: indexPath.row) {
						switch row {
							case .Category:
								let cell: EditTaskTextViewCell = viewModel.tableViewTextViewCell(tableView: tableView, indexPath: indexPath, fontSize: Theme.Font.FontSize.Standard(.b2).value)
								cell.inputTextView.tag = EditTaskTextViewType.Category.rawValue
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
							case .DeleteDisclaimer:
								let cell: EditTaskDisclaimerCell = viewModel.tableViewDisclaimerCell(tableView: tableView, indexPath: indexPath)
								cell.updateLabel(name: "Delete's the task from today's list")
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
					let dayManagedObject: Day = self.persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
					
					guard let task = viewModel.task else { return }
					let taskManagedObject = self.persistentContainer?.viewContext.object(with: task.objectID) as! Task
					dayManagedObject.removeFromDayToTask(taskManagedObject)
					
					dayManagedObject.dayToStats?.totalTasks = (dayManagedObject.dayToStats?.totalTasks ?? 0) - 1

					if (task.complete) {
						dayManagedObject.dayToStats?.totalCompleted =  (dayManagedObject.dayToStats?.totalCompleted ?? 0) - 1
					}
					
					if let stat: Stats = persistentContainer?.fetchStatEntity() {
						task.complete ? stat.removeFromTotalCompleteTasks(numTasks: 1) : stat.removeFromTotalIncompleteTasks(numTasks: 1)
						stat.removeFromTotalTasks(numTasks: 1)
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
