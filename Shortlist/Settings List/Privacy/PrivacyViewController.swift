//
//  PrivacyViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 6/9/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
	
	private lazy var privacyTitle: BaseLabel = {
		let label = BaseLabel()
		label.text = "Privacy."
		label.font = UIFont.preferredFont(forTextStyle: .headline).with(weight: .bold)
		return label
	}()
	
	private lazy var privacyStatement: BaseLabel = {
		let label = BaseLabel()
		label.text = "Shortlist does not contain any code that allows sensitive data to be sent to any external entity, that I am aware of or have written myself with the intention of spreading sensitive data. The aim is to keep data within your bubble whether locally or through the Apple's cloud servers. The photos and written data are yours and yours alone and are kept within the Apple Ecosystem (Apple Devices, iCloud etc). I do not track any sensitive data."
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.textAlignment = .left
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = ""
		view.backgroundColor = ThemeV2.Background
		
		view.addSubview(privacyStatement)
		view.addSubview(privacyTitle)
		
		privacyTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		privacyTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
		privacyStatement.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		privacyStatement.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		privacyStatement.topAnchor.constraint(equalTo: privacyTitle.bottomAnchor, constant: 10).isActive = true
	}
}
