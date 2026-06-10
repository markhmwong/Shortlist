# CLAUDE.md — Shortlist

Task / list app with an Apple Watch companion. SwiftUI + Combine, Coordinator navigation,
Core Data persistence, RevenueCat for Pro. Shares `WhizUtilKit`.

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

- **SwiftUI + Combine**, **Coordinator** navigation, **Core Data** persistence.
- **RevenueCat** via `ProFeatureManager` gates Pro features.
- WatchKit app mirrors core list functionality.

## Release (Xcode Cloud + Fastlane, metadata-only)

Builds, tests, TestFlight run on **Xcode Cloud**. **Fastlane is metadata-only** — the old
`beta`/build lanes were removed; fastlane never builds the binary. (Legacy `Matchfile`,
`gymfile`, `Snapfile` remain but are unused by the metadata lanes.) App Store text under
`fastlane/metadata/en-AU/`. Lanes: `download_meta`, `validate`, `deploy_metadata`,
`submit_for_review`. GitHub Actions validate metadata on PRs / deploy on push to `release`.
`ci_scripts` submodule posts Discord build notifications. See the `ios-release` skill.
`fastlane/api_key.json` (gitignored) → `~/Development/keys/AuthKey_89962V788Y.p8`.
