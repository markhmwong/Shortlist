//
//  StreakManager.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import CoreData

/// Records daily outcomes and computes the user's current clean-sweep streak.
/// A "clean sweep" is a day where the user set ≥1 goal and completed every one of them.
final class StreakManager {

    static let shared = StreakManager()

    private init() { }

    // MARK: - Sealing a day

    /// Records the outcome of the given date using `tasks` as the source of truth.
    /// Idempotent — if an SLDay already exists for that date, it updates it.
    func sealDay(date: Date, tasks: [SLTask], in context: NSManagedObjectContext) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let goalCount = tasks.count
        let completedCount = tasks.filter { $0.taskToStatus?.name == TaskStatus.Complete.rawValue }.count
        let isCleanSweep = goalCount > 0 && completedCount == goalCount

        let existing = fetchDay(for: startOfDay, in: context)
        let record = existing ?? SLDay(context: context)
        record.date = startOfDay
        record.goalCount = Int16(goalCount)
        record.completedCount = Int16(completedCount)
        record.isCleanSweep = isCleanSweep

        try? context.save()

        if isCleanSweep {
            let streak = currentStreak(in: context)
            NotificationService.shared.celebrateStreakIfMilestone(streak)
        }
    }

    // MARK: - Streak computation

    /// Returns the length of the current consecutive clean-sweep streak.
    /// Counts backwards from yesterday; if yesterday was also a clean sweep it keeps counting.
    /// A streak of 0 means the most recent completed day was not a clean sweep (or no days recorded).
    func currentStreak(in context: NSManagedObjectContext) -> Int {
        let request: NSFetchRequest<SLDay> = SLDay.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SLDay.date, ascending: false)]

        guard let days = try? context.fetch(request), !days.isEmpty else { return 0 }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        var streak = 0
        var expected = calendar.date(byAdding: .day, value: -1, to: today)! // start from yesterday

        for day in days {
            let dayStart = calendar.startOfDay(for: day.date)
            if dayStart == expected && day.isCleanSweep {
                streak += 1
                expected = calendar.date(byAdding: .day, value: -1, to: dayStart)!
            } else {
                break
            }
        }

        return streak
    }

    // MARK: - Helpers

    private func fetchDay(for startOfDay: Date, in context: NSManagedObjectContext) -> SLDay? {
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        let request: NSFetchRequest<SLDay> = SLDay.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@",
                                        startOfDay as NSDate, endOfDay as NSDate)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
}
