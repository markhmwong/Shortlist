//
//  Settings.swift
//  Five
//
//  Created by Mark Wong on 4/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    enum MenuStructure: Int {
        case TaskLimit = 0
		case Stats
		case YesterdayReview
        case About
        case Review
        case Contact
    }
    
    weak var coordinator: SettingsCoordinator?
    
    var persistentContainer: PersistentContainer?
    
    var viewModel: SettingsViewModel?
    
    lazy var tableView: UITableView = {
       let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.backgroundColor = .black
        return view
    }()
    
	init(persistentContainer: PersistentContainer, coordinator: SettingsCoordinator, viewModel: SettingsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.persistentContainer = persistentContainer
        self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        navigationController?.title = "Settings"

		viewModel?.registerTableViewCell(tableView)
        let settingsHeaderViewModel = SettingsHeaderViewModel()
        let header = SettingsHeader(delegate: self, viewModel: settingsHeaderViewModel)
        tableView.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        view.addSubview(tableView)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        header.grabTipsProducts()
    }
    
    @objc
    func handleBack() {
		navigationController?.dismiss(animated: true, completion: {
//			self.coordinator?.parentCoordinator?.showReview(self.persistentContainer)
		})
    }
    
    func emailFeedback() {
        guard let vm = viewModel else {
            return
        }
        
        let mail: MFMailComposeViewController? = MFMailComposeViewController(nibName: nil, bundle: nil)
		guard let mailVc = mail else {
			return
		}
		
        mailVc.mailComposeDelegate = self
        mailVc.setToRecipients([vm.emailToRecipient])
        mailVc.setSubject(vm.emailSubject)
        
        mailVc.setMessageBody(vm.emailBody(), isHTML: true)
        coordinator?.showFeedback(mailVc)
    }
    
    //https://itunes.apple.com/app/id1454444680?mt=8
    func writeReview() {
        let productURL = URL(string: "https://itunes.apple.com/app/id1454444680?mt=8")! // to be changed
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
    }
	
	func dismissAndShowReview() {
		navigationController?.dismiss(animated: true, completion: {
			self.coordinator?.parentCoordinator?.showReview(self.persistentContainer, mainViewController: nil)
		})
	}
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.menu.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let viewModel = viewModel else {
			let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellId", for: indexPath)
			cell.textLabel?.text = "Unknown Cell"
			cell.textLabel?.textColor = UIColor.white
			cell.backgroundColor = .clear
			return cell
		}
		return viewModel.tableViewCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = MenuStructure(rawValue: indexPath.row) {
            switch menu {
                case .TaskLimit:
					coordinator?.showTaskLimit(persistentContainer)
				case .Stats:
					coordinator?.showStats(persistentContainer)
				case .YesterdayReview:
					dismissAndShowReview()
                case .About:
                    coordinator?.showAbout(nil)
                case .Review:
                    self.writeReview()
                case .Contact:
                    self.emailFeedback()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
