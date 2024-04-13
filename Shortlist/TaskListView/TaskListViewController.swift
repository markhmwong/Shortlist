//
//  MainViewControllerCollectionView.swift
//  Shortlist
//
//  Created by Mark Wong on 23/7/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class TaskListViewController: UICollectionViewController {
 
    private weak var viewModel: TaskListViewModel? = nil
    
    init(viewModel: TaskListViewModel) {
        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
        super.init(collectionViewLayout: UICollectionViewLayout().createCollectionViewSectionHeaderLayout(itemSpace: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0), groupSpacing: NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        self.collectionView.backgroundColor = .yellow
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(handleSettings))
        //Datasource
        guard let viewModel = viewModel else { return }
        viewModel.configureDatasource(view: collectionView)
    }
    
    @objc func handleSettings() {
        
    }
    
    deinit {
        viewModel = nil
    }
}
