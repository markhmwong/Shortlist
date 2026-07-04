//  PrioritySelectionViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 2025-07-04.
//

import UIKit

//protocol PrioritySelectionDelegate: AnyObject {
//    func prioritySelectionViewController(_ controller: PrioritySelectionViewController, didSelect priority: TaskPriorityLevel)
//}

class PrioritySelectionViewController: UITableViewController {
	
	private let viewModel: PrioritySelectionViewModel
	private let coordinator: TaskDetailsCoordinator

	init(
		coordinator: TaskDetailsCoordinator,
		viewModel: PrioritySelectionViewModel,
	) {
		self.coordinator = coordinator
		self.viewModel = viewModel
		super.init(style: .insetGrouped)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Select Priority"
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PriorityCell")

		viewModel.updateDataSource(tableView: tableView)
		viewModel.applySnapshot(animated: false)
	}

	override func viewWillDisappear(_ animated: Bool) {
		coordinator.refreshOnPop(with: viewModel.task)
	}

	

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let priority = viewModel.priorities[indexPath.row]
		updateTaskPriority(priority: priority)
		viewModel.updateDataSource(tableView: tableView)
		viewModel.applySnapshot(animated: true)
//		delegate?.prioritySelectionViewController(self, didSelect: priority)
//		navigationController?.popViewController(animated: true)
	}

	private func updateTaskPriority(priority: TaskPriorityLevel) {
		viewModel.selectedPriority = priority
		viewModel.task.priority = Int16(priority.rawValue)
	}
}


