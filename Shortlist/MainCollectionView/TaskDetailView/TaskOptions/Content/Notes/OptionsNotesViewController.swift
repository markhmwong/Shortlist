//
//  NotesViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 1/10/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

enum OptionsNotesSection: CaseIterable {
	case main
}

struct OptionsNotesItem: Hashable {
	var id: UUID = UUID()
	var note: String
	// date
}

class OptionsNotesViewModel: NSObject {
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<OptionsNotesSection, OptionsNotesItem>! = nil
		
	private var data: Task
	
	private var persistentContainer: PersistentContainer
	
	init(data: Task, persistentContainer: PersistentContainer) {
		self.data = data
		self.persistentContainer = persistentContainer
		super.init()
	}
	
	func configureSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<OptionsNotesSection, OptionsNotesItem>()
		snapshot.appendSections(OptionsNotesSection.allCases)
		
		var currentData: [OptionsNotesItem] = []
		
		if let notes = data.taskToNotes {
			for note in notes.array as! [TaskNote] {
				currentData.append(OptionsNotesItem(note: note.note ?? "Enter a helpful note!"))
			}
		}
		currentData.append(OptionsNotesItem(note: data.details ?? "Unknown"))
		snapshot.appendItems(currentData)
		diffableDataSource.apply(snapshot)
	}
	
	private func configureCellRegistration() -> UICollectionView.CellRegistration<OptionsNotesCell, OptionsNotesItem> {
		let cellConfig = UICollectionView.CellRegistration<OptionsNotesCell, OptionsNotesItem> { (cell, indexPath, item) in
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
			let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellRegistration(), for: indexPath, item: item)
			return cell
		})
		configureSnapshot()
	}
}

class OptionsNotesViewController: UICollectionViewController {
	
	//collectionview
//	private var collectionView: BaseCollectionView! = nil
	
	private var viewModel: OptionsNotesViewModel
	
	init(viewModel: OptionsNotesViewModel) {
		self.viewModel = viewModel
		super.init(collectionViewLayout: UICollectionViewLayout().createListLayout(appearance: .insetGrouped, separators: true, header: false, headerElementKind: "", footer: false, footerElementKind: ""))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		collectionView.backgroundColor = UIColor.orange
//		createCollectionView()
		viewModel.configureDataSource(collectionView: collectionView)
	}
	
	func createCollectionView() {
//		collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout().createListLayout())
		
//		collectionView.translatesAutoresizingMaskIntoConstraints = false
		
//		view.addSubview(collectionView)
		
//		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}
}
