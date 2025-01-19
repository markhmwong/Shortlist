//
//  SettingsCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 4/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class SettingsCoordinator: CoordinatorFacade {
    
    override init(parentCoordinator: (any Coordinator)? = nil, parentNavigationController: UINavigationController? = nil, rootNavigationController: UINavigationController? = nil, rootViewController: UIViewController? = nil, coreDataStack: CoreDataStack? = nil) {
        super.init(parentCoordinator: parentCoordinator, parentNavigationController: parentNavigationController, rootNavigationController: rootNavigationController, rootViewController: rootNavigationController, coreDataStack: coreDataStack)
    }
    
    override func start() {
		let vm = SettingsViewModel(coordinator: self)
        let vc = SettingsViewController(viewModel: vm)
		guard let rnc = rootNavigationController else {
			return
		}
		rnc.viewControllers = [vc]
		let leftItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissCurrentView))
		vc.navigationItem.leftBarButtonItem = leftItem
		parentNavigationController?.present(rnc, animated: true)
    }

	override func dismissCurrentView() {
		rootNavigationController?.dismiss(animated: true)
	}

	func showAbout() {
		guard let rnc = rootNavigationController else {
			return
		}

		let vc = AboutViewController()
		vc.title = "About"
		rnc.pushViewController(vc, animated: true)
	}

	func showPrivacyPolicy() {
		let vc = PrivacyPolicyViewController()
		parentNavigationController?.pushViewController(vc, animated: true)
	}
}

class AboutViewController: UIViewController {

	private lazy var aboutDescription: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.font = UIFont.preferredFont(forTextStyle: .body)
		label.text = """
	Hello Users! This is version 3 of Shortlist. It's taken me a while due to personal and work commitments. This app never really reached what I invisioned it to be and this update brings a new iteration literally from the ground up - yes I said screw it and deleted everything. The codebase has been entirely rewritten, for ease of readability and maintainability in Swift programming language. The core vision of app remains the same. Bring in a limited amount of tasks per day to avoid burnout in day to day life. I apologise if there are any existing users who previously purchased the app and still use it, which i don't think there are many, if any at all, you will need to reinstall the app and this will wipe any data you previously had. I guess like any new version i think this version has improved on any quirks version 2 had. Plus i got rid of a lot of spaghetti code. 
"""
		return label
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .mainBackground

		NSLayoutConstraint.activate([
			aboutDescription.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			aboutDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			aboutDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
		])
	}
}

class PrivacyPolicyViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .mainBackground

	}
}
