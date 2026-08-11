//
//  CycleTypes.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

enum CycleTypes: String, DailyTypes, Codable {
    case date = "date"  // FIXME: 추후에 single로 마이그레이션
    case rept = "repeat"
    
    var text: String {
        switch self {
        case .date:
            return "single_goal".localized
        case .rept:
            return "multi_goal".localized
        }
    }
    
    var parameterValue: String {
        switch self {
        case .date:
            return "single"
        case .rept:
            return "multiple"
        }
    }
}
