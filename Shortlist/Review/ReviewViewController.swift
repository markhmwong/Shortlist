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
 
    var persistentContainer: PersistentContainer?

    var viewModel: ReviewViewModel?
    
    var reviewCoordinator: ReviewCoordinator?
    
//	var settingsCoordinator: SettingsCoordinator?
	
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
    
    lazy var tableView: UITableView = {
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
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Theme.Button.cornerRadius
		button.backgroundColor = Theme.Button.backgroundColor
        button.setTitle("Done", for: .normal)
		button.setTitleColor(Theme.Button.textColor, for: .normal)
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()

    lazy var reviewHeader: UIView = {
        let view = ReviewHeader(date: Calendar.current.yesterday(), viewModel: self.viewModel!)
        return view
    }()
	
	let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!]
    
    init(persistentContainer: PersistentContainer, coordinator: ReviewCoordinator, viewModel: ReviewViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
        self.reviewCoordinator = coordinator
    }
	
//    init(persistentContainer: PersistentContainer, coordinator: SettingsCoordinator, viewModel: ReviewViewModel) {
//        super.init(nibName: nil, bundle: nil)
//        self.persistentContainer = persistentContainer
//        self.viewModel = viewModel
//        self.settingsCoordinator = coordinator
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        loadData()
        //        CoreDataManager.shared.deleteAllRecordsIn(entity: Day.self)
        tableView.reloadData()
        // Do any additional setup after loading the view.
        tableView.tableHeaderView = reviewHeader
        reviewHeader.setNeedsLayout()
        reviewHeader.layoutIfNeeded()
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
		navigationItem.prompt = "Select tasks to repeat today"
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDoneButton))
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: viewModel?.reviewCellId ?? "ReviewCellId")
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        doneButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
		
		grabTipsProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadData() {
        guard let persistentContainer = persistentContainer else { return }
        guard let yesterday = viewModel?.targetDate else { return }
        guard let viewModel = viewModel else { return }
        
        var dayObject: Day? = persistentContainer.fetchDayManagedObject(forDate: yesterday)
        
        if (dayObject == nil) {
            dayObject = Day(context: persistentContainer.viewContext)
            dayObject?.createdAt = Calendar.current.today() as NSDate
            dayObject?.taskLimit = 5 //default limit
            dayObject?.month = Calendar.current.monthToInt() // Stats
            dayObject?.year = Calendar.current.yearToInt() // Stats
            dayObject?.day = Int16(Calendar.current.todayToInt()) // Stats
            // possible loading graphic todo
            persistentContainer.saveContext()
        }
        
        do {
            try fetchedResultsController.performFetch()
        } catch (let err) {
            print("Unable to perform fetch \(err)")
        }
        
        viewModel.dayEntity = dayObject
        if (viewModel.dayEntity != nil) {
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
		persistentContainer?.saveContext()
		
		//dismiss view
		reviewCoordinator?.dimiss(persistentContainer)
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
        guard let tipProductArr = self.viewModel?.tipProducts else { return } //tips are sorted with didSet observer
        let buttonArr = viewModel?.buttonArr
        if (buttonArr!.count == tipProductArr.count) {
            for (index, button) in buttonArr!.enumerated() {
                SettingsHeader.priceFormatter.locale = tipProductArr[index].priceLocale
                let price = SettingsHeader.priceFormatter.string(from: tipProductArr[index].price)
                DispatchQueue.main.async {
                    button.setAttributedTitle(NSAttributedString(string: "\(tipProductArr[index].localizedTitle) \(price!)", attributes: self.attributes), for: .normal)
                }

                button.product = tipProductArr[index]
                button.buyButtonHandler = { product in
                    IAPProducts.tipStore.buyProduct(product)
                }
            }
        }
    }
	
	func copyMarkedTasks() {
		guard let viewModel = viewModel else { return }
		let today: Day = persistentContainer?.fetchDayEntity(forDate: Calendar.current.today()) as! Day
		// create new day here, incase the app is running in the back ground and a new day hasn't been created in the interim
		
		for (_, task) in viewModel.carryOverTaskObjectsArr {
			today.addToDayToTask(task)
		}
		
	}
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayObjects = fetchedResultsController.fetchedObjects else { return 0 }
        let first = dayObjects.first
        return first?.dayToTask?.count ?? 0
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
		let cell = viewModel.tableCellFor(tableView: tableView, indexPath: indexPath)
		
		// closure to handle tasks that will be carried over to the the following day
		cell.carryTaskOver = { (task) in
			viewModel.handleCarryOver(task: task, cell: cell)
		}
		
        let dayObject = fetchedResultsController.fetchedObjects?.first
        let set = dayObject?.dayToTask as? Set<Task>
        if (!set!.isEmpty) {
            let sortedSet = set?.sorted(by: { (taskA, taskB) -> Bool in
                return taskA.priority < taskB.priority
            })
            cell.task = sortedSet?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let viewModel = viewModel else { return }
		let cell = viewModel.tableCellAt(tableView: tableView, indexPath: indexPath)
		cell.selectedState = !cell.selectedState
		persistentContainer?.saveContext() // save on done
    }
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let viewModel = viewModel else { return }
		let cell = viewModel.tableCellAt(tableView: tableView, indexPath: indexPath)
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
        } catch (let err) {
            print("\(err)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //
    }
}