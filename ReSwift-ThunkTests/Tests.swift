//
//  ReSwift_ThunkTests.swift
//  ReSwift-ThunkTests
//
//  Created by Daniel Martín Prieto on 01/11/2018.
//  Copyright © 2018 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftThunk

import ReSwift

private struct FakeState: StateType {}
private struct FakeAction: Action, Equatable {}
private struct AnotherFakeAction: Action, Equatable {}
private func fakeReducer(action: Action, state: FakeState?) -> FakeState {
    return state ?? FakeState()
}

class Tests: XCTestCase {

    func testAction() {
        let middleware: Middleware<FakeState> = createThunksMiddleware()
        let dispatch: DispatchFunction = { _ in }
        let getState: () -> FakeState? = { nil }
        var nextCalled = false
        let next: DispatchFunction = { _ in nextCalled = true }
        let action = FakeAction()
        middleware(dispatch, getState)(next)(action)
        XCTAssert(nextCalled)
    }

    func testThunk() {
        let middleware: Middleware<FakeState> = createThunksMiddleware()
        let dispatch: DispatchFunction = { _ in }
        let getState: () -> FakeState? = { nil }
        var nextCalled = false
        let next: DispatchFunction = { _ in nextCalled = true }
        var thunkBodyCalled = false
        let thunk = Thunk<FakeState> { _, _ in
            thunkBodyCalled = true
        }
        middleware(dispatch, getState)(next)(thunk)
        XCTAssertFalse(nextCalled)
        XCTAssert(thunkBodyCalled)
    }

    func testMiddlewareInsertion() {
        let store = Store(
            reducer: fakeReducer,
            state: nil,
            middleware: [createThunksMiddleware()]
        )
        var thunkBodyCalled = false
        let thunk = Thunk<FakeState> { _, _ in
            thunkBodyCalled = true
        }
        store.dispatch(thunk)
        XCTAssertTrue(thunkBodyCalled)
    }
    
    func testExpectThunk() {
        let thunk = Thunk<FakeState> { dispatch, getState in
            dispatch(FakeAction())
            XCTAssertNotNil(getState())
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.5) {
                dispatch(AnotherFakeAction())
                XCTAssertNotNil(getState())
                XCTAssertNil(getState())
            }
            dispatch(FakeAction())
        }
        let expect = ExpectThunk<FakeState>(thunk)
            .dispatches(FakeAction())
            .getsState(FakeState())
            .dispatches {
                XCTAssert($0 as? FakeAction == FakeAction())
            }
            .dispatches(AnotherFakeAction())
            .getsState(FakeState())
            .run()
        /* NOTE: this will fail as it asserts order!
         let expect = ExpectThunk<FakeState>(thunk)
         .dispatches(FakeAction())
         .getsState(FakeState())
         .dispatches(AnotherFakeAction())
         .dispatches {
            XCTAssert($0 as? FakeAction == FakeAction())
         }
         .getsState(FakeState())
         .run()
         */
        wait(for: [expect], timeout: 1.0)
    }
}
