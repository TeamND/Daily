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
}
