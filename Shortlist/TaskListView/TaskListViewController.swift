//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskListViewController: UICollectionViewController {
    fileprivate let className: String = String(describing: TaskListViewController.self)
    
    private var viewModel: TaskListViewModel? = nil
    
    private var longPressGesture: UILongPressGestureRecognizer!

    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewListLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        // Initialize the long press gesture recognizer
         longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
         longPressGesture.minimumPressDuration = 0.5 // Adjust as needed
         longPressGesture.delegate = self
        collectionView.addGestureRecognizer(longPressGesture)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        self.collectionView.backgroundColor = .yellow
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        //Datasource
        guard let viewModel = viewModel else { 
            print("\(className): View model not initialised")
            return }
        viewModel.configureDatasource(view: collectionView)
    }
    
    @objc func handleSettings() {
        
    }
    
    @objc func handleTap() {
        
        guard let viewModel = viewModel else { return }
        /// stop editing current cell
        viewModel.resignCurrentCell()
        
        /// add new task
        let _ = viewModel.createTask {
            let cell = viewModel.getLastCell(collectionView: self.collectionView)
            cell.focusText()
        }
        
        
    }
    
    
    deinit {
        viewModel = nil
    }
}
