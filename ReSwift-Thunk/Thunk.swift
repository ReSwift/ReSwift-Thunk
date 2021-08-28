//
//  Thunk.swift
//  ReSwift-Thunk
//
//  Created by Daniel Martín Prieto on 01/11/2018.
//  Copyright © 2018 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

public struct Thunk<State>: Action, CustomStringConvertible {
    let body: (_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> State?) -> Void
    public let label: String?

    public init(label: String? = nil,
                body: @escaping (_ dispatch: @escaping DispatchFunction,
                                 _ getState: @escaping () -> State?) -> Void) {
        self.body = body
        self.label = label
    }

    public var description: String {
        let label = self.label.map { "label: \"\($0)\"" } ?? ""
        return "\(type(of: self))(\(label))"
    }
}

@available(*, deprecated, renamed: "Thunk")
typealias ThunkAction = Thunk
