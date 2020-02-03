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
        view.textColor = UIColor.white
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
	The kind of app that doesn't allow you to continue adding tasks you won't complete anyway.
	//need rewrite
	Ever since the advent of mobile devices inbuilt with large capacities; applications have exploited their generous storage space. I believe we've taken this for granted, made things harder to focus, overwhelmed and less motivated to finish our work. The "openess" we take for granted has geared ourselves towards no direction to the method we complete our tasks; there is no system employed to guide our day.
	
	If you're an avid and master at productivity, this app may not be for you, but I encourage you to take a look at your own reminder list and look at the tasks that are lingering from the week/month/year before. It certainly would leave a guilty feeling inside as the task slowly fades far into the past. This app intends to reduce the notion of revisitng old tasks, keep track of incomplete tasks and completed tasks and while focusing on the day's tasks ahead.\n
	
	At the end of the day we would rather see 5/5 rather than 5/10 right? It's not only encouraging but motivating, especially for those who struggle to find focus this helps narrow their field of vision (so to speak). Lingering tasks will always be left in the attic collecting dust, and dusting it off may sets you back. Do what you can and only do that for the day to finish on a high note and continue tomorrow.\n
	
	Privacy.\n
	To be completed. May use Google Analytics to monitor app usage
	
	Bugs.\n
	Please report any bugs to hello@whizbangapps.xyz
	
	Contact.\n
	Twitter: @markhmwong\nWebsite: https://www.whizbangapps.xyz/\(appName)\n
	
	Credits.\n
	Onboarding graphics authors: Freepik, Pause08, Becris, srip, zlatko-najdenovski, itim2101 @ www.flaticon.com and icons8.com
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
        view.backgroundColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleBack), imageName: "Back", height: self.topBarHeight / 2)
        
        contact.attributedText = NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.DefaultColor, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
        view.addSubview(contact)
        contact.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc
    func handleBack() {
		coordinator.dismiss()
    }
}
