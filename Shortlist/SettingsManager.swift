//
//  SettingsManager.swift
//  Shortlist
//
//  Created by Mark Wong on 27/7/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import Foundation

/// A singelton to manage the data
final class SettingsManager {
    
    static let shared: SettingsManager = SettingsManager()
    
    private let coreData: CoreDataStack = CoreDataStack.shared
    
    private var taskLimit: Int16 = 0
    
    private init() {
        initialiseSettingsModelIfNeeded()
    }
    
    /// use this to initialise the settings when the app first loads
    private func initialiseSettingsModelIfNeeded() {
        if !coreData.fetchSettingsModel() {
            coreData.createSettingsModel()
        }
    }
    
    public func fetchTaskLimit() -> Int16 {
        return coreData.fetchSettingsLimit()
    }
}
