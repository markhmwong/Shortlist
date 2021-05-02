//
//  TaskDetailViewModel.swift
//  Shortlist
//
//  Created by Mark Wong on 29/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailViewModel: NSObject {
	
	private let photoLimit = 4
	
	private let sectionIdHeader: String = "com.whizbang.taskdetail.sectionid.header"
	
	private let sectionIdHeaderTitle: String = "com.whizbang.taskdetail.sectionid.headerTitle"
	
	let sectionIdFooter: String = "com.whizbang.taskdetail.sectionid.footer"
	
	private var titleItem: TitleItem
	
	private var notesItem: [NotesItem]
	
	private var photoItem: [PhotoItem]
		
	private var completionStatus: Bool
	
    private(set) var data: Task
	
	private var diffableDataSource: UICollectionViewDiffableDataSource<TaskDetailSections, DataItem>! = nil
	
	private var snapshot: NSDiffableDataSourceSnapshot<TaskDetailSections, DataItem>! = nil
	
	var persistentContainer: PersistentContainer
	
	private var mainFetcher: MainFetcher<Task>! = nil
	
	init(task: Task, persistentContainer: PersistentContainer) {
		self.data = task
		self.completionStatus = task.complete
		self.persistentContainer = persistentContainer
        self.titleItem = TitleItem(title: "Oops no name!", priority: Priority.medium)
		self.notesItem = []
		self.photoItem = []
		super.init()
	}
	
	func taskId() -> UUID {
		return data.id ?? UUID()
	}
	
	/*
	
		MARK: - Image Methods
	
	*/
	// MARK: - Process image
	func saveImage(imageData: UIImage) {
		// scale photo
		
		let thumbnail = UIImage().scalePhotoToThumbnail(image: imageData, width: Double(imageData.size.width), height: Double(imageData.size.height))
		
		// convert to jpeg
		guard let i = imageData.jpegData(compressionQuality: 1.0), let thumbnailData = thumbnail.jpegData(compressionQuality: 0.5) else {
			// handle failed conversion
			print("jpg error")
			return
		}
		
		// save process
		persistentContainer.savePhoto(data: data, fullRes: i, thumbnail: thumbnailData)
		persistentContainer.saveContext()
	}
	
	// MARK: Delete Image
	func removeImage(item: PhotoItem) {
		persistentContainer.deletePhoto(withId: item.id)
	}
	
	/*

		MARK: - DataSource methods
		Called during Initial setup
	*/
	func configureDataSource(collectionView: UICollectionView, resultsController: MainFetcher<Task>) {
		mainFetcher = resultsController

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
				case .complete(let complete):
					let cell = collectionView.dequeueConfiguredReusableCell(using: self.configureCellCompletionRegistration(), for: indexPath, item: complete)
					return cell
			}
		})
		
		//Supplementary Views
		let headerRegistration = UICollectionView.SupplementaryRegistration
		<HeaderSupplementaryView>(elementKind: "SectionHeader") { [weak self]
			(supplementaryView, string, indexPath) in
			guard let self = self else { return }
			if let section = TaskDetailSections.init(rawValue: indexPath.section) {
				switch section {
					case .title, .complete:
						() // no title
					case .photos:
						supplementaryView.update(title: "Photos")
					case .note:
						supplementaryView.update(title: "Notes")
				}
			}
		}
		
		diffableDataSource.supplementaryViewProvider = { (view, kind, index) in
			if (TaskDetailSupplementaryView.Header == kind) {
				return collectionView.dequeueConfiguredReusableSupplementary(using:headerRegistration, for: index)
			}
			return nil
		}
		
		updateSnapshot()
	}
	
	/*
	
		MARK: - Update Snapshot
		Public method, exposed to the viewcontroller to be called when the data has mutated
	*/
	func updateSnapshot() {
		guard let mainFetcher = self.mainFetcher else { return }

		self.snapshot = NSDiffableDataSourceSnapshot<TaskDetailSections, DataItem>()
		
		snapshot.appendSections(TaskDetailSections.allCases) // add remaining sections
		// This is required, as the variable is forced unwrapped during creation. The second problem is that the order of operation - mainFetcher is not yet initialised because of NSFetchedResultsController being called when it calls .performFetch()
		
		if let task = mainFetcher.fetchRequestedObjects()?.first {
			
            let title = TitleItem(title: task.name ?? "None", priority: Priority.init(rawValue: task.priority) ?? .medium)
			
			snapshot.appendItems([DataItem.title(title)], toSection: .title)
			
            let completionItem = CompletionItem(id: task.objectID, name: "Complete", isComplete: task.complete)
			snapshot.appendItems([DataItem.complete(completionItem)], toSection: .complete)

			// converts the core data model to a struct
			if task.taskToNotes == nil {
				// pre-2.0 catcher for notes
                self.notesItem = [NotesItem(id: nil, notes: data.details ?? "None", isButton: false)]
			} else {
				// post-2.0
				var noteArray: [NotesItem] = []

				if let notes = task.taskToNotes {

					if notes.count != 0 {
						for note in notes.array as! [TaskNote] {
                            let notesItem = NotesItem(id: note.objectID, notes: note.note ?? "None", isButton: false)
							let dataItem = DataItem.notes(notesItem)
							noteArray.append(notesItem)
							snapshot.appendItems([dataItem], toSection: .note)
						}
					}
                    
                    //add additional note for
                    if notes.count <= 4 {
                        let notesItem = NotesItem(id: nil, notes: "Add a brief note", isButton: true)
                        let dataItem = DataItem.notes(notesItem)
                        noteArray.append(notesItem)
                        snapshot.appendItems([dataItem], toSection: .note)
                    }
                    
				} else {
					// empty notes
                    let notesItem = NotesItem(id: nil, notes: "Add a brief note", isButton: true)
					let dataItem = DataItem.notes(notesItem)
					noteArray.append(notesItem)
					snapshot.appendItems([dataItem], toSection: .note)
				}
			}

			// Assign photos
			if task.taskToPhotos == nil {
				self.photoItem = [PhotoItem(id: UUID(),photo: nil, isButton: true)]
			} else {
				var photoArray: [PhotoItem] = []
				if let photoSet = task.taskToPhotos?.array {
					for photo in photoSet as! [TaskPhotos] {
						let photoItem = PhotoItem(id: photo.id ?? UUID(), photo: photo.photo, thumbnail: photo.thumbnail, isButton: false)
						photoArray.append(photoItem)
						let dataItem = DataItem.photo(photoItem)
						snapshot.appendItems([dataItem], toSection: .photos)
					}
				}

				// "Add" button
				if photoArray.count < 4 && photoArray.count >= 0 {
					let photoItem = PhotoItem(id: UUID(), photo: nil, caption: "Add a new photo", isButton: true)
					let dataItem = DataItem.photo(photoItem)
					photoArray.append(photoItem)
					snapshot.appendItems([dataItem], toSection: .photos)
				}
				self.photoItem = photoArray
			}
		}
		
		diffableDataSource.apply(self.snapshot, animatingDifferences: false) {
			//
		}
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
	
	
	func configureCellCompletionRegistration() -> UICollectionView.CellRegistration<TaskDetailCompletionCell, CompletionItem> {
		let cellConfig = UICollectionView.CellRegistration<TaskDetailCompletionCell, CompletionItem> { [weak self] (cell, indexPath, item) in
			guard let _ = self else { return }
			// configure cell
			cell.configureCell(with: item)
            
		}
		return cellConfig
	}
}
