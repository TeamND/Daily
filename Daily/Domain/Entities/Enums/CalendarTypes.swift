//
//  CalendarTypes.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import SwiftUI

enum CalendarTypes: String, CaseIterable {
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
    
    func icon(isSelected: Bool) -> ImageResource {
        switch self {
        case .year:
            return isSelected ? .yearSelected : .year
        case .month:
            return isSelected ? .monthSelected : .month
        case .week, .day:
            return isSelected ? .daySelected : .day
        }
    }
    
    var text: String {
        switch self {
        case .year:
            return "연간"
        case .month:
            return "월간"
        case .week, .day:
            return "일간"
        }
    }
}
