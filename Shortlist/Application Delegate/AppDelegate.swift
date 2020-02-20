//
//  AppDelegate.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var mainCoordinator: MainCoordinator?
	
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "ShortlistModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true        
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		
		//Launch firebase
		FirebaseApp.configure()
		
		// initialise root coordinator
        let navController = UINavigationController()
		mainCoordinator = MainCoordinator(navigationController: navController)
		
		// Recognise whether this is the first time the app has been booted/installed via KeyChain
		if (TemporaryStorageService.shared.firstLoad()) {
			
			mainCoordinator?.start(persistentContainer)
			mainCoordinator?.showOnboarding(persistentContainer)

			// setup initial priority limits for the keychain numbers are defaults for each priority
			initialisePriorityKeychain()
			
			// create sample
			// move to Task entity
			let context = persistentContainer.viewContext
			let dayObject = Day(context: persistentContainer.viewContext)
			
			dayObject.createNewDay(date: Calendar.current.today())
			guard let stats = dayObject.dayToStats else { return true }
			stats.totalTasks += 3
			let taskHigh: Task = Task(context: context)
			
			
			taskHigh.create(context: context, idNum: Int(stats.totalTasks), taskName: "📬 An important task, preferably something you must accomplish today.", categoryName: "Uncategorized", createdAt: Calendar.current.today(), reminderDate: Calendar.current.today(), priority: Int(Priority.high.value))
			taskHigh.details = "These tasks are very limited of 1 - 2. Important and may take most of the day to complete."
			dayObject.addToDayToTask(taskHigh)
			let taskMed: Task = Task(context: context)

			taskMed.create(context: context, idNum: Int(stats.totalTasks), taskName: "📕 Think of this as a meeting with work colleagues, friends, family, grocery shopping, initial design or prototype.", categoryName: "Uncategorized", createdAt: Calendar.current.today(), reminderDate: Calendar.current.today(), priority: Int(Priority.medium.value))
			taskMed.details = "The limit on a medium priority task is 1 - 3."
			dayObject.addToDayToTask(taskMed)
			
			let taskLow: Task = Task(context: context)
			taskLow.create(context: context, idNum: Int(stats.totalTasks), taskName: "🚀 Quick tasks that aren't necessarily important or something to remind yourself, like catching up on TV shows or replying to emails.", categoryName: "Uncategorized", createdAt: Calendar.current.today(), reminderDate: Calendar.current.today(), priority: Int(Priority.low.value))
			taskLow.details = "The limit on a low priority task is 1 - 3. Quick tasks that don't need a lot of time spent on."
			dayObject.addToDayToTask(taskLow)
			persistentContainer.saveContext()

		} else {
			mainCoordinator?.start(persistentContainer)
			
			let today: Int16 = Calendar.current.todayToInt()

			if let reviewDate = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.ReviewDate) {
				if (today != Int16(reviewDate)) {
					
					// update keychain
					KeychainWrapper.standard.set(Int(today), forKey: SettingsKeyChainKeys.ReviewDate)
					
					// show review page
					DispatchQueue.main.async {
						self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
					}
				}
			}
		}

        window = UIWindow()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        if (!WatchSessionHandler.shared.isSupported()) {
            print("WCSession not supported")
        }
        
        /// Observer for handling In App Product key events
        IAPProducts.tipStore.addStoreObserver()
        
        return true
    }
	
	func initialisePriorityKeychain() {
		if (KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) == nil) {
			KeychainWrapper.standard.set(1, forKey: SettingsKeyChainKeys.HighPriorityLimit)
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.MediumPriorityLimit)
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.LowPriorityLimit)
		}
	}

    func applicationWillResignActive(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
		print("will enter foreground")
		let today: Int16 = Calendar.current.todayToInt()

		if let reviewDate = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.ReviewDate) {
			if (today != Int16(reviewDate)) {
//			if true {
				// update keychain
				KeychainWrapper.standard.set(Int(today), forKey: SettingsKeyChainKeys.ReviewDate)
				
				// show review page
				DispatchQueue.main.async {
					self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
				}
			}
		}
    }
	var timer: DispatchSourceTimer?
    func applicationDidBecomeActive(_ application: UIApplication) {
		
    }


    func applicationWillTerminate(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		//
	}
}

