//
//  WeekIndicatorModes.swift
//  Daily
//
//  Created by seungyooooong on 10/26/24.
//

import Foundation

enum WeekIndicatorModes {
    case select
    case change
    case none
    
    var hasPointText: Bool {
        switch self {
        case .change:
            return true
        default:
            return false
        }
    }
}
