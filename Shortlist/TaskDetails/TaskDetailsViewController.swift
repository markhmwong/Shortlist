//  TaskDetailsView.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import os

class TaskDetailsViewController: UITableViewController, Refreshable {
	func refresh(item: SLTask) {
		DispatchQueue.main.async { [weak self] in
			self?.viewModel.task.value = item
			self?.viewModel.applySnapshot()
		}
	}


	private var viewModel: TaskDetailsViewModel

	/// Navigation
	private var coordinator: TaskDetailsCoordinator

	public var delegate: Refreshable

	init(viewModel: TaskDetailsViewModel, coordinator: TaskDetailsCoordinator, delegate: Refreshable) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		self.delegate = delegate
		super.init(style: .insetGrouped)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .secondarySystemBackground

		tableView.separatorStyle = .none
		title = "Task Details"
		tableView.tableFooterView = createCompleteButton()
		registerTableViewCells()
		viewModel.configureDiffableDataSource(with: self)
		viewModel.applySnapshot()

		// Reload table when item changes
		viewModel.task.bind { [weak self] _ in
			DispatchQueue.main.async {
				self?.viewModel.applySnapshot()
			}
		}
	}

	private func registerTableViewCells() {
		tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.identifier)
		tableView.register(TextViewTableViewCell.self, forCellReuseIdentifier: TextViewTableViewCell.identifier)
		tableView.register(SelectableTableViewCell.self, forCellReuseIdentifier: SelectableTableViewCell.identifier)
	}

	private func createCompleteButton() -> UIView {
		let button = UIButton(type: .system)
		button.setTitle("Complete", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 18)
		button.backgroundColor = .systemGray5
		button.layer.cornerRadius = 10
		button.translatesAutoresizingMaskIntoConstraints = false
		button.heightAnchor.constraint(equalToConstant: 60).isActive = true
		button.addTarget(self, action: #selector(handleComplete), for: .touchUpInside)

		let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 70))
		container.addSubview(button)

		NSLayoutConstraint.activate([
			button.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor),
			button.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor),
			button.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
			button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
		])

		return container
	}

	@objc private func handleComplete() {

		if !validation() {
			let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.whizbang.shortlist", category: "TaskDetails")
			logger.warning("Validation failed")
			return
		}

		viewModel.taskIsComplete { [weak self] item in
			guard let self = self else { return }
			self.viewModel.save(// get the data from the text view
				priority: item.priority,
				longitude: item.long,
				latitude: item.lat
			)
			self.coordinator.dismissCurrentView()
			self.delegate.refresh(item: item)
		}
	}

	private func validation() -> Bool {
		let name = viewModel.task.value.name?.trimmingCharacters(in: .whitespacesAndNewlines)
		if name == nil || name!.isEmpty {
			presentAlert(title: "Missing Name", message: "Please enter a name for the task.")
			return false
		}
		if viewModel.task.value.priority == 0 {
			presentAlert(title: "Missing Priority", message: "Please select a priority for the task.")
			return false
		}
		return true
	}

	private func presentAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}

	// MARK: - TableView Delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let section = viewModel.sections[indexPath.section]

		switch section {
			case .priority:
				// push priority selection view controller (to be implemented)
				coordinator.pushPrioritySelectionViewController(with: viewModel.task.value)
				break
			case .reminder:
				coordinator.pushReminderDatePickerViewController(with: viewModel.task.value)
				break
			case .category:
				coordinator.pushCategorySelectionViewController(with: viewModel.task.value)
				// push category selection view controller (to be implemented)
				break
			default:
				break
		}

		tableView.deselectRow(at: indexPath, animated: true)
	}

}
