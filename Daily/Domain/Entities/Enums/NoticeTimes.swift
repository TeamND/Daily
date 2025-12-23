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
            return "minutes".localized(5)
        case .ten:
            return "minutes".localized(10)
        case .thirty:
            return "minutes".localized(30)
        case .sixty:
            return "hour".localized(1)
        }
    }
}
