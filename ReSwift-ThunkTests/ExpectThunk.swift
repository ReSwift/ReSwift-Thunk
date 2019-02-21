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

public class ExpectThunk<State: StateType> {
    public typealias DispatchAssertion = (Action) -> Void
    private var dispatchAssertions = [DispatchAssertion]()
    private var dispatch: DispatchFunction {
        return { action in
            guard self.dispatchAssertions.isEmpty == false else {
                return
            }
            self.dispatchAssertions.remove(at: 0)(action)
            if self.dispatchAssertions.isEmpty {
                self.expectation.fulfill()
            }
        }
    }
    private var expectation: XCTestExpectation
    private var providedStates = [State]()
    private var getState: () -> State? {
        return {
            return self.providedStates.isEmpty ? nil : self.providedStates.removeFirst()
        }
    }
    private let thunk: Thunk<State>
    public init(_ thunk: Thunk<State>, description: String? = nil) {
        self.thunk = thunk
        expectation = XCTestExpectation(description: description ?? "\(ExpectThunk.self)")
    }
}

extension ExpectThunk {
    public func dispatches<A: Action & Equatable>(_ expected: A,
                                                  file: StaticString = #file,
                                                  line: UInt = #line) -> Self {
        dispatchAssertions.append({ received in
            XCTAssert(
                received as? A == expected,
                "dispatched action does not equal expected: \(received) \(expected)",
                file: file,
                line: line
            )
        })
        return self
    }
    public func dispatches(_ matcher: @escaping DispatchAssertion) -> Self {
        dispatchAssertions.append(matcher)
        return self
    }
}

extension ExpectThunk {
    public func getsState(_ state: State) -> Self {
        providedStates.append(state)
        return self
    }
}

extension ExpectThunk {
    public func run() -> XCTestExpectation {
        createThunksMiddleware()(dispatch, getState)({ _ in })(thunk)
        return expectation
    }
}
