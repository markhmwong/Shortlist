//  CategorySelectionViewController.swift
//  Shortlist
//
//  Created by Assistant on 6/7/2025.
//

import UIKit

public class CategorySelectionViewController: UITableViewController {
	private let viewModel: CategorySelectionViewModel
	private let coordinator: CoordinatorFacade<SLTask>?

	public init(
		coordinator: CoordinatorFacade<SLTask>? = nil,
		viewModel: CategorySelectionViewModel,
	) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		title = "Category"

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategorySelectionViewModel.categoryCellIdentifier)
		viewModel.createCategoryItems()
		viewModel.setupDataSource(tableView: tableView)
		viewModel.applySnapshot(animating: false)
	}

	public override func viewWillDisappear(_ animated: Bool) {
		coordinator?.refreshOnPop(with: viewModel.task)
	}

	public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let category = viewModel.dataSource.itemIdentifier(for: indexPath) else {
			tableView.deselectRow(at: indexPath, animated: true)
			return
		}

		// Update model
		viewModel.task.taskToCategory?.type = category.rawCategory
		viewModel.cds.saveContext()

		// Reapply the snapshot so the cell provider recomputes checkmarks
		viewModel.setupDataSource(tableView: tableView)
		viewModel.applySnapshot(animating: true)

		tableView.deselectRow(at: indexPath, animated: true)

	}
}
