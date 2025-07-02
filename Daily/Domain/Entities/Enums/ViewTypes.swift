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
    
    var isCalendar: Bool {
        switch self {
        case .calendarMonth, .calendarDay:
            return true
        default:
            return false
        }
    }
    
    var headerTitle: String {
        switch self {
        case .goal:
            return "목표 추가"
        case .modify:
            return "목표 수정"
        default:
            return ""
        }
    }
    
    var trailingText: String {
        switch self {
        case .goal:
            return "추가"
        case .modify:
            return "수정"
        default:
            return ""
        }
    }
}
