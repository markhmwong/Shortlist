//
//  RedactStyleViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 28/8/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class RedactStyleViewController: UICollectionViewController {

	private var viewModel: RedactStyleViewModel
	
	init(viewModel: RedactStyleViewModel) {
		self.viewModel = viewModel
		
		
		// layout
		let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

			var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
			configuration.showsSeparators = true
			
			let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)

			return section
		}
		super.init(collectionViewLayout: layout)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.offWhite
		
		viewModel.configureDataSource(collectionView: self.collectionView)
	}
}

enum RedactStyleSection: CaseIterable {
	case main
}

struct RedactStyleItem: Hashable {
	var name: String
	var style: String
}

class RedactStyleViewModel: NSObject {
	
	private var dataSource: [RedactStyleItem] = []
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<RedactStyleSection, RedactStyleItem>! = nil
	
	override init() {
		super.init()
	}
	
	func prepareDataSource() -> [RedactStyleItem] {
		// identify whether the task's redact style, should probably be stored within Core Data
		let style1 = RedactStyleItem(name: "Censored", style: "Style1")
		let style2 = RedactStyleItem(name: "Password", style: "Style2")
		dataSource.append(contentsOf: [style1, style2])
		return dataSource
	}
	
	// MARK: ConfigureDataSource
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<RedactStyleSection, RedactStyleItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewListCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		}
		diffableDataSource.apply(configureSnapshot())
	}
	
	// MARK: ConfigureSnapshot
	private func configureSnapshot() -> NSDiffableDataSourceSnapshot<RedactStyleSection, RedactStyleItem> {
		var snapshot = NSDiffableDataSourceSnapshot<RedactStyleSection, RedactStyleItem>()
		snapshot.appendSections(RedactStyleSection.allCases)
		snapshot.appendItems(prepareDataSource())
		return snapshot
	}
	
	// MARK: - Register Cell
	private func configureCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, RedactStyleItem> {
		let cellConfig = UICollectionView.CellRegistration<UICollectionViewListCell, RedactStyleItem> { (cell, indexPath, item) in

			// configure cell
			var content: UIListContentConfiguration = cell.defaultContentConfiguration()
			content.text = item.name
			cell.contentConfiguration = content
			cell.accessories = [.checkmark()]
		}
		return cellConfig
	}
}
