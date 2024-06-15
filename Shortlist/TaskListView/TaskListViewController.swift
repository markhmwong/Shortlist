//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskListViewController: UICollectionViewController, UIGestureRecognizerDelegate, Refreshable {
    func refresh(item: SLTask) {
        guard let vm = viewModel else { return }
        vm.refreshDatasource(with: item)
    }
    
    fileprivate let className: String = String(describing: TaskListViewController.self)
    
    private var viewModel: TaskListViewModel? = nil
    
    private var longPressGesture: UILongPressGestureRecognizer!

	private var coordinator: TaskListCoordinator? = nil
    
	init(viewModel: TaskListViewModel, coordinator: TaskListCoordinator) {
        self.viewModel = viewModel
		self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewListLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        view.addGestureRecognizer(tapGesture)
        
        // Initialize the long press gesture recognizer
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.7
		longPressGesture.delegate = self
        collectionView.addGestureRecognizer(longPressGesture)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        //Datasource
        guard let viewModel = viewModel else { 
            print("\(className): View model not initialised")
            return }
		
        viewModel.createMultipleMockTasks()
        viewModel.configureDatasource(view: collectionView)
    }
    
    @objc func handleSettings() {
        
    }
	
	@objc func handleLongPress() {
		print("long press gesture on SLTask Cell")
		guard let viewModel = viewModel else { return }
		let cell = viewModel.getLastCell(collectionView: self.collectionView)
		cell.focusText()
	}
    
    @objc func handleTap() {
        
        guard let viewModel = viewModel else { return }
        /// stop editing current cell
//        viewModel.resignCurrentCell()
        
        /// add new task
//        let _ = viewModel.createTask {
//            let cell = viewModel.getLastCell(collectionView: self.collectionView)
//			cell.enableEditing()
//            cell.focusText()
//        }
    }
    
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! SLTaskCell
		guard let coordinator = coordinator, let item = cell._item else {
			print("task item not found to proceed to task details view")
			return
		}
        coordinator.presentTaskDetails(item: item)
	}
    
    deinit {
        viewModel = nil
		coordinator = nil
    }
}
