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
        case .week:
            return "주간"
        case .day:
            return "일간"
        }
    }
    
    var navigationCount: Int {
        switch self {
        case .year:
            return 1
        case .month:
            return 2
        case .week, .day:
            return 3
        }
    }
    
    var chartUnit: String {
        switch self {
        case .year:
            return "올해"
        case .month:
            return "이번달"
        case .week:
            return "이번주"
        case .day:
            return "오늘"
        }
    }
    
    var dateFormat: DateFormats {
        switch self {
        case .year:
            return .year
        case .month:
            return .month
        case .week:
            return .week
        case .day:
            return .day
        }
    }
}

extension CalendarTypes {
    static func from(navigationCount: Int) -> CalendarTypes {
        return Self.allCases.reversed().first { $0.navigationCount == navigationCount } ?? .day
    }
}
