# ReSwift-Thunk

[![Build Status](https://img.shields.io/travis/ReSwift/ReSwift-Thunk/master.svg?style=flat-square)](https://travis-ci.org/ReSwift/ReSwift-Thunk) [![Code coverage status](https://img.shields.io/codecov/c/github/ReSwift/ReSwift-Thunk.svg?style=flat-square)](http://codecov.io/github/ReSwift/ReSwift-Thunk) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ReSwift-Thunk.svg?style=flat-square)](https://cocoapods.org/pods/ReSwift-Thunk) [![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos-lightgrey.svg?style=flat-square)](https://github.com/ReSwift/ReSwift-Thunk/blob/master/LICENSE.md) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/ReSwift/ReSwift-Thunk/blob/master/LICENSE.md) [![Reviewed by Hound](https://img.shields.io/badge/Reviewed_by-Hound-8E64B0.svg?style=flat-square)](https://houndci.com)

**Supported Swift Versions:** Swift 4.1, Swift 4.2

ReSwift-Thunk allows you to replace dispatching actions with dispatching blocks that perform synchronous or asynchronous work before they dispatch.

When [ReSwift](https://github.com/ReSwift/ReSwift/) is a [Redux](https://github.com/reactjs/redux)-like implementation of the unidirectional data flow architecture in Swift, ReSwift-Thunk is like [redux-thunk](https://github.com/reduxjs/redux-thunk). 

## Why Use ReSwift-Thunk?

In ReSwift, you should not write complex stuff in your reducers, but might be tempted to do so nevertheless. Where else should network requests go? Since reducers have access to the current state _and_ the incoming action, they seem promising at first. But reducers should be dumb and perform their work quickly to keep your app performant. So where else would you process complex actions?

Enter thunks.

1. **Save time and boilerplate code.** Some use cases involve complex asynchronous processes that are a pain to write with plain ReSwift. Think about changing a file from your app. Without thunks, a user interaction would have to (1) dispatch the change action to the store, then (2) a reducer would have to enqueue the change into the app state as a pending command. (3) The processor subscribes to the queue of pending file changes and performs the actual write to the disk, (4) dispatching a completion action which (5) get reduced to dequeuing the command from the app state. -- In some cases, you can get rid of all of this with a thunk that processes the file change. You can handle network requests in a similar fashion. Not all asynchronous requests should be treated this way, since you will want your app to be aware of some "waiting for server response" states, e.g. clearing a table view and displaying a loading indicator. But in case you don't need that, thunks are your friend!

2. **Handle async requests without blocking.** With ReSwift-Thunk, you create a `Thunk` object with a block that can dispatch an action any time. Thunks are handled by a middleware and are not supposed to be processed by reducers. That means if the work in your block takes a long time before you dispatch an action from it, it will not prevent the state from being updated. 

3. **React to responses in without much ceremony.** Since you initialize thunk objects with a closure, they have access to the call-site as well: you could delegate from the thunk's block back to a view controller method, e.g. for displaying an error in debug builds. ⚠️ Beware the temptation to write all your code this way, though: you should strive to dispatch actions and write your app using `StoreSubscriber`s to use the power of a central app state. When you bypass this from your thunks, you can make your data flow worse quickly.


## Example

```swift
// First, you create the middleware, which needs to know the type of your `State`.
let thunksMiddleware: Middleware<MyState> = createThunksMiddleware()

// Note that it can perfectly live with other middleware in the chain.
let store = Store<MyState>(reducer: reducer, state: nil, middleware: [thunksMiddleware])

// A thunk represents an action that can perform side effects, 
// access the current state of the store, and dispatch new actions, 
// as if it were a ReSwift middleware.
let thunk = Thunk<MyState> { dispatch, getState in 
    if getState!.loading {
        return
    }
    dispatch(RequestStart())
    api.getSomething() { something in
        if something != nil {
            dispatch(RequestSuccess(something))
        } else {
            dispatch(RequestError())
        }
    }
}

// As the thunk type conforms to the `Action` protocol, you can dispatch it 
// as usual, without having to implement an overload of the `dispatch` function 
// inside the ReSwift library.
store.dispatch(thunk)

// Note that this action won't reach the reducers, instead, the 
// thunks middleware will catch it and execute its body, 
// producing the desired side effects.
```

## Installation

ReSwift-Thunk requires the [ReSwift](https://github.com/ReSwift/ReSwift/) base module.

### CocoaPods

You can install ReSwift-Thunk via CocoaPods by adding it to your `Podfile`:
```
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'ReSwift'
pod 'ReSwift-Thunk'
```

And run `pod install`.

### Carthage

You can install ReSwift-Thunk via [Carthage](https://github.com/Carthage/Carthage) by adding the following line to your `Cartfile`:

```
github "ReSwift/ReSwift-Thunk"
```

### Swift Package Manager

You can install ReSwift-Thunk via [Swift Package Manager](https://swift.org/package-manager/) by adding the following line to your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    [...]
    dependencies: [
        .Package(url: "https://github.com/ReSwift/ReSwift-Thunk.git", majorVersion: XYZ)
    ]
)
```

## Checking out Source Code

After checking out the project run `pod install` to get the latest supported version of [SwiftLint](https://github.com/realm/SwiftLint), which we use to ensure a consistent style in the codebase.

## Contributing

You can find all the details on how to get started in the [Contributing Guide](/CONTRIBUTING.md).

## Credits

## License

ReSwift-Thunk Copyright (c) 2018 ReSwift Contributors. Distributed under the MIT License (MIT). See [LICENSE.md](/CONTRIBUTING.md).
