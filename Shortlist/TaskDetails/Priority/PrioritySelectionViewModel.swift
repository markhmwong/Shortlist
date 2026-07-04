//
//  PrioritySelectionViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 31/8/2025.
//  Copyright © 2025 Mark Wong. All rights reserved.
//

import UIKit

public class PrioritySelectionViewModel {

	enum Section {
		case main
	}

    public let priorities: [TaskPriorityLevel] = TaskPriorityLevel.allCases

    public var selectedPriority: TaskPriorityLevel?

	public var task: SLTask

	private var dataSource: UITableViewDiffableDataSource<Section, TaskPriorityLevel>!

	public init(selectedPriority: TaskPriorityLevel? = nil, task: SLTask) {
		self.task = task
		self.selectedPriority = TaskPriorityLevel(rawValue: Int(task.priority)) //TODO: FIX to INT from INT16
    }

	public func updateDataSource(tableView: UITableView) {
		dataSource = UITableViewDiffableDataSource<Section, TaskPriorityLevel>(tableView: tableView) { [weak self] tableView, indexPath, priority in
			let cell = tableView.dequeueReusableCell(withIdentifier: "PriorityCell", for: indexPath)
			cell.textLabel?.text = String(describing: priority).capitalized
			cell.textLabel?.textColor = priority.textColour
			cell.backgroundColor = priority.baseColour.withAlphaComponent(0.15)
			if let selected = self?.selectedPriority {
				cell.accessoryType = (priority == selected) ? .checkmark : .none
			} else {
				cell.accessoryType = .none
			}
			return cell
		}
		dataSource.defaultRowAnimation = .fade
	}

	public func applySnapshot(animated: Bool) {
		var snapshot = NSDiffableDataSourceSnapshot<Section, TaskPriorityLevel>()
		snapshot.appendSections([.main])
		snapshot.appendItems(priorities, toSection: .main)
		dataSource.apply(snapshot, animatingDifferences: animated)
	}
}
