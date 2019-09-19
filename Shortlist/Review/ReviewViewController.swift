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
    
    var coordinator: ReviewCoordinator?
    
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
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .green
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return button
    }()
    


    lazy var reviewHeader: UIView = {
        let view = ReviewHeader(date: Calendar.current.yesterday(), viewModel: self.viewModel!)
        return view
    }()
    
    init(persistentContainer: PersistentContainer, coordinator: ReviewCoordinator, viewModel: ReviewViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDoneButton))
        
        tableView.register(ReviewCell.self, forCellReuseIdentifier: viewModel?.reviewCellId ?? "ReviewCellId")
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
        doneButton.anchorView(top: nil, bottom: view.bottomAnchor, leading: nil, trailing: nil, centerY: nil, centerX: view.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: -20.0, right: 0.0), size: CGSize(width: 80.0, height: 0.0))
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
    
    @objc
    func handleDoneButton() {
        // use coordinator
        self.dismiss(animated: false, completion: nil)
    }
}



extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dayObjects = fetchedResultsController.fetchedObjects else { return 0 }
        let first = dayObjects.first
        return first?.dayToTask?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel?.reviewCellId ?? "ReviewCellId", for: indexPath) as! ReviewCell
        cell.backgroundColor = .clear
		
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
        let cell = tableView.cellForRow(at: indexPath) as! ReviewCell
        guard let task = cell.task else {
            return
        }

        task.carryOver = !task.carryOver
//        if task.carryOver {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
		
		
//        tableView.deselectRow(at: indexPath, animated: true)

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
        
    }
}
