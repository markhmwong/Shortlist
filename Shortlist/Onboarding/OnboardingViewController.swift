//
//  OnboardingViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 7/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
	
	var viewModel: OnboardingViewModel? = nil
	
	weak var coordinator: OnboardingCoordinator? = nil
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		var view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.dataSource = self
		view.delegate = self
		view.isPagingEnabled = true
		view.backgroundColor = Theme.GeneralView.background
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	lazy var pageControl: UIPageControl = {
		let pageControl = UIPageControl()
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		pageControl.tintColor = Theme.Font.DefaultColor
		pageControl.currentPage = 0
		pageControl.numberOfPages = 5
		pageControl.addTarget(self, action: #selector(handlePage), for: .touchUpInside)
		return pageControl
	}()
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init(viewModel: OnboardingViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		guard let _viewModel = viewModel else { return }
		view.backgroundColor = Theme.GeneralView.background
		_viewModel.registerCells(collectionView)
		view.addSubview(collectionView)
		view.addSubview(pageControl)
		
		collectionView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0), size: .zero)
		pageControl.anchorView(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0) )
	}
	
	@objc func handlePage() {
		collectionView.scrollToItem(at: IndexPath(item: pageControl.currentPage, section: 0), at: .centeredHorizontally, animated: true)
	}
	
	deinit {
		coordinator?.cleanUpChildCoordinator()
	}
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		for cell in collectionView.visibleCells {
			let indexPath = collectionView.indexPath(for: cell)
			pageControl.currentPage = indexPath?.row ?? 0
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return CGFloat.zero
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return view.safeAreaLayoutGuide.layoutFrame.size
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let _viewModel = viewModel else { return 1 }
		return _viewModel.dataSource.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let _viewModel = viewModel else {
			return UICollectionViewCell()
		}
		return _viewModel.cellForCollectionView(collectionView, indexPath: indexPath, coordinator: coordinator ?? nil)
	}
}
