//
//  ContactViewController.swift
//  Five
//
//  Created by Mark Wong on 7/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

	var coordinator: AboutCoordinator
	
    lazy var contact: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
		view.textColor = Theme.Font.DefaultColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelectable = false
        view.isEditable = false
        return view
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private let appName = AppMetaData.name
    
    private let appVersion = AppMetaData.version
    
    private let appBuild = AppMetaData.build
    
    lazy var details = """
	Thanks for using \(appName) v\(appVersion ?? " unknown"), build \(appBuild ?? "unknown").\n
	\n
	The daily finite To Do List.
	
	
	
	Privacy.\n
	This app uses Firebase to track Worldwide task tallys. Task details are not sent to the server, only a count of the total tallies is tracked.
	
	Bugs.\n
	Please report any bugs to hello@whizbangapps.xyz
	
	Contact.\n
	Twitter: @markhmwong\nWebsite: https://www.whizbangapps.xyz/\(appName)\n
	
	Credits.\n
	Onboarding assets authors: Freepik, Pause08, Becris, srip, zlatko-najdenovski, itim2101 @ www.flaticon.com and icons8.com
	"""
    
	init(coordinator: AboutCoordinator) {
		self.coordinator = coordinator
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.title = "About"
		view.backgroundColor = Theme.GeneralView.background
		navigationItem.leftBarButtonItem = UIBarButtonItem().backButton(target: self, action: #selector(handleDismiss))
        
        contact.attributedText = NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
        view.addSubview(contact)
        contact.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc
    func handleDismiss() {
		coordinator.dismiss()
    }
	
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(SettingsNavigationObserverKey.ReturnFromInfo.rawValue), object: self)
	}
	
	deinit {
		coordinator.cleanUpChildCoordinator()
	}
}
