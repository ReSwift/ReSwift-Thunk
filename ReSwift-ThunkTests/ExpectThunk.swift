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
    private let file: StaticString
    private let line: UInt

    init(file: StaticString, line: UInt, associated: T) {
        self.associated = associated
        self.file = file
        self.line = line
    }

    fileprivate func failed() {
        XCTFail("This never happened", file: file, line: line)
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
    public typealias DispatchAssertion = (Action) -> Void
    private var dispatchAssertions = [ExpectThunkAssertion<DispatchAssertion>]()
    public var dispatched = [Action]()
    private var expectation: XCTestExpectation?
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
    @discardableResult
    public func dispatches<A: Action & Equatable>(_ expected: A,
                                                  file: StaticString = #file,
                                                  line: UInt = #line) -> Self {
        dispatchAssertions.append(
            ExpectThunkAssertion(file: file, line: line) { received in
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

    @discardableResult
    public func dispatches(file: StaticString = #file,
                           line: UInt = #line,
                           dispatch assertion: @escaping DispatchAssertion) -> Self {
        dispatchAssertions.append(ExpectThunkAssertion(file: file, line: line, associated: assertion))
        return self
    }
}

extension ExpectThunk {
    @discardableResult
    public func getsState(_ state: State,
                          file: StaticString = #file,
                          line: UInt = #line) -> Self {
        getStateAssertions.append(ExpectThunkAssertion(file: file, line: line, associated: state))
        return self
    }
}

extension ExpectThunk {
    @discardableResult
    public func run(file: StaticString = #file, line: UInt = #line) -> Self {
        createThunksMiddleware()(dispatch, getState)({ _ in })(thunk)
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
            let result = XCTWaiter().wait(for: [expectation], timeout: seconds)
            if result != .completed {
                XCTFail("Asynchronous wait failed", file: file, line: line)
            }
            failLeftovers()
        }
        let dispatch: DispatchFunction = {
            self.dispatch($0)
            if self.dispatchAssertions.isEmpty == true {
                expectation.fulfill()
            }
        }
        createThunksMiddleware()(dispatch, getState)({ _ in })(thunk)
        return self
    }

    private func failLeftovers() {
        dispatchAssertions.forEach { $0.failed() }
        getStateAssertions.forEach { $0.failed() }
    }
}
