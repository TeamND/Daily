//
//  GoalTypes.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import Foundation

enum GoalTypes: String, CaseIterable, Codable {
    case check
    case count
    case timer
    
    var text: String {
        switch self {
        case .check, .count:
            return "카운트"
        case .timer:
            return "타이머"
        }
    }
}
