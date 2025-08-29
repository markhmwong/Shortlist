//  CategorySelectionViewController.swift
//  Shortlist
//
//  Created by Assistant on 6/7/2025.
//

import UIKit

class CategorySelectionViewController: UIViewController {
    private let viewModel: CategorySelectionViewModel
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, AssetManager.CategoryAssets>!
    private let coordinator: CoordinatorFacade<SLTask>?

    init(coordinator: CoordinatorFacade<SLTask>? = nil, viewModel: CategorySelectionViewModel) {
        self.viewModel = viewModel
		self.coordinator = coordinator
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
    
    private func setupTableView() {
        view.addSubview(tableView)
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
        dataSource = UITableViewDiffableDataSource<Int, AssetManager.CategoryAssets>(tableView: tableView) { tableView, indexPath, category in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            cell.textLabel?.text = category.rawValue.capitalized
            cell.imageView?.image = UIImage(systemName: category.iconName)
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AssetManager.CategoryAssets>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.categories)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
