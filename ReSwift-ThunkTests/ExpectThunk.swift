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
    public typealias ActionAssertion = (Action) -> Void
    private var dispatch: DispatchFunction {
        return { action in
            let actionAssertion = self.actionAssertions.remove(at: 0)
            actionAssertion(action)
            if self.actionAssertions.count == 0 {
                self.expectation.fulfill()
            }
        }
    }
    private var actionAssertions = [ActionAssertion]()
    private var expectedStates = [State]()
    private var expectation: XCTestExpectation
    private var getState: () -> State? {
        return {
            if self.expectedStates.count > 0 {
                return self.expectedStates.removeFirst()
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
        actionAssertions.append({ received in
            XCTAssert(received as? A == expected, "dispatched action does not equal expected: \(received) \(expected)", file: file, line: line)
        })
        return self
    }
    public func dispatches(_ matcher: @escaping ActionAssertion) -> Self {
        actionAssertions.append(matcher)
        return self
    }
}

extension ExpectThunk {
    func getsState(_ state: State) -> Self {
        expectedStates.append(state)
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
