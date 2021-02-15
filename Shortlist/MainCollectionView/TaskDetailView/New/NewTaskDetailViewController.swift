//
//  NewTaskViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 25/1/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

// each section needs a header except for the first section
// big header with priority and reminder and something else
// task name

class NewTaskDetailViewModel: NSObject {
	
	static var headerElement: String = "com.whizbang.textjam.newtask.header"
	
	var dataSource: [DataItem] = []
	
	private var titleItem: TitleItem
	
	private var notesItem: [NotesItem]
	
	private var photoItem: [PhotoItem]
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<NewTaskDetailSection, DataItem>! = nil

	private var snapshot: NSDiffableDataSourceSnapshot<NewTaskDetailSection, DataItem>! = nil

	private var mainFetcher: MainFetcher<Task>! = nil

	private var data: Task

	private var completionStatus: Bool

	private var persistentContainer: PersistentContainer
	
	init(task: Task, persistentContainer: PersistentContainer) {
		self.data = task
		self.completionStatus = task.complete
		self.persistentContainer = persistentContainer
		self.titleItem = TitleItem(title: "Oops no name!")
		self.notesItem = []
		self.photoItem = []
		super.init()
	}
	
	// MARK: DataSource
	func configureDataSource(collectionView: UICollectionView) {
		diffableDataSource = UICollectionViewDiffableDataSource<NewTaskDetailSection, DataItem>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
			
//			switch item {
//				case .header(let item):
//					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellHeaderRegistration(), for: indexPath, item: item)
//					return cell
//				case .title(let item):
//					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellTitleRegistration(), for: indexPath, item: item)
//					return cell
//				case .photo(let item):
//					return nil
////					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellPhotoRegistration()(), for: indexPath, item: item)
////					return cell
//			}
			return nil
		}
		prepareDataSource()
		diffableDataSource.apply(configureSnapshot())
	}
	
	func prepareDataSource() {
		let headerItem = NewTaskDetailHeaderItem(priority: "High", reminder: "3:30am", redact: true, section: .header)
//		let titleItem = NewTaskDetaildTitleItem(name: "Visit Dad. A meeting with work colleagues, friends, family, grocery shopping, initial design or prototype.", section: .taskName)
//		dataSource.append(DataItem.header(headerItem))
//		dataSource.append(DataItem.title(titleItem))
	}
	
	func configureSnapshot() -> NSDiffableDataSourceSnapshot<NewTaskDetailSection, DataItem> {
		var snapshot = NSDiffableDataSourceSnapshot<NewTaskDetailSection, DataItem>()
		snapshot.appendSections(NewTaskDetailSection.allCases)
		for d in dataSource {
			// use dataitem
//			snapshot.appendItems([d], toSection: d.section)
		}
		return snapshot
	}
	
	/*
	
		MARK: - Update Snapshot
		Public method, exposed to the viewcontroller to be called when the data has mutated
	*/
	func updateSnapshot() {
		self.snapshot = NSDiffableDataSourceSnapshot<NewTaskDetailSection, DataItem>()
		
		snapshot.appendSections(NewTaskDetailSection.allCases) // add remaining sections
		
		// This is required, as the variable is forced unwrapped during creation. The second problem is that the order of operation - mainFetcher is not yet initialised because of NSFetchedResultsController being called when it calls .performFetch()
		guard let mainFetcher = self.mainFetcher else { return }
		
		if let task = mainFetcher.fetchRequestedObjects()?.first {
			
			let title = TitleItem(title: task.name ?? "None")
			
//			snapshot.appendItems([DataItem.title(title)], toSection: .title)
			
			// Assign photos
			if task.taskToPhotos == nil {
//				NewTaskDetailPhotoItem(id: <#T##UUID#>, photo: <#T##Data?#>, thumbnail: <#T##Data?#>, isButton: <#T##Bool#>, section: <#T##NewTaskDetailSection#>)
			}
			
//			if task.taskToPhotos == nil {
//				self.photoItem = [NewTaskDetailPhotoItem(id: UUID(),photo: nil, isButton: true, section: <#NewTaskDetailSection#>)]
//			} else {
//				var photoArray: [NewTaskDetailPhotoItem] = []
//				if let photoSet = task.taskToPhotos?.array {
//					for photo in photoSet as! [TaskPhotos] {
//						let photoItem = PhotoItem(id: photo.id ?? UUID(), photo: photo.photo, thumbnail: photo.thumbnail, isButton: false)
//						photoArray.append(photoItem)
//						let dataItem = DataItem.photo(photoItem)
//						snapshot.appendItems([dataItem], toSection: .photos)
//					}
//				}
//
//				// Include "Add" button
//				if photoArray.count < 4 && photoArray.count >= 0 {
//					let photoItem = PhotoItem(id: UUID(), photo: nil, isButton: true)
//					let dataItem = DataItem.photo(photoItem)
//					photoArray.append(photoItem)
//					snapshot.appendItems([dataItem], toSection: .photos)
//				}
//				self.photoItem = photoArray
//			}
		}
		
		diffableDataSource.apply(self.snapshot, animatingDifferences: false) {
			//
		}
	}
	
	// MARK: Cell Registration
	private func configureCellHeaderRegistration() -> UICollectionView.CellRegistration<NewTaskDetailHeaderCell, NewTaskDetailHeaderItem> {
		let cellConfig = UICollectionView.CellRegistration<NewTaskDetailHeaderCell, NewTaskDetailHeaderItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	private func configureCellTitleRegistration() -> UICollectionView.CellRegistration<NewTaskDetailTitleCell, NewTaskDetailTitleItem> {
		let cellConfig = UICollectionView.CellRegistration<NewTaskDetailTitleCell, NewTaskDetailTitleItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
//	private func configureCellPhotoRegistration() -> UICollectionView.CellRegistration<NewTaskDetailTitleCell, NewTaskDetailPhotoItem> {
//		let cellConfig = UICollectionView.CellRegistration<NewTaskDetailTitleCell, NewTaskDetailPhotoItem> { (cell, indexPath, item) in
//			// setup cell views and text from item
//			cell.configureCell(with: item)
//		}
//		return cellConfig
//	}
	
	private func configureCellNoteRegistration() -> UICollectionView.CellRegistration<NewTaskDetailNoteCell, NewTaskDetailNoteItem> {
		let cellConfig = UICollectionView.CellRegistration<NewTaskDetailNoteCell, NewTaskDetailNoteItem> { (cell, indexPath, item) in
			// setup cell views and text from item
			cell.configureCell(with: item)
		}
		return cellConfig
	}
}

// MARK: view controller
class NewTaskDetailViewController: BaseCollectionViewController {
	
	private var coordinator: TaskDetailCoordinator
	
	private var viewModel: NewTaskDetailViewModel
	
	init(coordinator: TaskDetailCoordinator, viewModel: NewTaskDetailViewModel) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(collectionViewLayout: viewModel.createLayoutForNewTaskDetails())
//		super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewLayoutPadding(header: false, elementKind: "", padding: 0))
		collectionView.contentInsetAdjustmentBehavior = .never
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = UIColor.yellow
		viewModel.configureDataSource(collectionView: collectionView)
	}
}

extension NewTaskDetailViewModel {
	
	// MARK: - Notes Section Layout
	func createLayoutForNotesSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 10.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
		
		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	
	func createLayoutForHeaderSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 90.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
		
		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	
	func createLayoutForTaskNameSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 10.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
		
		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	
	//zero padding
	func createLayoutForNewTaskDetails() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			let section = NewTaskDetailSection.init(rawValue: sectionIndex)
			
			switch section {
				case .header:
					return self.createLayoutForHeaderSection()
				case .taskName:
					return self.createLayoutForTaskNameSection()
				case .photo:
					return self.createLayoutForTaskNameSection()

//				case .notes:
//					return self.createLayoutForNotesSection()
				case .none:
					return self.createLayoutForTaskNameSection()
			}
			
		}
		
		return layout
	}
	
}
