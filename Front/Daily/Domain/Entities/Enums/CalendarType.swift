//
//  CalendarType.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

enum CalendarType: String {
    case year
    case month
    case day
    
    var byAdding: Calendar.Component {
        switch self {
        case .year:
            return .year
        case .month:
            return .month
        case .day:
            return .day
        }
    }
}
