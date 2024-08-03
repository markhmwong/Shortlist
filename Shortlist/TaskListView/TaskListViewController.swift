//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UICollectionViewController, UIGestureRecognizerDelegate, Refreshable {
    func refresh(item: SLTask) {
        performFetch()
        guard let viewModel else { return }
        viewModel.refreshDatasource(fetchedResultsController: fetchedResultsController)
    }
    
    fileprivate let className: String = String(describing: TaskListViewController.self)
    
    private var viewModel: TaskListViewModel? = nil
    
    private var longPressGesture: UILongPressGestureRecognizer!

	private var coordinator: TaskListCoordinator? = nil
    
    var fetchedResultsController: NSFetchedResultsController<SLTask>!

    init(viewModel: TaskListViewModel, coordinator: TaskListCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(itemSpace: .init(top: 0, leading: 5, bottom: 0, trailing: 5), groupSpacing: .zero))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add tap gesture recognizer
        _ = UITapGestureRecognizer(target: self, action: #selector(handleTap))
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
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddTask)),
            UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDeleteTask))
        ]
        //Datasource
        guard let viewModel else {
            print("\(className): View model not initialised")
            return }
		
        viewModel.createMultipleMockTasks()
        configureFetchedResultsController()
        performFetch()
        viewModel.configureDatasource(view: collectionView)
        viewModel.updateSnapshot(fetchedResultsController: fetchedResultsController)
    }
    
    @objc func handleSettings() {
        print("to do settings")
    }
    
    @objc func handleDeleteTask() {
        /// Deletes ALL tasks for quick testing
        guard let viewModel else { return }
        viewModel.deleteAllTasks()
        do {
            fetchedResultsController.managedObjectContext.refreshAllObjects()
            try fetchedResultsController.performFetch()
        } catch let err {
            print("err \(err)")
        }
        viewModel.updateSnapshot(fetchedResultsController: fetchedResultsController)
    }
    
    @objc func handleAddTask() {
        guard let viewModel else { return }
        if viewModel.taskLimitReached() {
            viewModel.createTask()
        } else {
            print("Pop up - Task Limit Reached")
        }
        
    }
	
	@objc func handleLongPress() {
		print("long press gesture on SLTask Cell")
		guard let viewModel = viewModel else { return }
		let cell = viewModel.getLastCell(collectionView: self.collectionView)
		cell.focusText()
	}
    
    @objc func handleTap() {
        
//        guard let viewModel else { return }
        /// stop editing current cell
//        viewModel.resignCurrentCell()
        
        /// add new task
//        let _ = viewModel.createTask {
//            let cell = viewModel.getLastCell(collectionView: self.collectionView)
//			cell.enableEditing()
//            cell.focusText()
//        }
    }
    
    private func configureFetchedResultsController(with statuses: [TaskStatus] = [.Incomplete, .Complete]) {
        let fetchRequest: NSFetchRequest<SLTask> = SLTask.fetchRequest()
        let statusValues = statuses.map { $0.rawValue }
        fetchRequest.predicate = NSPredicate(format: "taskToStatus.name IN %@", statusValues)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \SLTask.taskToStatus?.name, ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.moc!, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
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

extension TaskListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let viewModel else { return }
        viewModel.applySnapshot(fetchedResultsController: self.fetchedResultsController)
    }
}

extension TaskListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UICollectionViewFlowLayout.automaticSize
    }
}
