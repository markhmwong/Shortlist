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
        let container = PersistentContainer(name: "FiveModel")
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
        let navController = UINavigationController()
        mainCoordinator = MainCoordinator(navigationController: navController)
        mainCoordinator?.start(persistentContainer)
        
        window = UIWindow()
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        if (!WatchSessionHandler.shared.isSupported()) {
            print("WCSession not supported")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        persistentContainer.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

        persistentContainer.saveContext()
    }


}

