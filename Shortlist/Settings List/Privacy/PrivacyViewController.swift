//
//  PrivacyViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 6/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
	
	private lazy var privacyStatement: BaseLabel = {
		let label = BaseLabel()
		label.text = "Shortlist does not contain any code that allows sensitive data to be sent to any external entity, that I am aware or written myself. The photos and written data are yours and yours alone and are kept within the Apple Ecosystem (Apple Devices, iCloud etc)."
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.textAlignment = .center
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Privacy"
		view.backgroundColor = ThemeV2.Background
		
		view.addSubview(privacyStatement)
		privacyStatement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		privacyStatement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		privacyStatement.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
	}
}
