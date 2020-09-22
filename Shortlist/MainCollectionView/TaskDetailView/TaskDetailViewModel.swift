//
//  TaskDetailViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailViewModel: NSObject {
	
	private let sectionIdHeader: String = "com.whizbang.taskdetail.sectionid.header"
	
	private let sectionIdFooter: String = "com.whizbang.taskdetail.sectionid.footer"
	
	private var titleItem: TitleItem
	
	private var notesItem: [NotesItem]
	
	private var photoItem: [PhotoItem]
		
	private var completionStatus: Bool
	
	private var data: Task
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskDetailSections, DataItem>! = nil
	
	init(task: Task) {
		self.data = task
		self.completionStatus = task.complete
		
		self.titleItem = TitleItem(title: task.name ?? "None")
		
		// converts the core data model to a struct
		if data.taskToNotes == nil {
			// pre-2.0 catcher for notes
			self.notesItem = [NotesItem(notes: data.details ?? "None", isButton: false)]
		} else {
			// post-2.0
			var noteArray: [NotesItem] = []
			if let notes = data.taskToNotes {
				for note in notes.array as! [TaskNotes] {
					noteArray.append(NotesItem(notes: note.note ?? "None", isButton: false))
				}
			}
			self.notesItem = noteArray
		}
		
		
		self.photoItem = [PhotoItem(photo: "Photo1", isButton: false), PhotoItem(photo: "Photo2", isButton: false), PhotoItem(photo: "Photo3", isButton: false), PhotoItem(photo: "Photo4", isButton: false), PhotoItem(photo: "Photo5", isButton: false), PhotoItem(photo: "Photo6", isButton: true), PhotoItem(photo: "Photo7", isButton: false), PhotoItem(photo: "Add Photo", isButton: true)] // temp
		super.init()
	}
	
	// MARK: - DataSource methods
	func configureDataSource(collectionView: UICollectionView) {

		diffableDataSource = UICollectionViewDiffableDataSource<TaskDetailSections, DataItem>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
			
			switch item {
				case .title(let title):
					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellTitleRegistration(), for: indexPath, item: title)
					return cell
				case .notes(let notes):
					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellNotesRegistration(), for: indexPath, item: notes)
					return cell
				case .photo(let photos):
					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellPhotosRegistration(), for: indexPath, item: photos)
					return cell
			}
		})
		
		//Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<HeaderSupplementaryView>(elementKind: "SectionHeader") { [weak self]
			(supplementaryView, string, indexPath) in
			guard let self = self else { return }
			supplementaryView.priorityLabel.text = "\(self.data.priorityText())"
			supplementaryView.backgroundColor = .clear
			supplementaryView.configureCompletionIcon(with: self.completionStatus)
		}
		
		let footerRegistration = UICollectionView.SupplementaryRegistration
		<FooterSupplementaryView>(elementKind: "SectionFooter") {
			(supplementaryView, string, indexPath) in
			supplementaryView.backgroundColor = .clear
		}
		
		diffableDataSource.supplementaryViewProvider = { (view, kind, index) in

			if (index.section == 0) {
				return collectionView.dequeueConfiguredReusableSupplementary(
					using:headerRegistration, for: index)
			}
			
			if (index.section == TaskDetailSections.allCases.count - 1) {
				return collectionView.dequeueConfiguredReusableSupplementary(
					using:footerRegistration, for: index)
			}
			
			return nil
		}
		
		diffableDataSource.apply(configureSnapshot(), animatingDifferences: false) {
			//
		}
	}
	
	private func configureSnapshot() -> NSDiffableDataSourceSnapshot<TaskDetailSections, DataItem> {
		var snapshot = NSDiffableDataSourceSnapshot<TaskDetailSections, DataItem>()
		snapshot.appendSections(TaskDetailSections.allCases) // add remaining sections
		snapshot.appendItems([DataItem.title(titleItem)], toSection: .title)

		for item in notesItem {
			snapshot.appendItems([DataItem.notes(item)], toSection: .note)
		}

		for item in photoItem {
			snapshot.appendItems([DataItem.photo(item)], toSection: .photos)
		}
		
		// TO DOoptions - delete
		
		return snapshot
	}
	
	// MARK: - Cell Registration
	// register titles
	func configureCellTitleRegistration() -> UICollectionView.CellRegistration<TaskDetailTitleCell, TitleItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskDetailTitleCell, TitleItem> { (cell, indexPath, item) in
			// configure cell
			cell.configureCell(with: item)
			cell.editClosure = {
				print("to do closure")
			}
		}
		return cellConfig
	}
	
	// register notes
	func configureCellNotesRegistration() -> UICollectionView.CellRegistration<TaskDetailNotesCell, NotesItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskDetailNotesCell, NotesItem> { (cell, indexPath, item) in
			// configure cell
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// register notes
	func configureCellPhotosRegistration() -> UICollectionView.CellRegistration<TaskDetailPhotoCell, PhotoItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskDetailPhotoCell, PhotoItem> { [weak self] (cell, indexPath, item) in
			guard let _ = self else { return }
			// configure cell
			cell.configureCell(with: item)
		}
		return cellConfig
	}
	
	// MARK: - Layout each Section
	// create layout
	func createCollectionViewLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			//layout each section with sectionIndex
			
			let section = TaskDetailSections.init(rawValue: sectionIndex)
			
			switch section {
				case .title:
					return self.createLayoutForTitleSection()
				case .note:
					return self.createLayoutForNotesSection()
				case .photos:
					return self.createLayoutForPhotoSection()
				default:
					return self.createLayoutForDefaultSection()
			}
		}
		return layout
	}
	
	// MARK: - Specific Layout Configurations
	
	// Default Section Layout
	private func createLayoutForDefaultSection() -> NSCollectionLayoutSection {
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150.0))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))

		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)


		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	

	
	// MARK: - Layout reminder
	private func createLayoutForReminderSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 50.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
	
	// MARK: - Layout title Header
	private func createLayoutForTitleSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 100.0
		let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
		
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = contentInsets
		
		// HEADER
		// Note - In regards to the layout of the header, it seems setting the heightDimension argument in NSCollectionLayoutSize to .estimated collapses the inset rules adding an additional 20 points to the leadingAnchor. You'll find the insets set to the constraints in the TaskDetailHeader.swift
		let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(100.0))
		let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
																		 elementKind: sectionIdHeader, alignment: .top)
		
		let sectionLayout = NSCollectionLayoutSection(group: group)
		sectionLayout.boundarySupplementaryItems = [header]
		return sectionLayout
	}
	
	// MARK: - Photos layout - includes the footer
	private func createLayoutForPhotoSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 150.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(20), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 4)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
		
		// Footer
		let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
															  heightDimension: .estimated(50.0))
		let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerHeaderSize,
																		 elementKind: sectionIdFooter,
																		 alignment: .bottom)
		let sectionLayout = NSCollectionLayoutSection(group: group)
		sectionLayout.boundarySupplementaryItems = [footer]
		return sectionLayout
	}
	
	// MARK: - Notes Section Layout
	private func createLayoutForNotesSection() -> NSCollectionLayoutSection {
		let estimatedHeight: CGFloat = 10.0

		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))

		let item = NSCollectionLayoutItem(layoutSize: size)
		item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: NSCollectionLayoutSpacing.fixed(10), trailing: nil, bottom: NSCollectionLayoutSpacing.fixed(0))
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
		group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
		
		let sectionLayout = NSCollectionLayoutSection(group: group)
		return sectionLayout
	}
}
