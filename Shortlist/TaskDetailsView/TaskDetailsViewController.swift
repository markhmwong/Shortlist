//
//  TaskDetailsView.swift
//  Shortlist
//
//  Created by Mark on 10/5/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit



class TaskDetailsViewController: UIViewController {
	
	var viewModel: TaskDetailsViewModel
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.text = "Title Placeholder"
		return label
	}()
	
	init(viewModel: TaskDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.white
		
		view.addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor, constant: 0),
			titleLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
		])
		
		
		viewModel.item.bind { item in
			self.titleLabel.text = item.name
		}
	}
	
	
}
