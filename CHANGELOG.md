# Upcoming

**Breaking API Changes:**

**API Changes:**

**Fixes:**

**Other:**

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
