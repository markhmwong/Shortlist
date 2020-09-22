//
//  ContactViewController.swift
//  Five
//
//  Created by Mark Wong on 7/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

	var coordinator: AboutCoordinator?
	
	private lazy var titleLabel: BaseLabel = {
		let title = BaseLabel()
		title.translatesAutoresizingMaskIntoConstraints = false
		title.font = UIFont.preferredFont(forTextStyle: .title1).with(weight: .bold)
		title.textColor = ThemeV2.TextColor.DefaultColor
		title.textAlignment = .center
		return title
	}()
	
	private lazy var versionLabel: BaseLabel = {
		let label = BaseLabel()
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .caption2).with(weight: .regular)
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.textAlignment = .center
		return label
	}()
	
	private lazy var storyLabel: BaseLabel = {
		let label = BaseLabel()
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .subheadline).with(weight: .regular)
		label.textColor = ThemeV2.TextColor.DefaultColor
		label.textAlignment = .center
		return label
	}()
	
	private lazy var twitterButton: NeuButton = {
		let label = NeuButton(title: "Twitter : @markhmwong")
		return label
	}()
	
	private lazy var emailButton: NeuButton = {
		let label = NeuButton(title: "Email : hello@whizbangapps.xyz")
		return label
	}()
	
    lazy var contact: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
		view.textColor = ThemeV2.TextColor.DefaultColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelectable = false
        view.isEditable = false
        return view
    }()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
	struct Text {
		static let titleString = "Shortlist"
		static let versionAndBuildString = "\(AppMetaData.name) v\(AppMetaData.version ?? " unknown"), build \(AppMetaData.build ?? "unknown").\nCoded in Melbourne, Australia."
		static let storyString = "Welcome to Shortlist. This app tries to keep this simple and doesn't try to over do the features and only present the necessary features to help you do what you need to do in real life by spending less time on your phone and more time doing. This app does not attempt to use powerful AI/ML algorithms to make your life better; rather it creates boundaries so we don't overextend.\n We have big life goals, but it's the smallest steps that help us reach the finish line."
		static let contactTwitter = "twitter.com/markhmwong"
		static let contactEmail = "hello@whizbangapps.xyz"
		static let madeIn = "Coded in Melbourne, Australia."
	}
	
    lazy var details = """
	Thanks for using \(AppMetaData.name) v\(AppMetaData.version ?? " unknown"), build \(AppMetaData.build ?? "unknown").\n
	\n
	The daily finite To Do List.
	
	
	
	Privacy.\n
	This app uses Firebase to track Worldwide task tallys. Task details are not sent to the server, only a count of the total tallies is tracked.
	
	Bugs.\n
	Please report any bugs to hello@whizbangapps.xyz
	
	Contact.\n
	Twitter: @markhmwong\nWebsite: https://www.whizbangapps.xyz/\(AppMetaData.name)\n
	
	Credits.\n
	Onboarding assets authors: Freepik, Pause08, Becris, srip, zlatko-najdenovski, itim2101 @ www.flaticon.com and icons8.com
	"""
    
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
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
		view.backgroundColor = ThemeV2.Background
		
		titleLabel.text = Text.titleString
		versionLabel.text = Text.versionAndBuildString
		storyLabel.text = Text.storyString
		
		view.addSubview(titleLabel)
		view.addSubview(versionLabel)
		view.addSubview(storyLabel)
		view.addSubview(twitterButton)
		view.addSubview(emailButton)
		
		storyLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 20).isActive = true
		storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
		storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true

		titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
		
		twitterButton.topAnchor.constraint(equalTo: storyLabel.bottomAnchor, constant: 20).isActive = true
		twitterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		twitterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		
		emailButton.topAnchor.constraint(equalTo: twitterButton.bottomAnchor, constant: 20).isActive = true
		emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
		emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
		
    }
	
	func cleanUpChildCoordinator() {
		NotificationCenter.default.post(name: Notification.Name(SettingsNavigationObserverKey.ReturnFromInfo.rawValue), object: self)
	}
	
	deinit {
		coordinator?.cleanUpChildCoordinator()
	}
}
