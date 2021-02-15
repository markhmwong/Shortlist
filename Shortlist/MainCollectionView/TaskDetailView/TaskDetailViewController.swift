//
//  TaskView.swift
//  Shortlist
//
//  Created by Mark Wong on 28/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import PhotosUI
import CoreData

class TaskDetailViewController: UIViewController, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	// Core Data
	private lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
		// Create Fetch Request
		let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
		
		// Configure Fetch Request
		//this isn't right
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [viewModel.taskId()])
		fetchRequest.fetchLimit = 1
		
		// Create Fetched Results Controller
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		
		// Configure Fetched Results Controller
		fetchedResultsController.delegate = self
		return fetchedResultsController
	}()
	
	// Core Data
	private var mainFetcher: MainFetcher<Task>! = nil
	
	private var itemProviders = [NSItemProvider]()
	
	private var viewModel: TaskDetailViewModel
	
	private var coordinator: TaskDetailCoordinator
	
	private lazy var collectionView: BaseCollectionView! = nil
	
	init(viewModel: TaskDetailViewModel, coordinator: TaskDetailCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
		self.mainFetcher = MainFetcher(controller: fetchedResultsController)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.transparent()
		
		createCollectionView()
		mainFetcher.initFetchedObjects() // must be called first
		print("Mainfetcher \(mainFetcher)")
		viewModel.configureDataSource(collectionView: collectionView, resultsController: mainFetcher)
	}
	
	// create collection view
	func createCollectionView() {
		collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: viewModel.createCollectionViewLayout())
		collectionView.delegate = self
		view.addSubview(collectionView)

		collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
	}
	
	private func presentCamera() {
		let vc = UIImagePickerController()
		vc.sourceType = .camera
		vc.allowsEditing = true
		vc.delegate = self
		self.present(vc, animated: true)
	}
	
	func presentCameraOptions() {
		let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
			
		alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction) in
			self.presentCamera()
		}))
		
		alert.addAction(UIAlertAction(title: "Album", style: .default , handler:{ (UIAlertAction) in
			self.presentPicker(filter: PHPickerFilter.images)
		}))
		
		//uncomment for iPad Support
		//alert.popoverPresentationController?.sourceView = self.view

		self.present(alert, animated: true, completion: {
			print("completion block")
		})
	}
	
	private func presentPicker(filter: PHPickerFilter) {
		var configuration = PHPickerConfiguration()
		configuration.filter = filter
		configuration.selectionLimit = 0
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		present(picker, animated: true)
	}
	
	/*
	
		MARK: - Image Picker
	
	*/
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		dismiss(animated: true, completion: nil)
				guard !results.isEmpty else { return }
		let result = results[0]
		let provider = result.itemProvider
		let state = provider.canLoadObject(ofClass: UIImage.self)
		
		if state {
			provider.loadObject(ofClass: UIImage.self) { (image, error) in
				if let i = image as? UIImage {					
					self.viewModel.saveImage(imageData: i)
				}
			}
		}
	}
	
	func handleRemoveImage(_ cell: TaskDetailPhotoCell) {
		if let item = cell.item {
			viewModel.removeImage(item: item)
		}
	}
}

// MARK: - Collection View Delegate
extension TaskDetailViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		
		if let section = TaskDetailSections.init(rawValue: indexPath.section) {
			switch section {
				case .note, .title:
					()
				case .photos:
					
					if indexPath.last ?? 0 == indexPath.item {
						let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
						
							let addPhoto = UIAction(title: "Add Photo", image: UIImage(systemName: "plus"), identifier: UIAction.Identifier(rawValue: "add"), discoverabilityTitle: nil, state: .off) { (action) in
							}
							
							return UIMenu(title: "Photo Options", image: nil, identifier: nil, children: [addPhoto])
						}
						return config
					} else {
						let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
							// from camera or camera roll
							let delete = UIAction(title: "Remove Photo", image: UIImage(systemName: "trash"), identifier: UIAction.Identifier(rawValue: "remove"), discoverabilityTitle: nil, attributes: .destructive, state: .off) { (action) in
								let cell = collectionView.cellForItem(at: indexPath)
								self.handleRemoveImage(cell as! TaskDetailPhotoCell)
							}
							
							let view = UIAction(title: "View Photo", image: UIImage(systemName: "eye.fill"), identifier: UIAction.Identifier(rawValue: "view")) {_ in
								let cell = collectionView.cellForItem(at: indexPath) as! TaskDetailPhotoCell
								guard let photoItem = cell.item else { return }
								self.coordinator.showPhoto(item: photoItem)
							}
							
							return UIMenu(title: "Photo Options", image: nil, identifier: nil, children: [view, delete])
						}
						return config
					}
			}
		}
		return nil
	}

	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath)
		
		let itemsInSection = collectionView.numberOfItems(inSection: indexPath.section) - 1
		let section = TaskDetailSections.init(rawValue: indexPath.section)
		
		switch section {
			case .note:
				if (itemsInSection == indexPath.row) {
					print("last note")
				}
			case .photos:
				if (itemsInSection == indexPath.row) {
					// Add Photo
					//https://nemecek.be/blog/30/checking-out-the-new-phpickerviewcontroller-in-ios-14-to-select-photos-or-videos
					self.presentCameraOptions()
				} else {
					// Show existing photo saved inside Core Data
					let photoCell = cell as! TaskDetailPhotoCell
					guard let photoItem = photoCell.item else { return }
					self.coordinator.showPhoto(item: photoItem)
				}
			case .title:
				() // do nothing
			case .none:
				()
		}
	}
}

/*

	MARK: - Fetched Results Controller

*/

extension TaskDetailViewController: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
		guard let mainFetcher = mainFetcher else { return }
		viewModel.updateSnapshot()
	}
}
