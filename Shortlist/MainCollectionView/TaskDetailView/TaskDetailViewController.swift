//
//  TaskView.swift
//  Shortlist
//
//  Created by Mark Wong on 28/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import PhotosUI

class TaskDetailViewController: UIViewController, PHPickerViewControllerDelegate {

	private var itemProviders = [NSItemProvider]()
	
	private var viewModel: TaskDetailViewModel
	
	private var coordinator: TaskDetailCoordinator
	
	private lazy var collectionView: BaseCollectionView! = nil
	
	init(viewModel: TaskDetailViewModel, coordinator: TaskDetailCoordinator) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.transparent()
		
		createCollectionView()
		viewModel.configureDataSource(collectionView: collectionView)
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
	
	private func presentPicker(filter: PHPickerFilter) {
		var configuration = PHPickerConfiguration()
		configuration.filter = filter
		configuration.selectionLimit = 0
		
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = self
		present(picker, animated: true)
	}
	
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		dismiss(animated: true, completion: nil)
				guard !results.isEmpty else { return }
		//https://developer.apple.com/videos/play/wwdc2020/10652/
		print("to do - connect to core data. Take photo, select photo, save photo, save thumbnail and reference to original image")
		// connect it to core data to do
//		dismiss(animated: true) {
//			//
//		}
//		itemProviders = results.map(\.itemProvider)
//		let itemProvidersIterator = itemProviders.makeIterator()
		
//		if provider.canLoadObject(ofClass: UIImage.self) {
//			 provider.loadObject(ofClass: UIImage.self) { (image, error) in
//					 DispatchQueue.main.async {
//						 if let image = image as? UIImage {
//							  self.imageView.image = image
//						 }
//					 }
//			}
//		 }

	}
}

// MARK: - Collection View Delegate
extension TaskDetailViewController: UICollectionViewDelegate {
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
					print("last photo")
					//https://nemecek.be/blog/30/checking-out-the-new-phpickerviewcontroller-in-ios-14-to-select-photos-or-videos
					presentPicker(filter: PHPickerFilter.images)
				}
			case .title:
				() // do nothing
			case .none:
				()
		}
	}
}
