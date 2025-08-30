//  CategorySelectionViewController.swift
//  Shortlist
//
//  Created by Assistant on 6/7/2025.
//

import UIKit

class CategorySelectionViewController: UIViewController, UITableViewDelegate {
    private let viewModel: CategorySelectionViewModel
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, AssetManager.Category>!
    private let coordinator: CoordinatorFacade<SLTask>?
	private let delegate: RefreshablePopView
	init(
		coordinator: CoordinatorFacade<SLTask>? = nil,
		viewModel: CategorySelectionViewModel,
		delegate: RefreshablePopView
	) {
        self.viewModel = viewModel
        self.coordinator = coordinator
		self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Category"

        setupTableView()
        setupDataSource()
        applySnapshot()
    }

	override func viewWillDisappear(_ animated: Bool) {
		delegate.refresh(item: viewModel.task)
	}

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, AssetManager.Category>(tableView: tableView) { [weak self] tableView, indexPath, category in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            cell.textLabel?.text = category.name.capitalized
            cell.imageView?.image = UIImage(systemName: category.symbol)

            // Checkmark reflects current selection stored on the task
            let selectedType = self.viewModel.task.taskToCategory?.type
            cell.accessoryType = (selectedType == category.rawValue) ? .checkmark : .none

            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    private func applySnapshot(animating: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AssetManager.Category>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.categories, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: animating)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = dataSource.itemIdentifier(for: indexPath) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        // Update model
        viewModel.task.taskToCategory?.type = category.rawValue
        viewModel.cds.saveContext()

        // Reapply the snapshot so the cell provider recomputes checkmarks
        applySnapshot(animating: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }



}

