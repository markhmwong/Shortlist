//
//  TaskDetailsCoordinator.swift
//  Shortlist
//
//  Created by Mark Wong on 14/6/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit

class TaskDetailsCoordinator: CoordinatorFacade<SLTask> {
    
	override init(parentCoordinator: (any Coordinator)? = nil,
				  parentNavigationController: UINavigationController? = nil,
				  rootNavigationController: UINavigationController? = nil,
				  rootViewController: UIViewController? = nil,
				  coreDataStack: CoreDataStack? = nil,
				  task: SLTask? = nil) {
		super.init(parentCoordinator: parentCoordinator as! TaskListCoordinator,
				   parentNavigationController: parentNavigationController,
				   rootNavigationController: rootNavigationController,
				   rootViewController: rootViewController,
				   coreDataStack: coreDataStack,
				   task: task)
    }
    
    override func start(with item: SLTask) {
        guard let cds = coreDataStack
        else {
            print("Core Data - \(coreDataStack)")
            return
        }

        let vm = TaskDetailsViewModel(item: item, coreData: cds)
        guard 
            let pc = parentCoordinator
        else
        {
            return
        }
        rootViewController = TaskDetailsViewController(viewModel: vm, coordinator: self, delegate: pc.rootViewController as! RefreshablePopView)
        
        guard let rvc = rootViewController 
        else {
            return
        }

		navigationButtons()

        rootNavigationController = UINavigationController(rootViewController: rvc)


		guard
            let rnc = rootNavigationController,
            let pnc = parentNavigationController
        else {
            return
        }
        
        pnc.present(rnc, animated: true)
    }

	private func navigationButtons() {
		let leftItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissCurrentView))
		rootViewController?.navigationItem.leftBarButtonItem = leftItem

	}

	public func pushPrioritySelectionViewController(with task: SLTask) {
		self.task = task
		let viewModel = PrioritySelectionViewModel(task: task)
		let vc = PrioritySelectionViewController(coordinator: self, viewModel: viewModel)
		rootNavigationController?.pushViewController(vc, animated: true)
	}

	public func pushReminderDatePickerViewController(with task: SLTask) {
		self.task = task
		let viewModel = ReminderDatePickerViewModel(task: task)
		let vc = ReminderDatePickerViewController(coordinator: self, viewModel: viewModel)
		rootNavigationController?.pushViewController(vc, animated: true)
	}

	public func pushCategorySelectionViewController(with task: SLTask) {
		guard let coreDataStack, let rvc = rootViewController as? RefreshablePopView else {
			assertionFailure("Core Data Stack is nil")
			return
		}
		self.task = task
		let viewModel = CategorySelectionViewModel(task: task, cds: coreDataStack)
		let vc = CategorySelectionViewController(coordinator: self, viewModel: viewModel, delegate: rvc)
		rootNavigationController?.pushViewController(vc, animated: true)
	}

	override public func refreshOnPop(with item: SLTask) {
		self.task = task
		guard let rootNavigationController else {
			return
		}

		if let viewController = rootNavigationController.viewControllers.first as? RefreshablePopView {
			viewController.refresh(item: item)
		}

		rootNavigationController.popViewController(animated: true)
	}


    override func dismissCurrentView() {
        guard 
            let rnc = rootNavigationController
        else {
            return
        }

//		if let refreshable = rootViewController as? TaskDetailsViewController {
//			refreshable.dismissCurrentView()
//		}

        rnc.dismiss(animated: true)
    }
}

