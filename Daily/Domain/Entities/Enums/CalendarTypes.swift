//
//  CalendarTypes.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import SwiftUI

enum CalendarTypes: String, DailyTypes, Codable {
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
            return "year".localized
        case .month:
            return "month".localized
        case .week:
            return "week".localized
        case .day:
            return "day".localized
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
            return "this_year".localized
        case .month:
            return "this_month".localized
        case .week:
            return "this_week".localized
        case .day:
            return "today".localized
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
    
    var parameterValue: String {
        switch self {
        case .year:
            return "yearly"
        case .month:
            return "monthly"
        case .week, .day:
            return "weekly"
        }
    }
    
    var statisticsType: StatisticsTypes {
        switch self {
        case .year:
            return .yearly
        case .month:
            return .monthly
        case .week:
            return .weekly
        case .day:
            return .daily
        }
    }
}

extension CalendarTypes {
    static func from(navigationCount: Int) -> CalendarTypes {
        return Self.allCases.reversed().first { $0.navigationCount == navigationCount } ?? .day
    }
}
