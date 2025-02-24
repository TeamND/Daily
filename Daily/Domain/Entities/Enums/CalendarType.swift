//
//  CalendarType.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

enum CalendarType: String, CaseIterable {
    case year
    case month
    case week
    case day
    
    var byAdding: Calendar.Component {
        switch self {
        case .year:
            return .year
        case .month:
            return .month
        case .week, .day:
            return .day
        }
    }
}
