//
//  CalendarType.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

enum CalendarType {
    case year
    case month
    case day
    
    var headerBackButton: String {
        switch self {
        case .year:
            return ""
        case .month:
            return "년"
        case .day:
            return "월"
        }
    }
    
    var headerTitle: String {
        switch self {
        case .year:
            return "년"
        case .month:
            return "월"
        case .day:
            return "일"
        }
    }
}
