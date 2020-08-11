//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class MainViewControllerWithCollectionView: UIViewController {
	
	// public variables
	var coordinator: MainCoordinator?
	
	// private variables
	private var viewModel: MainViewModelWithCollectionView! = nil
	
	private var collectionView: BaseCollectionView! = nil
	
	private var persistentContainer: PersistentContainer! = nil
	
	init(viewModel: MainViewModelWithCollectionView, persistentContainer: PersistentContainer?) {
		self.viewModel = viewModel
		self.persistentContainer = persistentContainer
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.transparent()
		navigationItem.leftBarButtonItem = UIBarButtonItem().optionsButton(target: self, action: #selector(handleSettings))
		
		// make collectionview
		createCollectionView()

		// prep data
		viewModel.configureDataSource(collectionView: collectionView)
	}
	
	// collectionview
	func createCollectionView() {
		collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: viewModel.createCollectionViewLayout())
		collectionView.delegate = self
		view.addSubview(collectionView)
		
		// layout
		collectionView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
	}
	
	func handleCamera() {
		let imagePicker = UIImagePickerController()

		imagePicker.delegate = self
		imagePicker.sourceType = .camera
		imagePicker.allowsEditing = false
		imagePicker.cameraCaptureMode = .photo
		imagePicker.cameraDevice = .rear
		imagePicker.cameraFlashMode = .auto
		imagePicker.showsCameraControls = true
		self.present(imagePicker, animated: true, completion: nil)
	}
	
	@objc func handleSettings() {
		coordinator?.showSettings(persistentContainer)
	}
}

extension MainViewControllerWithCollectionView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	// nothing
}

extension MainViewControllerWithCollectionView: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let item = viewModel.itemForSelection(indexPath: indexPath)
		let taskCoordinator = TaskDetailCoordinator(navigationController: coordinator?.navigationController ?? UINavigationController(), task: item)
		taskCoordinator.start(nil)
	}
	
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
			
			// from camera or camera roll
			let camera = UIAction(title: "Attach Photo", image: UIImage(systemName: "camera.fill"), identifier: UIAction.Identifier(rawValue: "camera")) {_ in
				self.handleCamera()
			}
			
			let complete = UIAction(title: "Mark as Complete", image: UIImage(systemName: "checkmark.circle.fill"), identifier: UIAction.Identifier(rawValue: "complete")) {_ in
				print("complete")
			}
			
			let open = UIAction(title: "View Task", image: UIImage(systemName: "eye.fill"), identifier: UIAction.Identifier(rawValue: "open"), discoverabilityTitle: nil, attributes: [], state: .off, handler: {action in
				print("open")
			})
			
			let delete = UIAction(title: "Delete Task", image: UIImage(systemName: "minus.circle.fill"), identifier: UIAction.Identifier(rawValue: "delete"), discoverabilityTitle: nil, attributes: .destructive, state: .off, handler: {action in
				print("delete ")
			})
						
			
			return UIMenu(title: "Task Menu", image: nil, identifier: nil, children: [open, camera, complete, delete])
		}
		
		return config
	}
	
}