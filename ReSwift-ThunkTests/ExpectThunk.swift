//
//  ExpectThunk.swift
//  ReSwift-Thunk-Tests
//
//  Created by Jason Prasad on 2/13/19.
//  Copyright © 2019 ReSwift. All rights reserved.
//

import XCTest
import ReSwift

#if RESWIFT_THUNKTESTS
import ReSwiftThunk
#endif

private struct ExpectThunkAssertion<T> {
    fileprivate let associated: T
    private let description: String
    private let file: StaticString
    private let line: UInt

    init(description: String, file: StaticString, line: UInt, associated: T) {
        self.associated = associated
        self.description = description
        self.file = file
        self.line = line
    }

    fileprivate func failed() {
        XCTFail(description, file: file, line: line)
    }
}

public class ExpectThunk<State: StateType> {
    private var dispatch: DispatchFunction {
        return { action in
            self.dispatched.append(action)
            guard self.dispatchAssertions.isEmpty == false else {
                return
            }
            self.dispatchAssertions.remove(at: 0).associated(action)
        }
    }
    private var dispatchAssertions = [ExpectThunkAssertion<DispatchFunction>]()
    public var dispatched = [Action]()
    private var getState: () -> State? {
        return {
            return self.getStateAssertions.isEmpty ? nil : self.getStateAssertions.removeFirst().associated
        }
    }
    private var getStateAssertions = [ExpectThunkAssertion<State>]()
    private let thunk: Thunk<State>

    public init(_ thunk: Thunk<State>) {
        self.thunk = thunk
    }
}

extension ExpectThunk {
    public func dispatches<A: Action & Equatable>(_ expected: A,
                                                  file: StaticString = #file,
                                                  line: UInt = #line) -> Self {
        dispatchAssertions.append(
            ExpectThunkAssertion(
                description: "Unfulfilled dispatches: \(expected)",
                file: file,
                line: line
            ) { received in
                XCTAssert(
                    received as? A == expected,
                    "Dispatched action does not equal expected: \(received) \(expected)",
                    file: file,
                    line: line
                )
            }
        )
        return self
    }

    public func dispatches(file: StaticString = #file,
                           line: UInt = #line,
                           dispatch assertion: @escaping DispatchFunction) -> Self {
        dispatchAssertions.append(
            ExpectThunkAssertion(
                description: "Unfulfilled dispatches: dispatch assertion",
                file: file,
                line: line,
                associated: assertion
            )
        )
        return self
    }
}

extension ExpectThunk {
    public func getsState(_ state: State,
                          file: StaticString = #file,
                          line: UInt = #line) -> Self {
        getStateAssertions.append(
            ExpectThunkAssertion(
                description: "Unfulfilled getsState: \(state)",
                file: file,
                line: line,
                associated: state
            )
        )
        return self
    }
}

extension ExpectThunk {
    @discardableResult
    public func run(file: StaticString = #file, line: UInt = #line) -> Self {
        createThunkMiddleware()(dispatch, getState)({ _ in })(thunk)
        failLeftovers()
        return self
    }

    @discardableResult
    public func wait(timeout seconds: TimeInterval = 1,
                     file: StaticString = #file,
                     line: UInt = #line,
                     description: String = "\(ExpectThunk.self)") -> Self {
        let expectation = XCTestExpectation(description: description)
        defer {
            if XCTWaiter().wait(for: [expectation], timeout: seconds) != .completed {
                XCTFail("Asynchronous wait failed: unfulfilled dispatches", file: file, line: line)
            }
            failLeftovers()
        }
        let dispatch: DispatchFunction = {
            self.dispatch($0)
            if self.dispatchAssertions.isEmpty == true {
                expectation.fulfill()
            }
        }
        createThunkMiddleware()(dispatch, getState)({ _ in })(thunk)
        return self
    }

    private func failLeftovers() {
        dispatchAssertions.forEach { $0.failed() }
        getStateAssertions.forEach { $0.failed() }
    }
}
