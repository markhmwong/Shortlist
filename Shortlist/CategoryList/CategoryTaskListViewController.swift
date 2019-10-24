//
//  File.swift
//  Shortlist
//
//  Created by Mark Wong on 18/10/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class CategoryTaskListViewController: UIViewController {
	
	var persistentContainer: PersistentContainer?
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(persistentContainer: PersistentContainer) {
		self.persistentContainer = persistentContainer
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.black
	}
}
