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
    
    var contentHint: String {
        switch self {
        case .check:
            return "아침 7시에 일어나기 ☀️"
        case .count:
            return "물 2잔 이상 마시기 🚰"
        case .timer:
            return "자기 전 30분 책 읽기 📖"
        }
    }
}
