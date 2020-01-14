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
    
    //link to be updated
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
	
	func dismissAndShowReview() {
		navigationController?.dismiss(animated: true, completion: {
			self.coordinator?.parentCoordinator?.showReview(self.persistentContainer, mainViewController: nil)
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
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let view = view as? UITableViewHeaderFooterView
		
		if #available(iOS 10, *) {
			view?.contentView.backgroundColor = .black
		} else {
			view?.backgroundView?.backgroundColor = .black
		}
		
		let size: CGFloat = Theme.Font.FontSize.Standard(.b4).value
		view?.textLabel?.font = UIFont(name: Theme.Font.Regular, size: size)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UITableViewHeaderFooterView()
		view.backgroundView?.backgroundColor = .clear
		view.textLabel?.textColor = UIColor.white.withAlphaComponent(0.7)
		return view
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
