//
//  ReviewViewController.swift
//  Five
//
//  Created by Mark Wong on 22/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

// A Review of the day before.
// It shows incomplete / complete tasks
// Allows to carry over tasks to today.
class ReviewViewController: UIViewController {
 	
	var onDoneBlock: (() -> Void)? = nil
	
    private weak var persistentContainer: PersistentContainer?

    private var viewModel: ReviewViewModel?
    
    private var coordinator: ReviewCoordinator?
    	
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Day> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "createdAt == %@", argumentArray: [Calendar.current.yesterday()])
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.persistentContainer?.viewContext ?? nil)!, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.estimatedRowHeight = viewModel?.cellHeight ?? 100.0
        view.translatesAutoresizingMaskIntoConstraints = false
		view.allowsMultipleSelection = true
        return view
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
        button.setTitle("Done", for: .normal)
		button.setTitleColor(Theme.Button.textColor, for: .normal)
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()
	
	// determines whether the review was brought up automatically or manually displayed via the settings menu. This is also used to force an update to the global task count as we only want to update the value once per day
	private var automatedDisplay: Bool = false

    
	init(persistentContainer: PersistentContainer, coordinator: ReviewCoordinator, viewModel: ReviewViewModel, automatedDisplay: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
        self.coordinator = coordinator
		self.automatedDisplay = automatedDisplay
    }
    
    required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		tableView.updateHeaderViewHeight()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		onDoneBlock?()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = Theme.GeneralView.background
		navigationItem.prompt = "Select tasks to repeat today"
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDoneButton))
		
		// LOAD DATA
        loadData()
		
		// set up alarms for next 3 days, including today if it hasn't been set already
		prepareEveningAlarms()
		
		let reviewHeader = ReviewHeader(date: Calendar.current.yesterday(), viewModel: self.viewModel!)
		tableView.tableHeaderView = reviewHeader
		reviewHeader.setNeedsLayout()
		reviewHeader.layoutIfNeeded()
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
		tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        doneButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -60.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
		
		// IAP
		grabTipsProducts()
		
		// set accolade
		guard let _viewModel = viewModel else { return }
		guard let _day = _viewModel.dayEntity else {
			return
		}
		guard let _persistentContainer = persistentContainer else { return }
		
		_viewModel.resolvePriorityCount(persistentContainer: _persistentContainer)
		_viewModel.registerCells(tableView: tableView)
		let accolade = _viewModel.resolveAccolade()
		_viewModel.dayEntity?.dayToStats?.accolade = accolade
		persistentContainer?.saveContext()
		if (_day.dayToStats?.accolade == nil) {
			let accolade = _viewModel.resolveAccolade()
			_viewModel.dayEntity?.dayToStats?.accolade = accolade
			
			reviewHeader.updateAccoladeLabel(accolade)
		} else {
			reviewHeader.updateAccoladeLabel(_day.dayToStats?.accolade ?? "Unknown Accolade")
		}

		// upload total tasks completed
		if (automatedDisplay) {
			let fbs = FirebaseService(dataBaseUrl: nil)
			fbs.sendTotalCompletedTasks(amount: Int(_day.dayToStats?.totalCompleted ?? 0)) {
				
			}
		}
    }
	
	func prepareEveningAlarms() {
		for days in 0...3 {
			let now = Date().localDate()
			let eveningInFuture = Date().eveningTime(daysAfter: days)
			let delta = now.timeIntervalSince(eveningInFuture)
			
			if (delta >= 0) {
				LocalNotificationsService.shared.removePendingNotification(dateIdentifier: eveningInFuture)
				LocalNotificationsService.shared.addReminderNotification(dateIdentifier: eveningInFuture, notificationContent: [LocalNotificationKeys.Title : "Daily Evening Reminder", .Body : "Evening Reminder"], timeRemaining: delta)
			}
		}
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadData() {
        guard let _persistentContainer = persistentContainer else { return }
		guard let _viewModel = viewModel else { return }
        let _yesterday = _viewModel.targetDate
        
        
        var dayObject: Day? = _persistentContainer.fetchDayManagedObject(forDate: _yesterday)
        
        if (dayObject == nil) {
			dayObject = Day(context: _persistentContainer.viewContext)
			dayObject?.createNewDay(date: Calendar.current.yesterday())
            _persistentContainer.saveContext()
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch (let err) {
			coordinator?.showAlertBox("Unable to load data - \(err)")
        }
        
        _viewModel.dayEntity = dayObject
        if (_viewModel.dayEntity != nil) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
	//update color for buttons
    @objc
    func handleDoneButton() {
		copyMarkedTasks()
		
		//save to core data
		guard let pc = persistentContainer else { return }
		pc.saveContext()
		
		//dismiss view
		coordinator?.dimissFromMainViewController(persistentContainer)
    }
	
    func grabTipsProducts() {
        
        IAPProducts.tipStore.requestProducts { [weak self](success, products) in
            
            guard let self = self else { return }
            
            if (success) {
                guard let products = products else { return }
                self.viewModel?.tipProducts = products
                //update buttons
                self.updateTipButtons()
            } else {
                // requires internet access
            }
        }
    }
	
    func updateTipButtons() {
		guard let _viewModel = viewModel else { return }
        guard let tipProductArr = _viewModel.tipProducts else { return } //tips are sorted with didSet observer
        let buttonArr = viewModel?.buttonArr
        if (buttonArr!.count == tipProductArr.count) {
            for (index, button) in buttonArr!.enumerated() {
                SettingsHeader.priceFormatter.locale = tipProductArr[index].priceLocale
                let price = SettingsHeader.priceFormatter.string(from: tipProductArr[index].price)
                DispatchQueue.main.async {
                    button.setAttributedTitle(NSAttributedString(string: "\(tipProductArr[index].localizedTitle) \(price!)", attributes: _viewModel.attributes), for: .normal)
                }

                button.product = tipProductArr[index]
                button.buyButtonHandler = { product in
                    IAPProducts.tipStore.buyProduct(product)
                }
            }
        }
    }
	
	// marked tasks are placed inside the carryOverTaskObjectsArr
	func copyMarkedTasks() {
		guard let viewModel = viewModel else { return }
		guard let pc = persistentContainer else { return }
		let today: Day = pc.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		
		for (_, task) in viewModel.carryOverTaskObjectsArr {
			let copiedTask = Task(context: pc.viewContext)
			let resetReminder = Date() // reminder is reset because we don't know exactly when the user will copy an older task
			let redact = task.redactStyle
			
			copiedTask.create(context: pc.viewContext, taskName: task.name ?? "Error", categoryName: task.category ?? "General", createdAt: task.createdAt! as Date, reminderDate: resetReminder, priority: Int(task.priority), redact: Int(redact))
			today.addToDayToTask(copiedTask)
			today.dayToStats?.totalTasks = (today.dayToStats?.totalTasks ?? 0) + 1
		}
	}
	
	deinit {
		// make sure the protocol is subclassed by AnyObject and the Timer is invalidated/nil'ed
		coordinator?.cleanUpChildCoordinator()
	}
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayObjects = fetchedResultsController.fetchedObjects else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("No tasks to carry over!")
			return 0
		}
		
		if let day = dayObjects.first {
			// this check is true when the user did not use the app the day before. Because no task was set to the dayTotask relationship
			if (day.dayToTask?.count == 0) {
				tableView.setEmptyMessage("No tasks to carry over!")
				return 0
			} else {
				tableView.restoreBackgroundView()
				return day.dayToTask?.count ?? 0
			}
		} else {
			tableView.setEmptyMessage("No tasks to carry over!")
			return 0
		}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// handle the view model when it doesn't exist
		guard let viewModel = viewModel else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCellId", for: indexPath) as! ReviewCell
			cell.backgroundColor = .clear
			cell.carryTaskOver = { (task) in
				// print error view model does not exist for this closure
			}
			
			let dayObject = fetchedResultsController.fetchedObjects?.first
			let set = dayObject?.dayToTask as? Set<Task>
			if (!set!.isEmpty) {
				let sortedSet = set?.sorted(by: { (taskA, taskB) -> Bool in
					return taskA.priority < taskB.priority
				})
				cell.task = sortedSet?[indexPath.row]
			} else {
				cell.task = nil
			}
			return cell
		}
		
		// when the view model does exist we proceed at normal
		let cell = viewModel.tableViewCellFor(tableView: tableView, indexPath: indexPath)
		
		// closure to handle tasks that will be carried over to the the following day
		cell.carryTaskOver = { (task) in
			viewModel.handleCarryOver(task: task, cell: cell)
		}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let _viewModel = viewModel else { return }

		let cell = _viewModel.tableCellAt(tableView: tableView, indexPath: indexPath)
				
		_viewModel.checkPriority(persistentContainer: persistentContainer, task: cell.task) { (arg0) in
			
			let (threshold, status) = arg0
			// selectedState copies task in didSet method
			cell.selectedState = !cell.selectedState
			switch threshold {
				case .Exceeded:
					cell.selectedState = !cell.selectedState
					coordinator?.showAlertBox("Please update your limit from [Settings -> Priority Limit] or remove a \(status) priority task from today's schedule.")
				case .WithinLimit:
					persistentContainer?.saveContext() // save on done
			}
			persistentContainer?.saveContext() // save on done
		}
		
    }
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let _viewModel = viewModel else { return }
		let cell = _viewModel.tableCellAt(tableView: tableView, indexPath: indexPath)
		cell.selectedState = !cell.selectedState
		persistentContainer?.saveContext() // save on done
	}
	
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ReviewViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        do {
            try fetchedResultsController.performFetch()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch (_) {
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //
    }
}
