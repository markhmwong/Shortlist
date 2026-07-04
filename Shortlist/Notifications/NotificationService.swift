//
//  NotificationService.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UserNotifications

final class NotificationService: NSObject {

    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()

    // Stable identifiers for repeating daily notifications
    private let morningNudgeID   = "com.whizbang.shortlist.morning-nudge"
    private let eveningCheckinID = "com.whizbang.shortlist.evening-checkin"

    private override init() {
        super.init()
        center.delegate = self
    }

    // MARK: - Authorization

    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    // MARK: - Per-task reminders

    func scheduleReminder(for task: SLTask) {
        guard let reminder = task.reminder,
              reminder > Date(),
              let id = task.id?.uuidString else { return }

        let content = UNMutableNotificationContent()
        content.title = task.name ?? "Reminder"
        content.body  = "Don't forget to complete this goal today."
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }

    func cancelReminder(for task: SLTask) {
        guard let id = task.id?.uuidString else { return }
        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    // MARK: - Daily nudges

    /// Schedules the 8 AM morning nudge and 8 PM evening check-in if not already pending.
    func scheduleDailyNudgesIfNeeded() {
        center.getPendingNotificationRequests { [weak self] pending in
            guard let self else { return }
            let ids = Set(pending.map(\.identifier))
            if !ids.contains(self.morningNudgeID)   { self.scheduleMorningNudge() }
            if !ids.contains(self.eveningCheckinID) { self.scheduleEveningCheckIn() }
        }
    }

    private func scheduleMorningNudge() {
        let content = UNMutableNotificationContent()
        content.title = "Good morning"
        content.body  = "Set your three goals for today and make it count."
        content.sound = .default

        var dc = DateComponents()
        dc.hour = 8; dc.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: morningNudgeID, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }

    private func scheduleEveningCheckIn() {
        let content = UNMutableNotificationContent()
        content.title = "Evening check-in"
        content.body  = "How did your goals go today? Swipe to mark them complete."
        content.sound = .default

        var dc = DateComponents()
        dc.hour = 20; dc.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        let request = UNNotificationRequest(identifier: eveningCheckinID, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }

    // MARK: - Streak celebration

    private let streakMilestones: Set<Int> = [3, 7, 14, 30, 60, 100]

    func celebrateStreakIfMilestone(_ streak: Int) {
        guard streakMilestones.contains(streak) else { return }

        let content = UNMutableNotificationContent()
        content.title = streakTitle(for: streak)
        content.body  = "You've completed all your goals for \(streak) days in a row. Keep it up!"
        content.sound = .defaultCritical

        // Fire next morning at 8:15 AM so it follows the morning nudge
        var dc = DateComponents()
        dc.hour = 8; dc.minute = 15
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        var triggerDC = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
        triggerDC.hour = 8; triggerDC.minute = 15

        let id = "com.whizbang.shortlist.streak-\(streak)"
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDC, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }

    private func streakTitle(for streak: Int) -> String {
        switch streak {
        case 3:   return "3-day streak!"
        case 7:   return "One week streak!"
        case 14:  return "Two weeks strong!"
        case 30:  return "30-day streak!"
        case 60:  return "60 days. Incredible."
        case 100: return "100-day streak. Legend."
        default:  return "\(streak)-day streak!"
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    // Show notifications even when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
