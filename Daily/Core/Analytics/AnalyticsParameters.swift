//
//  AnalyticsParameters.swift
//  Daily
//
//  Created by seungyooooong on 7/31/26.
//

import Foundation

enum AnalyticsParameters {
    case direction(Direction)
    case calendar_type(CalendarTypes)
    case open_method(OpenMethod)
    
    case progress_type(GoalTypes)
    case notification_enabled(Bool)
}

extension AnalyticsParameters {
    var key: String {
        switch self {
        case .direction:
            return "direction"
        case .calendar_type:
            return "calendar_type"
        case .open_method:
            return "open_method"
            
        case .progress_type:
            return "progress_type"
        case .notification_enabled:
            return "notification_enabled"
        }
    }
    
    var value: Any {
        switch self {
        case .direction(let value):
            return value.parameterValue
        case .calendar_type(let value):
            return value.parameterValue
        case .open_method(let value):
            return value.parameterValue
            
        case .progress_type(let value):
            return value.parameterValue
        case .notification_enabled(let value):
            return String(value)
        }
    }
}


enum OpenMethod {
    case `default`
    case user_action
    
    var parameterValue: String {
        switch self {
        case .default:
            return "default"
        case .user_action:
            return "user_action"
        }
    }
}
