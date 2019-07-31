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
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainViewController(persistentContainer: persistentContainer, viewModel: MainViewModel())
        
        if (!WatchSessionHandler.shared.isSupported()) {
            print("WCSession not supported")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        persistentContainer.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        persistentContainer.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        if (!WatchSessionHandler.shared.isSupported() && !WatchSessionHandler.shared.isReachable()) {
            print("WCSession not supported")
        } else {
            print("WCSession IS supported")
            let today = Calendar.current.today()
            let taskList = TaskList(date: today)
            let jsonEncoder = JSONEncoder()
            
            do {
                let jsonData = try jsonEncoder.encode(taskList)
                //            let jsonString = String(data: jsonData, encoding: .utf8)
                print("send")
                WatchSessionHandler.shared.sendObjectWith(jsonData: jsonData)
            } catch (let err) {
                print("Error encoding taskList \(err)")
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        persistentContainer.saveContext()
    }


}

