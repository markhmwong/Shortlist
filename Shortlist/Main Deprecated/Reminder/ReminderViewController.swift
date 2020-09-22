//
//  ReminderViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 12/3/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

// Reminder viewer. Allows users to pull and add reminders from the Reminder App
// A read-only Reminder view

import EventKit
import UIKit

class ReminderViewController: UIViewController {
	
	let coordinator: ReminderCoordinator
	
	let persistentContainer: PersistentContainer
	
	var viewModel: ReminderViewModel
	
	let reminderService: ReminderService
	
	var delegate: MainViewControllerProtocol?
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = Theme.GeneralView.background
		view.delegate = self
		view.rowHeight = UITableView.automaticDimension
		view.separatorStyle = .none
		view.estimatedRowHeight = 150.0
		view.allowsMultipleSelection = true
		return view
	}()
	
	init(viewModel: ReminderViewModel, reminderService: ReminderService, persistentContainer: PersistentContainer, coordinator: ReminderCoordinator) {
		self.viewModel = viewModel
		self.reminderService = reminderService
		self.persistentContainer = persistentContainer
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Selected Tasks", style: .plain, target: self, action: #selector(handleCopy))
		navigationItem.rightBarButtonItem?.isEnabled = false
		navigationItem.leftBarButtonItem = UIBarButtonItem().backButton(target: self, action: #selector(handleDismiss))
		setupView()
	}
	
	func setupView() {
		view.backgroundColor = Theme.GeneralView.background
		viewModel.registerCells(tableView)
		viewModel.configureDiffableDatasource(tableView: tableView)
		view.addSubview(tableView)
		
		tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		
		reminderService.fetchReminders { (reminders) in
			guard let reminders = reminders else { return }
			self.viewModel.updateReminderData(reminders: reminders)
			self.viewModel.updateDatasourceSnapshot()
		}
	}
	
	@objc func handleCopy() {
		
		var taskArr: [Task] = []
		if let selectedRows = tableView.indexPathsForSelectedRows {
			for index in selectedRows {
				let task = Task(context: persistentContainer.viewContext)
				let ekReminder = viewModel.reminderFor(row: index.row)
				task.ekReminderToTask(reminder: ekReminder)
				
				let category = ekReminder.calendar.title
				task.category = category
				if (persistentContainer.categoryExistsInBackLog(category)) {
					// category exists, just add the task
					if let backLog: BackLog = persistentContainer.fetchBackLog(forCategory: category) {
						backLog.addToBackLogToTask(task)
					}
				} else {
					// create category
					let backLog: BackLog = BackLog(context: persistentContainer.viewContext)
					backLog.create(name: category)
					backLog.addToBackLogToTask(task)
					let categoryList: CategoryList = CategoryList(context: persistentContainer.viewContext)
					categoryList.create(name: category)
				}
				
				taskArr.append(task)
			}
		}
		
		let today: Day = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		
		for task in taskArr {
			today.addToDayToTask(task)
			today.dayToStats?.totalTasks = (today.dayToStats?.totalTasks ?? 0) + 1
		}

		persistentContainer.saveContext()
		delegate?.reloadTableView()
		delegate?.syncWithAppleWatch()
		coordinator.dismiss()
	}
	
	@objc func handleDismiss() {
		coordinator.dismiss()
	}
}

extension ReminderViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		// enable/disable top right nav button
		guard let indexPaths = tableView.indexPathsForSelectedRows else {
			navigationItem.rightBarButtonItem?.isEnabled = false
			return
		}
		if (indexPaths.count == 0) {
			navigationItem.rightBarButtonItem?.isEnabled = false
		} else {
			navigationItem.rightBarButtonItem?.isEnabled = true
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		// check if it exceeds priority limit
		let reminder = viewModel.reminderAtTableViewCell(indexPath: indexPath)
		
		viewModel.checkPriority(persistentContainer: persistentContainer, reminder: reminder) { (arg0) in
			tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
			let (threshold, status) = arg0

			switch threshold {
				case .Exceeded:
					tableView.deselectRow(at: indexPath, animated: true)
					coordinator.showAlertBox(message: "Please update your limit from [Settings -> Priority Limit] or remove a \(status) priority task from today's schedule.")
				case .WithinLimit:
					// check if task already exists today
					let today: Day = persistentContainer.fetchDayEntity(forDate: Calendar.current.today()) as! Day
					do {
						try viewModel.doesTaskExist(for: today, in: tableView, at: indexPath)
					} catch let reminderError as ReminderError {
						coordinator.showAlertBox(message: reminderError.localizedDescription)
					} catch let err {
						coordinator.showAlertBox(message: err.localizedDescription)
					}
				
			}
			
			// enable/disable top right nav button
			guard let indexPaths = tableView.indexPathsForSelectedRows else {
				navigationItem.rightBarButtonItem?.isEnabled = false
				return
			}
			if (indexPaths.count == 0) {
				navigationItem.rightBarButtonItem?.isEnabled = false
			} else {
				navigationItem.rightBarButtonItem?.isEnabled = true
			}
		}
	}
}
