//
//  SelectCategoryViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 23/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData


extension SelectCategoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		do {
            try fetchedResultsController?.performFetch()
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

class SelectCategoryViewController: UIViewController {
	
	// fetchedresultscontroller
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<CategoryList>? = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<CategoryList> = CategoryList.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: (self.persistentContainer?.viewContext ?? nil)!, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = UIColor.black
		view.delegate = self
		view.dataSource = self
		view.estimatedRowHeight = 100.0
		view.rowHeight = UITableView.automaticDimension
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var inputContainer: UIView = {
		let view = UIView()
		view.alpha = 0.0
		view.backgroundColor = Theme.Cell.textFieldBackground
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private lazy var categoryInputTextView: UITextView = {
		let view = UITextView()
		view.delegate = self
		view.backgroundColor = Theme.Cell.textFieldBackground
        view.keyboardAppearance = UIKeyboardAppearance.dark
		view.keyboardType = UIKeyboardType.default
		view.isEditable = true
		view.isUserInteractionEnabled = true
		view.isSelectable = true
		view.isScrollEnabled = false
		view.returnKeyType = UIReturnKeyType.next
        view.textColor = Theme.Font.Color
		view.translatesAutoresizingMaskIntoConstraints = false
		view.attributedText = categoryNamePlaceholder
		return view
	}()
	
	let categoryNamePlaceholder: NSMutableAttributedString = NSMutableAttributedString(string: "New Category", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b2).value)!])
	
	var coordinator: SelectCategoryCoordinator?
	
	var viewModel: SelectCategoryViewModel?
	
	var persistentContainer: PersistentContainer?
	
	var bottomConstraint: NSLayoutConstraint?
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	init(_ persistentContainer: PersistentContainer?, coordinator: SelectCategoryCoordinator, viewModel: SelectCategoryViewModel) {
		self.persistentContainer = persistentContainer
		self.viewModel = viewModel
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let viewModel = viewModel else { return }
		keyboardNotifications()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDone))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))

		viewModel.tableViewRegisterCell(tableView)
		view.addSubview(tableView)
		view.addSubview(inputContainer)
		inputContainer.addSubview(categoryInputTextView)
		
		tableView.anchorView(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
		inputContainer.anchorView(top:nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		bottomConstraint = NSLayoutConstraint(item: inputContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
		view.addConstraint(bottomConstraint!)
		
		categoryInputTextView.anchorView(top: inputContainer.topAnchor, bottom: inputContainer.bottomAnchor, leading: inputContainer.leadingAnchor, trailing: inputContainer.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 0.0))
		
		categoryInputTextView.becomeFirstResponder() // to remove, for testing adding categories
		
		loadCategories()
	}
	
	private func loadCategories() {
        guard let persistentContainer = persistentContainer else { return }
		DispatchQueue.main.async {
			do {
				try self.fetchedResultsController?.performFetch()
				self.tableView.reloadData()
			} catch (let err) {
				print("Unable to perform fetch \(err)")
			}
		}
	}
	
	private func keyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc
	func handleDone() {
		coordinator?.dimiss(nil)
	}
	
	@objc
	func handleAdd() {
		categoryInputTextView.becomeFirstResponder()
	}
	
	@objc
	func handleKeyboardNotification(_ notification : Notification?) {
		
		if let info = notification?.userInfo {
			
			let isKeyboardShowing = notification?.name == UIResponder.keyboardWillShowNotification
			
			let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
			if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
				
				if (isKeyboardShowing) {
					inputContainer.alpha = 1.0
					bottomConstraint?.constant = -kbFrame.height
				} else {
					inputContainer.alpha = 0.0
					bottomConstraint?.constant = 0
				}
				
				UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseInOut, animations: {
					self.view.layoutIfNeeded()
				}) { (completed) in
					
				}
			}
		}
	}
}

extension SelectCategoryViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let categories = fetchedResultsController?.fetchedObjects else {
			tableView.separatorColor = .clear
			tableView.setEmptyMessage("Add a new category by selecting the top right button!")
			return 0
		}
		return categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCategoryCellId", for: indexPath)
			cell.textLabel?.text = "No Categories"
			cell.backgroundColor = UIColor.red
			cell.textLabel?.textColor = UIColor.white
			return cell
		}
		
		return viewModel.tableViewCell(tableView, indexPath: indexPath)
	}
	
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SelectCategoryViewController: UITextViewDelegate {
	
	// We're using this to dynamically adjust task name height when typing
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
			categoryInputTextView.sizeToFit()
            UIView.setAnimationsEnabled(true)
        }
    }
}
