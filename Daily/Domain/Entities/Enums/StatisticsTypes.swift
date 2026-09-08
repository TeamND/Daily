//
//  StatisticsTypes.swift
//  Daily
//
//  Created by seungyooooong on 9/1/26.
//

import Foundation

enum StatisticsTypes {
    case daily
    case weekly
    case monthly
    case yearly
    
    var parameterValue: String {
        switch self {
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .monthly:
            return "monthly"
        case .yearly:
            return "yearly"
        }
    }
}
