//
//  ExpectThunk.swift
//  ReSwift-Thunk-Tests
//
//  Created by Jason Prasad on 2/13/19.
//  Copyright © 2019 ReSwift. All rights reserved.
//

import XCTest
import ReSwift

@testable import ReSwiftThunk

class ExpectThunk<State: StateType>: XCTestExpectation {
    
    private typealias ActionMatcher = (Action) -> Void
    private var dispatch: DispatchFunction {
        return { action in
            let matcher = self.expectedActions.remove(at: 0)
            matcher(action)
            if self.expectedActions.count == 0 {
                self.fulfill()
            }
        }
    }
    private var expectedActions = [ActionMatcher]()
    private var expectedStates = [State]()
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
    
    init(_ thunk: Thunk<State>, description: String? = nil) {
        self.thunk = thunk
        
        super.init(description: description ?? "\(ExpectThunk.self)")
    }
    
    func run() -> Self {
        self.thunk.body(dispatch, getState)
        return self
    }
    
}

extension ExpectThunk {
    
    func dispatches<A: Action & Equatable>(_ expected: A, file: StaticString = #file, line: UInt = #line) -> Self {
        expectedActions.append({ received in
            XCTAssert(received as? A == expected, "dispatched action does not equal expected: \(received) \(expected)", file: file, line: line)
        })
        return self
    }
    
}

extension ExpectThunk {
    
    func getsState(_ state: State) -> Self {
        expectedStates.append(state)
        return self
    }
    
}
