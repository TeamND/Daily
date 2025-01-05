//
//  Bool+extension.swift
//  DailyUtilities
//
//  Created by seungyooooong on 1/5/25.
//

import Foundation

extension Bool: @retroactive Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        !lhs && rhs
    }
}
