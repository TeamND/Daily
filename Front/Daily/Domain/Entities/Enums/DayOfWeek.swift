//
//  DayOfWeek.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

enum DayOfWeek: String, CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    // TODO: 추후 UserDefaults 추가 시 세분화
    var text: String {
        switch self {
        case .sun:
            return "일"
        case .mon:
            return "월"
        case .tue:
            return "화"
        case .wed:
            return "수"
        case .thu:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        }
    }
    
    var index: Int {
        switch self {
        case .sun:
            return 0
        case .mon:
            return 1
        case .tue:
            return 2
        case .wed:
            return 3
        case .thu:
            return 4
        case .fri:
            return 5
        case .sat:
            return 6
        }
    }
}
