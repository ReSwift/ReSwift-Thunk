# Upcoming

**Breaking API Changes:**

**API Changes:**
- Add optional `label` property to `Thunk` that is used for the object `description`, e.g for logging/printing the thunk object (#50) - @DivineDominion

- Remove deprecated `StateType` protocol requirement (#48) - @DivineDominion, @mjarvis

**Fixes:**

# 2.0.1

**Fixes:**

- Fixes Carthage build error (#44) - @DivineDominion, @mjarvis

# 2.0.0

**Breaking API Changes:**
- Drop support for Swift 3.2, 4.0, and 4.1. (#45) - @shawnkoh, @mjarvis
- Drop support for iOS 8 (#45) - @shawnkoh, @mjarvis

**Other:**
- Rename SwiftPM library to `ReSwiftThunk`, this makes naming consistent across all package manager (Cocoapods, Carthage and SwiftPM) (#42) - @jookes
- `ExpectThunk`'s methods `dispatches` and `getsState` no longer have `@discardableResult` return values (#40) - @xavierLowmiller

# 1.2.0

**API Changes:**
- Renames `createThunksMiddleware` to `createThunkMiddleware` and adds deprecated forward for `createThunksMiddleware` (#20) - @fbernutz

**Other:**

- Adds `ExpectThunk` testing helper and corresponding CocoaPods subspec (#19, #37) - @jjgp, @okaverin
- Adds SwiftPM support (#21) - @jayhickey
- Require ReSwift 5.0 (#28) - @DivineDominion
- Specify all officially supported Swift versions in podspec (#38) - @okaverin

# 1.1.0

*Released: 01/16/2019*

**API Changes:**
- Renames `ThunkAction` to `Thunk`
- Renames `ThunkMiddleware()` to `createThunkMiddleware()`
- Adds deprecated forwards for `ThunkAction` and `ThunkMiddleware()`

**Other:**
- This project has been migrated from https://github.com/mikecole20/ReSwiftThunk/ along with some backwards-compatible API changes documented above.
