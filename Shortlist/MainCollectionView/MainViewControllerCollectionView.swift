//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData
import EventKit

protocol FetchedDataProtocol {
	associatedtype T: NSFetchRequestResult
	var controller: NSFetchedResultsController<T> { get }
}

struct MainFetcher<T: NSFetchRequestResult>: FetchedDataProtocol {
	var controller: NSFetchedResultsController<T>
	
	init(controller: NSFetchedResultsController<T>) {
		self.controller = controller
	}
	
	func initFetchedObjects() {
		do {
			try self.controller.performFetch()
		} catch(let err) {
			print("\(err)")
		}
	}
	
	// Objects requested by the origina descriptors and predicates formed in the fetchedResultsController
	func fetchRequestedObjects() -> [T]? {
		return controller.fetchedObjects
	}
}

class MainViewControllerWithCollectionView: UIViewController, UICollectionViewDelegate {
    let eventStore = EKEventStore()
	// Core Data
	private lazy var fetchedResultsController: NSFetchedResultsController<Day> = {
		// Create Fetch Request
		let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
		
		// Configure Fetch Request
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
		fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [Calendar.current.today()])
		
		// Create Fetched Results Controller
		let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
		
		// Configure Fetched Results Controller
		fetchedResultsController.delegate = self
        
		return fetchedResultsController
	}()
	
	// Core Data
	private var mainFetcher: MainFetcher<Day>! = nil

	// public variables
	var coordinator: MainCoordinator?
	
	// private variables
	private var viewModel: MainViewModelWithCollectionView! = nil
		
	private var persistentContainer: PersistentContainer
	
    var collectionView: UICollectionView! = nil
    
	private lazy var createTaskButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = UIColor.clear
		let config = UIImage.SymbolConfiguration(font: ThemeV2.CellProperties.LargeBoldFont)
		let image = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
		button.setImage(image, for: .normal)
        button.tintColor = .systemMint
		button.addTarget(self, action: #selector(handleCreateTask), for: .touchDown)
		return button
	}()
	
	init(viewModel: MainViewModelWithCollectionView, persistentContainer: PersistentContainer) {
		self.viewModel = viewModel
		self.persistentContainer = persistentContainer
        super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout().createCollectionViewHorizontalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = ThemeV2.Background
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
     }
	
	override func viewDidLoad() {
		super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = "Today"
        navigationItem.leftBarButtonItem = UIBarButtonItem().optionsButton(target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItems = [ UIBarButtonItem().donateButton(target: self, action: #selector(handleDonation)) ]
        self.configureHierarchy()

		self.mainFetcher = MainFetcher(controller: fetchedResultsController)
		mainFetcher.initFetchedObjects()
        
		// prep mock data
//		viewModel.addMockData(persistentContainer: persistentContainer)
//		viewModel.createMockStatisticalData(persistentContainer: persistentContainer)

        viewModel.configureDataSource(collectionView: collectionView, resultsController: mainFetcher, button: createTaskButton)
		
		//create task button
		view.addSubview(createTaskButton)
		createTaskButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0).isActive = true
		createTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        
	}
    
	/*
	
		MARK: - Handlers Selectors
		
	*/
	@objc func handleCreateTask() {
        guard let c = coordinator, let d = viewModel.day else { return }
//        c.showCreateTask(persistentContainer, day: d)
        
        let calendars = eventStore.calendars(for: .event)

        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status) {
            case .notDetermined:
                requestAccessToCalendar()
            case .authorized:
            // Get the appropriate calendar.
            let currentDate = Calendar.current.today()
            let dateFormatter = DateFormatter()
            let calendar = Calendar(identifier: .gregorian)
            dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = calendar.timeZone
            dateFormatter.string(from:currentDate)
            let predicate = eventStore.predicateForEvents(withStart: Calendar.current.startOfDay(for: Date()), end: Calendar.current.endOfToday(), calendars: calendars)
                var events: [EKEvent]? = eventStore.events(matching: predicate)
                print(events)
                break
            case .restricted, .denied:
                requestAccessToCalendar()
                break
                
            }
	}
    
    func requestAccessToCalendar() {
        
        eventStore.requestAccess(to: EKEntityType.event) { (accessGranted, error) in
            
            
        }
        
    }
	
	@objc func handleDonation() {
		guard let c = coordinator else { return }
		c.showTipJar()
	}
	
	@objc func handleSettings() {
		guard let c = coordinator, let d = viewModel.day else { return }
        c.showSettings(persistentContainer, day: d)
	}
	
    // use permissionsservice class
	func biometrics(item: Task) {
		let context = LAContext()
		var error: NSError?

		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Identify yourself!"

			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
				[weak self] success, authenticationError in
				guard let self = self else { return }
				DispatchQueue.main.async {
					if success {
						guard let coordinator = self.coordinator else { return }
						coordinator.showTaskDetails(with: item, persistentContainer: self.persistentContainer)
					} else {
						// error
						context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, authenticationError) in
							print("numpad to do")
						}
					}
				}
			}
		} else {
			// path for no biometrics
		}
	}
}

// MARK: - Collection View Methods
extension MainViewControllerWithCollectionView {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let item: Task = viewModel.taskForSelection(indexPath: indexPath)
		
		switch item.redactionStyle() {
			case .none:
				guard let coordinator = coordinator else { return }
                coordinator.showTaskDetails(with: item, persistentContainer: self.persistentContainer)
			case .star, .highlight:
				guard let coordinator = coordinator else { return }
				coordinator.showTaskDetails(with: item, persistentContainer: self.persistentContainer)
				print("biometrics temporarily turned off")
			// run biometrics to request an unlock
				//temp biometrics is turned off
//				biometrics(item: item)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let object = self.viewModel.taskForSelection(indexPath: indexPath)

			// from camera or camera roll
			let camera = UIAction(title: "Attach Photo", image: UIImage(systemName: "camera.fill"), identifier: UIAction.Identifier(rawValue: "camera")) {_ in
//				self.handleCamera()
			}
			
			let complete = UIAction(title: "Mark as Complete", image: UIImage(systemName: "checkmark.circle.fill"), identifier: UIAction.Identifier(rawValue: "complete")) {_ in
                //because core data only detects if one object has been changed, this does not trigger the NSFetchedResultsController. Why? because the controller is currently observing the Task Object however the NSFetchedResultsController is observing the Day Object, so we'll update the dat with a new time stamp to trigger a change
                object.complete = !object.complete
                self.viewModel.day?.update()
                self.persistentContainer.saveContext()
			}
			
			let open = UIAction(title: "View Task", image: UIImage(systemName: "eye.fill"), identifier: UIAction.Identifier(rawValue: "open"), discoverabilityTitle: nil, attributes: [], state: .off, handler: {action in
                self.coordinator?.showTaskDetails(with: self.viewModel.taskForSelection(indexPath: indexPath), persistentContainer: self.persistentContainer)
			})
			
			let delete = UIAction(title: "Delete Task", image: UIImage(systemName: "minus.circle.fill"), identifier: UIAction.Identifier(rawValue: "delete"), discoverabilityTitle: nil, attributes: .destructive, state: .off, handler: {action in
                if let day = self.viewModel.day {
                    self.persistentContainer.deleteTask(in: day, with: object)
                }
			})

			return UIMenu(title: "Task Menu", image: nil, identifier: nil, children: [open, camera, complete, delete])
		}
		return config
	}
}

extension MainViewControllerWithCollectionView: NSFetchedResultsControllerDelegate {
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        viewModel.updateSnapshot()
	}
}
