//
//  AppDelegate.swift
//  Five
//
//  Created by Mark Wong on 16/7/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

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
		window = UIWindow()
		
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
            dayObject.addStartupTasks(context)
            guard let stats = dayObject.dayToStats, let taskCount = dayObject.dayToTask?.count else { return true }
            stats.totalTasks += Int64(taskCount)
			persistentContainer.saveContext()

		} else {
            
            if let day = persistentContainer.doesDayExist() {
                if !day.reviewYesterday {
//                    day.reviewYesterday = !day.reviewYesterday

                    mainCoordinator?.reviewFlag = false
                    mainCoordinator?.start(persistentContainer)

                    // show review page
                    DispatchQueue.main.async {
//                        self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
                    }
                }
            } else {
                // create new day
                let context = persistentContainer.viewContext
                let dayObject = Day(context: context)
                dayObject.createNewDay(date: Calendar.current.today())
                persistentContainer.saveContext()
            }
            

            
//			let today: Int16 = Calendar.current.todayToInt()

			// open app with review
//			if let reviewDate = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.ReviewDate) {
//				if (today != Int16(reviewDate)) {
//
//					mainCoordinator?.reviewFlag = true
//					mainCoordinator?.start(persistentContainer)
//
//					// update keychain
//					KeychainWrapper.standard.set(Int(today), forKey: SettingsKeyChainKeys.ReviewDate)
//
//					// show review page
//					DispatchQueue.main.async {
//						self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
//					}
//				} else {
//					// open app without review
//					mainCoordinator?.start(persistentContainer)
//				}
//			} else {
				// open app without review
//				mainCoordinator?.start(persistentContainer)
//			}
		}
        window?.rootViewController = navController
		window?.windowScene = application.currentScene
		window?.makeKeyAndVisible()

       
        if (!WatchSessionHandler.shared.isSupported()) {
			//
        }
        
        /// Observer for handling In App Product key events
        IAPProducts.tipStore.addStoreObserver()
        
        return true
    }
	
	// sets up any keychain state if it already hasn't been initialised
	func initialisePriorityKeychain() {
		if (KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.HighPriorityLimit) == nil) {
			KeychainWrapper.standard.set(false, forKey: SettingsKeyChainKeys.GlobalTasks)
			KeychainWrapper.standard.set(false, forKey: SettingsKeyChainKeys.AllDayNotifications)
			KeychainWrapper.standard.set(1, forKey: SettingsKeyChainKeys.HighPriorityLimit)
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.MediumPriorityLimit)
			KeychainWrapper.standard.set(3, forKey: SettingsKeyChainKeys.LowPriorityLimit)
		}
		
		if (KeychainWrapper.standard.bool(forKey: SettingsKeyChainKeys.AllDayNotifications) == nil) {
			KeychainWrapper.standard.set(false, forKey: SettingsKeyChainKeys.AllDayNotifications)
		}
		
		if (KeychainWrapper.standard.bool(forKey: SettingsKeyChainKeys.GlobalTasks) == nil) {
			KeychainWrapper.standard.set(false, forKey: SettingsKeyChainKeys.GlobalTasks)
		}
	}

    func applicationWillResignActive(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
		let today: Int16 = Calendar.current.todayToInt()

		if let reviewDate = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.ReviewDate) {
			if (today != Int16(reviewDate)) {
				
				// Apply all day local notifications if the app hasn't initiated it yet
				let hoursRemaining = Date().hoursRemaining()
				
				if let allDayNotifications = KeychainWrapper.standard.bool(forKey: SettingsKeyChainKeys.AllDayNotifications) {
					
					if allDayNotifications {
						if (hoursRemaining > 2) {
							for hour in 0..<hoursRemaining {
								let id = 24 - (hoursRemaining - hour)
								let timeToNextHour = Date().timeRemainingToHour()
								let timeRemaining = timeToNextHour + Double(60 * hour)
								LocalNotificationsService.shared.addAllDayNotification(id: "\(id)", notificationContent: [LocalNotificationKeys.Title : "Frequent Reminder"], timeRemaining: timeRemaining) // add content/body to notification
							}
						}
					}
				}
				
				// update keychain
				KeychainWrapper.standard.set(Int(today), forKey: SettingsKeyChainKeys.ReviewDate)
				
				// Ensure a Day object has been created
				if let mainVC = mainCoordinator?.rootViewController {
                    // to fix
//					mainVC.loadData()
				}
				
				// Task Tally update
				
				
				// show review page
				DispatchQueue.main.async {
					self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
				}
			}
		}
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		
    }


    func applicationWillTerminate(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		//
	}
}

