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
    
    case progress_type(GoalTypes)
    case notification_enabled(Bool)
    
    case goal_action(ViewTypes)
    case goal_type(CycleTypes)
    
    case delete_scope(DeleteScope)
}

extension AnalyticsParameters {
    var key: String {
        switch self {
        case .direction:
            return "direction"
        case .calendar_type:
            return "calendar_type"
            
        case .progress_type:
            return "progress_type"
        case .notification_enabled:
            return "notification_enabled"
            
        case .goal_action:
            return "goal_action"
        case .goal_type:
            return "goal_type"
            
        case .delete_scope:
            return "delete_scope"
        }
    }
    
    var value: Any {
        switch self {
        case .direction(let value):
            return value.parameterValue
        case .calendar_type(let value):
            return value.parameterValue
            
        case .progress_type(let value):
            return value.parameterValue
        case .notification_enabled(let value):
            return String(value)
            
        case .goal_action(let value):
            return value.parameterValue
        case .goal_type(let value):
            return value.parameterValue
            
        case .delete_scope(let value):
            return value.parameterValue
        }
    }
}
