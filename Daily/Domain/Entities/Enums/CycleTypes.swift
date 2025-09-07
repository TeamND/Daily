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
            return "단일 목표"
        case .rept:
            return "다중 목표"
        }
    }
}
