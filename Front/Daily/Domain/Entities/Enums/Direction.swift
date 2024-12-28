//
//  Direction.swift
//  Daily
//
//  Created by seungyooooong on 11/18/24.
//

import Foundation

enum Direction: String {
    case prev = "<"
    case current = "|"
    case next = ">"

    case minus = "-"
    case plus = "+"
    
    var value: Int {
        switch self {
        case .prev, .minus:
            return -1
        case .current:
            return 0
        case .next, .plus:
            return 1
        }
    }
    
    var imageName: String {
        switch self {
        case .prev:
            return "chevron.left.2"
        case .next:
            return "chevron.right.2"
        case .minus:
            return "minus.circle"
        case .plus:
            return "plus.circle"
        default:
            return ""
        }
    }
}
