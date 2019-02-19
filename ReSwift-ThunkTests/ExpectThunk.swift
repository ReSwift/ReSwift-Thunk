//
//  ExpectThunk.swift
//  ReSwift-Thunk-Tests
//
//  Created by Jason Prasad on 2/13/19.
//  Copyright © 2019 ReSwift. All rights reserved.
//

import XCTest
import ReSwift
import ReSwiftThunk

public class ExpectThunk<State: StateType> {
    public typealias DispatchAssertion = (Action) -> Void
    private var dispatchAssertions = [DispatchAssertion]()
    private var dispatch: DispatchFunction {
        return { action in
            let actionAssertion = self.dispatchAssertions.remove(at: 0)
            actionAssertion(action)
            if self.dispatchAssertions.count == 0 {
                self.expectation.fulfill()
            }
        }
    }
    private var expectation: XCTestExpectation
    private var providedStates = [State]()
    private var getState: () -> State? {
        return {
            if self.providedStates.count > 0 {
                return self.providedStates.removeFirst()
            } else {
                return nil
            }
        }
    }
    private let thunk: Thunk<State>
    public init(_ thunk: Thunk<State>, description: String? = nil) {
        self.thunk = thunk
        expectation = XCTestExpectation(description: description ?? "\(ExpectThunk.self)")
    }
}

extension ExpectThunk {
    public func dispatches<A: Action & Equatable>(_ expected: A, file: StaticString = #file, line: UInt = #line) -> Self {
        dispatchAssertions.append({ received in
            XCTAssert(received as? A == expected, "dispatched action does not equal expected: \(received) \(expected)", file: file, line: line)
        })
        return self
    }
    public func dispatches(_ matcher: @escaping DispatchAssertion) -> Self {
        dispatchAssertions.append(matcher)
        return self
    }
}

extension ExpectThunk {
    func getsState(_ state: State) -> Self {
        providedStates.append(state)
        return self
    }
}

extension ExpectThunk {
    func run() -> XCTestExpectation {
        let next: DispatchFunction = { _ in }
        let middleware = createThunksMiddleware()(dispatch, getState)(next)
        middleware(thunk)
        return expectation
    }
}
