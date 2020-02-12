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
    
    weak var coordinator: SettingsCoordinator?
    
	// move to view model?
    weak var persistentContainer: PersistentContainer?
    
    var viewModel: SettingsViewModel?
    
    private lazy var tableView: UITableView = {
		let view = UITableView(frame: .zero, style: UITableView.Style.plain)
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
		
		// view
		view.backgroundColor = .black
		
		// navigation
		navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleDismiss), imageName: "Back", height: self.topBarHeight / 1.8)
		navigationItem.title = "Settings"
		
		// register cells for tableview
		viewModel?.registerTableViewCell(tableView)
		
		// tableview header setup
        let settingsHeaderViewModel = SettingsHeaderViewModel()
        let header = SettingsHeader(delegate: self, viewModel: settingsHeaderViewModel)
        tableView.tableHeaderView = header
		header.setNeedsLayout()
		header.layoutIfNeeded()
        view.addSubview(tableView)
        tableView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)		
		
		// request tips from Apple
        header.grabTipsProducts()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		tableView.updateHeaderViewHeight()
	}
    
    @objc
    func handleDismiss() {
		coordinator?.dimiss()
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
    
    //link to be updated
    func writeReview() {
        let productURL = URL(string: "https://itunes.apple.com/app/")!
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
			self.coordinator?.parentCoordinator?.showReview(self.persistentContainer, automated: false)
		})
	}
	
	func confirmDeleteCategoryData() {
		let closure = { () in
			self.deleteCategoryData()
		}
		coordinator?.deleteBox(self, deletionClosure: closure, title: "Would you like to delete all categories?", message: "Data is unrecoverable")
	}
	
	func confirmDeleteAllData() {
		let closure = { () in
			self.deleteAllData()
		}
		coordinator?.deleteBox(self, deletionClosure: closure, title: "Would you like to delete all data?", message: "Data is unrecoverable")
	}
	
	// viewModel?
	func deleteAllData() {
		guard let persistentContainer = persistentContainer else { return }
		let _ = persistentContainer.deleteAllRecordsIn(entity: Day.self)
		// Task/BigListTask entity is deletion is cascaded that's why it's missing
		let _ = persistentContainer.deleteAllRecordsIn(entity: CategoryList.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: BackLog.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: Stats.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: StatsCategoryComplete.self)
	}
	
	func deleteCategoryData() {
		guard let persistentContainer = persistentContainer else { return }
		let _ = persistentContainer.deleteAllRecordsIn(entity: CategoryList.self)
		let _ = persistentContainer.deleteAllRecordsIn(entity: BackLog.self)
	}
	
	func reloadData() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	deinit {
		coordinator?.cleanUpChildCoordinator()
	}
	
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let _viewModel = viewModel else { return }
		_viewModel.willDisplayHeader(view: view, section: section)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let _viewModel = viewModel else { return nil }
		return _viewModel.viewForHeader(section: section)
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let _viewModel = viewModel else { return "Unknown" }
		return _viewModel.titleForSection(sectionNum: section)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		guard let _viewModel = viewModel else { return 0 }
        return _viewModel.sectionsCount()
	}
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let _viewModel = viewModel else { return 0 }
		return _viewModel.rowsInSection(section: section)
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
		guard let _viewModel = viewModel else { return }
		guard let _persistentContainer = persistentContainer else { return }
		_viewModel.didSelectRow(tableView, indexPath: indexPath, delegate: self, persistentContainer: _persistentContainer)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
