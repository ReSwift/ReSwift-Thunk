# Upcoming

**Breaking API Changes:**

**API Changes:**
- Renames `createThunksMiddleware` to `createThunkMiddleware` and adds deprecated forward for `createThunksMiddleware` (#20) - @fbernutz

**Fixes:**

**Other:**

- Adds `ExpectThunk` testing helper and corresponding CocoaPods subspec (#19) -- @jjgp
- Adds SwiftPM support (#21) - @jayhickey

# 1.1.0

*Released: 01/16/2019*

**API Changes:**
- Renames `ThunkAction` to `Thunk`
- Renames `ThunkMiddleware()` to `createThunkMiddleware()`
- Adds deprecated forwards for `ThunkAction` and `ThunkMiddleware()`

**Other:**
- This project has been migrated from https://github.com/mikecole20/ReSwiftThunk/ along with some backwards-compatible API changes documented above.
