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
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.whizbang.Five")!.appendingPathComponent("Shortlist.sqlite")
        var defaultURL: URL?
            if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
                defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
        }
        
        if defaultURL == nil {
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
            if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
                let coordinator = container.persistentStoreCoordinator
                if let oldStore = coordinator.persistentStore(for: url) {
                    do {
                        try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
                    } catch {
                        print(error.localizedDescription)
                    }

                    // delete old store
                    let fileCoordinator = NSFileCoordinator(filePresenter: nil)
                    fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true        
        return container
    }()
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
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

