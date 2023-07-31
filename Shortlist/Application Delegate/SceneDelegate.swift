//
//  SceneDelegate.swift
//  Shortlist
//
//  Created by Mark Wong on 15/6/21.
//  Copyright © 2021 Mark Wong. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            let navController = UINavigationController()
            mainCoordinator = MainCoordinator(navigationController: navController)
            mainCoordinator?.start(persistentContainer)
            
            if true {
//            if (TemporaryStorageService.shared.firstLoad()) {

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
                guard let stats = dayObject.dayToStats, let taskCount = dayObject.dayToTask?.count else { return }
                stats.totalTasks += Int64(taskCount)
                persistentContainer.saveContext()

            } else {

                if let day = persistentContainer.doesDayExist() {
                    if !day.reviewYesterday {
    //                    day.reviewYesterday = !day.reviewYesterday

                        mainCoordinator?.reviewFlag = false
                        mainCoordinator?.start(persistentContainer)

                        // show review page
    //                    DispatchQueue.main.async {
    //                        self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
    //                    }
                    }
                } else {
                    // create new day
                    let context = persistentContainer.viewContext
                    let dayObject = Day(context: context)
                    dayObject.createNewDay(date: Calendar.current.today())
                    persistentContainer.saveContext()
                }



    //            let today: Int16 = Calendar.current.todayToInt()

                // open app with review
    //            if let reviewDate = KeychainWrapper.standard.integer(forKey: SettingsKeyChainKeys.ReviewDate) {
    //                if (today != Int16(reviewDate)) {
    //
    //                    mainCoordinator?.reviewFlag = true
    //                    mainCoordinator?.start(persistentContainer)
    //
    //                    // update keychain
    //                    KeychainWrapper.standard.set(Int(today), forKey: SettingsKeyChainKeys.ReviewDate)
    //
    //                    // show review page
    //                    DispatchQueue.main.async {
    //                        self.mainCoordinator?.showReview(self.persistentContainer, automated: true)
    //                    }
    //                } else {
    //                    // open app without review
    //                    mainCoordinator?.start(persistentContainer)
    //                }
    //            } else {
                    // open app without review
    //                mainCoordinator?.start(persistentContainer)
    //            }
            }
            
  
            self.window!.rootViewController = navController
            self.window!.makeKeyAndVisible()
            // Appearance
            
        }
    }
    
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

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }


}
