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
    
    init(persistentContainer: PersistentContainer, coordinator: SettingsCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.persistentContainer = persistentContainer
        self.viewModel = SettingsViewModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        navigationController?.title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCellId")
        
        let headerViewModel = SettingsHeaderViewModel()
        let header = SettingsHeader(delegate: self, viewModel: headerViewModel)
        tableView.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        view.addSubview(tableView)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc
    func handleBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func emailFeedback() {
        guard let vm = viewModel else {
            return
        }
        
        let mail: MFMailComposeViewController = MFMailComposeViewController(nibName: nil, bundle: nil)
        mail.mailComposeDelegate = self
        mail.setToRecipients([vm.emailToRecipient])
        mail.setSubject(vm.emailSubject)
        
        mail.setMessageBody(vm.emailBody(), isHTML: true)
        coordinator?.showFeedback(mail)
    }
    
    //https://itunes.apple.com/app/id1454444680?mt=8
    func writeReview() {
        let productURL = URL(string: "https://itunes.apple.com/app/id1454444680?mt=8")!
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        guard let writeReviewURL = components?.url else {
            return
        }
        
        UIApplication.shared.open(writeReviewURL)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCellId", for: indexPath)
        cell.textLabel?.text = viewModel?.menu[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = MenuStructure(rawValue: indexPath.row) {
            
            switch menu {
                case .TaskLimit:
                    coordinator?.showTaskLimit(persistentContainer)
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
