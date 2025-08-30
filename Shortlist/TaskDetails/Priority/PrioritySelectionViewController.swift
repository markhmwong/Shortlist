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
	enum Section { case main }
	private let viewModel: PrioritySelectionViewModel
	private var dataSource: UITableViewDiffableDataSource<Section, TaskPriorityLevel>!
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

		dataSource = UITableViewDiffableDataSource<Section, TaskPriorityLevel>(tableView: tableView) { [weak self] tableView, indexPath, priority in
			let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath)
			cell.textLabel?.text = String(describing: priority).capitalized
			cell.textLabel?.textColor = priority.textColour
			cell.backgroundColor = priority.baseColour.withAlphaComponent(0.15)
			if let selected = self?.viewModel.selectedPriority {
				cell.accessoryType = (priority == selected) ? .checkmark : .none
			} else {
				cell.accessoryType = .none
			}
			return cell
		}
		applySnapshot(animated: false)
	}

	override func viewWillDisappear(_ animated: Bool) {
		coordinator.refreshOnPop(with: viewModel.task)
	}

	private func applySnapshot(animated: Bool) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, TaskPriorityLevel>()
		snapshot.appendSections([.main])
		snapshot.appendItems(viewModel.priorities, toSection: .main)
		dataSource.apply(snapshot, animatingDifferences: animated)
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let priority = viewModel.priorities[indexPath.row]
		updateTaskPriority(priority: priority)
		applySnapshot(animated: true)
//		delegate?.prioritySelectionViewController(self, didSelect: priority)
//		navigationController?.popViewController(animated: true)
	}

	private func updateTaskPriority(priority: TaskPriorityLevel) {
		viewModel.selectedPriority = priority
		viewModel.task.priority = Int16(priority.rawValue)
	}
}


