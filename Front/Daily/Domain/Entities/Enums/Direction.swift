//
//  Direction.swift
//  Daily
//
//  Created by seungyooooong on 11/18/24.
//

import Foundation

enum Direction {
    case prev
    case next

    case minus
    case plus
    
    var value: Int {
        switch self {
        case .prev, .minus:
            return -1
        case .next, .plus:
            return 1
        }
    }
    
    var imageName: String {
        switch self {
        case .minus:
            return "minus.circle"
        case .plus:
            return "plus.circle"
        default:
            return ""
        }
    }
}
