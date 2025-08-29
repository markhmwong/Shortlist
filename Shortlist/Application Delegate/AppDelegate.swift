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
    
    var cds: CoreDataStack = CoreDataStack.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        return true
	}

    func applicationWillResignActive(_ application: UIApplication) {
//        persistentContainer.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        persistentContainer.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }
	var timer: DispatchSourceTimer?
    func applicationDidBecomeActive(_ application: UIApplication) {
		
    }


    func applicationWillTerminate(_ application: UIApplication) {
//        persistentContainer.saveContext()
    }

	func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
		//
	}
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

