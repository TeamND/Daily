//
//  ViewTypes.swift
//  Daily
//
//  Created by seungyooooong on 2/24/25.
//

import Foundation

enum ViewTypes {
    case calendarMonth
    case calendarDay
    
    case goal
    case modify
    
    case setting
    case chart
    
    var calendarType: CalendarTypes? {
        switch self {
        case .calendarMonth:
            return .month
        case .calendarDay:
            return .day
        default:
            return nil
        }
    }
    
    var headerTitle: String {
        switch self {
        case .goal:
            return "add_goal".localized
        case .modify:
            return "edit_goal".localized
        default:
            return ""
        }
    }
    
    var trailingText: String {
        switch self {
        case .goal:
            return "add".localized
        case .modify:
            return "save".localized
        default:
            return ""
        }
    }
}
