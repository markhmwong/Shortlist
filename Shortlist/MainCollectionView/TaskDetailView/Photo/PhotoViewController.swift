//
//  PhotoViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 25/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
	
	//imageview
	//scrollview
	
	private var imageView: ImageScrollView!
	
	private lazy var scrollView: UIScrollView = {
		let view = UIScrollView()
		view.maximumZoomScale = 6.0
		view.minimumZoomScale = 0.1
		view.zoomScale = 1.0
		view.delegate = self
		view.contentMode = .scaleAspectFill
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private var item: PhotoItem
	
	private var persistentContainer: PersistentContainer
	
	init(item: PhotoItem, persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		self.item = item
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = ThemeV2.Background
		let share = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(handleShare))
		let delete = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(handleDelete))
		navigationItem.rightBarButtonItems = [ delete, share ]
		guard let photo = item.photo else {
			// to do place holder
			return
		}
		imageView = ImageScrollView(frame: view.bounds)
		view.addSubview(imageView)
		
		scrollView.backgroundColor = .clear
		
		scrollView.addSubview(imageView)
		view.addSubview(scrollView)
		
		imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		
		scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		imageView.set(image: UIImage(data: photo)!)
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	/*
	
		MARK: - Handler Methods
	
	*/
	@objc func handleShare() {
		guard let photo = item.photo, let image = UIImage(data: photo) else {
			// to do place holder
			return
		}

		let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = self.view
		activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook ]
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	@objc func handleDelete() {
		persistentContainer.deletePhoto(withId: item.id)
		self.dismiss(animated: true) { }
	}
}
