# CLAUDE.md — Shortlist

Daily 3-goal task app (v3, rebuilt from scratch). UIKit + MVVM-Coordinator, Core Data in the
`group.com.whizbang.Five` App Group, WidgetKit extension, RevenueCat for Pro. Shares `WhizUtilKit`.
UIKit app: don't migrate to SwiftUI unless asked.

## Project layout

```
Shortlist/
  Application Delegate/   # App/Scene delegates
  Coordinator/           # Navigation (Coordinator.swift)
  TaskList/, Task/, TaskDetails/, TaskList…   # Core task features
  Calendar/, Views/, BaseClasses/, Extensions/
  Model/                 # Core Data models
  ProFeatureManager/     # RevenueCat Pro gating
  SettingsManager/, Settings/, Settings List/
Shortlist WatchKit App/  # watchOS companion
ShortlistTests/, ShortlistUITests/
ScreenshotTester/        # Fastlane snapshot host
fastlane/                # Metadata-only (legacy match/snapshot files retained but unused)
ci_scripts/              # Shared submodule (added)
*.xcworkspace / *.xcodeproj
```

`WhizUtilKit` is a shared dependency (sibling repo `WhizUtil`).

## Build & run

Open the **workspace** `Shortlist.xcworkspace`. Scheme `Shortlist` (also `ShortlistWatchKitApp`,
`ScreenshotScheme`). Bundle ID `com.whizbang.shortlist`, team `GEKZN86RYS`.

```bash
xcodebuild -workspace Shortlist.xcworkspace -scheme Shortlist \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build
```

## Architecture

- **UIKit**, diffable collection views, **Coordinator** navigation, **Core Data** persistence.
- **RevenueCat** via `ProFeatureManager` gates Pro features.
- `ShortlistWidgetExtension` (bundle `com.whizbang.shortlist.widget`) reads the shared App Group store.

## Release (Xcode Cloud + Fastlane, metadata-only)

Builds, tests, TestFlight run on **Xcode Cloud**. **Fastlane is metadata-only** — the old
`beta`/build lanes were removed; fastlane never builds the binary. (Legacy `Matchfile`,
`gymfile`, `Snapfile` remain but are unused by the metadata lanes.) App Store text under
`fastlane/metadata/en-AU/`. Lanes: `download_meta`, `validate`, `deploy_metadata`,
`submit_for_review`. GitHub Actions validate metadata on PRs / deploy on push to `release`.
`ci_scripts` submodule posts Discord build notifications. See the `ios-release` skill.
`fastlane/api_key.json` (gitignored) → `~/Development/keys/AuthKey_89962V788Y.p8`.

## Branching

`main` ← `dev` ← `feature/<name>` (see the portfolio CLAUDE.md). Never commit to `main`; `origin/dev`
is the source of truth. Build number is `YYYYMMDD.X`; marketing version 3.0.0. App Store ID 1480090462.
