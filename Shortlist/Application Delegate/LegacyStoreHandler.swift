//
//  LegacyStoreHandler.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import Foundation

/// Detects and removes the v2 Core Data store (stored at the default app sandbox path)
/// so it doesn't waste space after the v3 upgrade moves to the App Group container.
enum LegacyStoreHandler {

    static let welcomeShownKey = "v3WelcomeShown"

    static var shouldShowWelcome: Bool {
        !UserDefaults.standard.bool(forKey: welcomeShownKey)
    }

    static func markWelcomeShown() {
        UserDefaults.standard.set(true, forKey: welcomeShownKey)
    }

    /// Deletes the v2 SQLite store from the default app-sandbox Application Support directory
    /// if it exists. Safe to call on every launch — does nothing when the file is absent.
    static func removeV2StoreIfPresent() {
        guard let appSupport = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask).first
        else { return }

        let baseName = appSupport.appendingPathComponent("ShortlistModel")
        for ext in ["sqlite", "sqlite-shm", "sqlite-wal"] {
            let url = baseName.appendingPathExtension(ext)
            if FileManager.default.fileExists(atPath: url.path) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
}
