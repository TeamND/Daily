//
//  NoticeTimes.swift
//  Daily
//
//  Created by seungyooooong on 1/20/25.
//

import Foundation

enum NoticeTimes: Int, CaseIterable {
    case five = 5
    case ten = 10
    case thirty = 30
    case sixty = 60
    
    var text: String {
        switch self {
        case .five:
            return "5분"
        case .ten:
            return "10분"
        case .thirty:
            return "30분"
        case .sixty:
            return "1시간"
        }
    }
}
