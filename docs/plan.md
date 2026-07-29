# Shortlist — Plan

> Note on branches: the repo's `dev`/`master` branches hold the old (2020–2021) v2
> app. All current, real work lives on **`v3/dev`**, which has diverged from
> `dev` since commit `8c2a728` and is a from-scratch rebuild ("I have nuked all
> previous and am basically starting from scratch" — v3/dev `README.md`). This
> plan describes `v3/dev`, since that is the app actually being shipped next.

## 1. Goal

Shortlist is a daily task app for people who over-commit themselves. Instead of
an open-ended to-do list, the user picks at most **3 goals a day**. There is no
backlog, no carryover, no infinite list — the philosophy (per project memory
and the v3 README) is explicitly "remove abundance": abundance of storage,
abundance of time, abundance of tasks people pile onto themselves.

Each day is a fresh slate: goals that aren't finished by midnight simply
archive out of the active list (they're kept in Core Data for stats/streaks,
not deleted, but they don't roll over as pending work). Completing all of a
day's goals is a "clean sweep," which is tracked as a streak and celebrated.

Target user: someone who wants a small, opinionated commitment device — not a
project-management tool. Single individual user, no accounts, no sync, no
social features.

## 2. Current state (what exists on `v3/dev`)

The `.story/roadmap.json` on `v3/dev` says it plainly: **"All code is complete
— this phase is art, metadata, and pipeline."** The one open phase is
`app-store-release` (PHASE 7). Feature work is done; what's left is shipping.

Implemented, per commit history and source:

- **Today-scoped task list** — hard cap of 3 goals/day (`TaskListViewModel`
  `canAddTask()`), list resets at midnight, no settings slider to raise the
  limit (removed).
- **Add-goal flow** — modal sheet (`AddGoalViewController` /
  `NewTaskStage1ViewController`) with placeholder slots for the 3 goals.
- **Swipe-to-complete** with haptics, `TaskListItem` enum backing a diffable
  datasource (`DatasourceSupervisor`).
- **Task details** — title, description, priority (`TaskPriorityLevel`),
  category, reminder, image attachment (`MediaManager`, saved into the App
  Group container), and a destination (`DestinationPickerViewController`,
  `lat`/`long`/`placeName` on `SLTask`, `LocationService` for geofencing).
- **Notifications** (`NotificationService`) — per-task reminder, morning nudge
  (~8 AM, suppressed once goals are set), evening check-in (~8 PM, only if
  something's incomplete), and streak-milestone celebrations.
- **Streaks** (`StreakManager`) — seals each day into an `SLDay` record
  (`goalCount`, `completedCount`, `isCleanSweep`) and computes the current
  consecutive clean-sweep streak.
- **Widgets** (`ShortlistWidgetExtension`) — Home Screen small + medium
  (`ShortlistSmallWidget`, `ShortlistMediumWidget`) reading from the shared App
  Group store via `WidgetDataProvider`; a `CompleteTaskIntent` for interactive
  completion.
- **App Group migration** — Core Data store moved to a shared container
  (`CoreDataStack`, `group.com.whizbang.Five`) so the widget can read it;
  `LegacyStoreHandler` deletes the old v2 sandbox store and shows a one-time
  welcome screen instead of migrating old data.
- **RevenueCat Pro entitlement** — `ProFeatureManager` wired to RevenueCat
  (in progress per ticket T-007: API keys and the dashboard offering/entitlement
  are still placeholders — `"appl_REPLACE_WITH_..."`).
- **Settings** — rebuilt (`Settings/SettingsViewController` +
  `AnySettingsItem`/`GeneralSettingsItem`), task-limit slider removed.
- Core Data model: `SLTask`, `SLDay`, `SLCategory`, `SLStatus`, `SLSettings`
  entities (`Model/CoreData/Entities`).

## 3. Architecture & technologies

- **UIKit + Core Data**, not SwiftUI/SwiftData — this is the older, legacy-style
  portfolio app; per project convention it stays UIKit/Core Data rather than
  being migrated.
- **Coordinator pattern** for navigation (`TaskListCoordinator`,
  `SettingsCoordinator`, `TaskDetailsCoordinator`, `CoordinatorFacade`), MVVM
  per screen (ViewController + ViewModel + Core Data-backed model).
- **UICollectionView with a diffable datasource** for the task list
  (`DatasourceSupervisor`, `UICollectionViewLayout+Extension`), replacing the
  old table-view/cell-factory approach from v2.
- **Core Data in an App Group container**, shared between the app and the
  widget extension — the single source of truth for both.
- **WidgetKit** extension target (`ShortlistWidgetExtension`) with
  `TimelineProvider` + `AppIntents` (`CompleteTaskIntent`) for interactive
  widgets.
- **UserNotifications** for local reminders/nudges; **CoreLocation** for
  destination geofencing.
- **RevenueCat SDK** for the Pro entitlement/paywall (in progress).
- **CocoaPods** (`Podfile`) for dependency management; **fastlane** for the
  release pipeline (`fastlane/Fastfile`, `Snapfile`, `Matchfile`).
- Tests: `ShortlistTests`, `ShortlistUITests` (existing XCTest-style setup,
  not yet Swift Testing).

## 4. Remaining work, in build order

This is PHASE 7 of `.story/roadmap.json` — App Store Release — tracked as
tickets T-001 through T-007:

1. **T-001 — App icon artwork.** 9 required sizes are missing in
   `AppIcon.appiconset`; needs a 1024×1024 master reflecting the v3 "3-goal,
   anti-abundance" identity, then generated into all slots.
2. **T-002 — Register the widget App ID** (`com.whizbang.shortlist.widget`) in
   App Store Connect with the `group.com.whizbang.Five` App Group capability —
   blocks provisioning.
3. **T-003 — `fastlane certs`** to sync App Store/dev/adhoc profiles for both
   the app and widget bundle IDs (blocked by T-002).
4. **T-004 — App Store metadata**: name, subtitle, description (leading with
   the 3-goal philosophy), keywords, support URL, what's-new copy, and privacy
   nutrition labels matching `PrivacyInfo.xcprivacy` (precise location + photos
   for app functionality, no tracking).
5. **T-005 — Screenshots** for the mandatory 6.9" and 6.5" device sizes via the
   `ScreenshotTester` scheme / `fastlane screenshots` (blocked by T-001, so the
   icon isn't blank in shots).
6. **T-006 — `fastlane release`** — build/upload v3.0.0 (build 59+), embed the
   widget, submit for review (blocked by T-003/T-004/T-005).
7. **T-007 — Finish RevenueCat wiring (in progress)** — replace the placeholder
   sandbox/production API keys with real ones from the RevenueCat dashboard,
   create the Pro offering + entitlement there, and confirm the purchase/
   restore flow end-to-end. Explicitly scoped as purchase-layer only — no UIKit
   rewrite.

Everything after T-007/T-006 is the App Store review process itself; there is
no further feature phase defined in the roadmap beyond shipping v3.0.0.
