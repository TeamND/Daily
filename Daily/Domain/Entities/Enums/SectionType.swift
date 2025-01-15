//
//  SectionType.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

enum SectionType {
    case date
    case time
    case content
    case goalCount
    case symbol
    case count
    
    var title: String {
        switch self {
        case .date:
            return "날짜"
        case .time:
            return "시간"
        case .content:
            return "목표"
        case .goalCount:
            return "횟수"
        case .symbol:
            return "심볼"
        case .count:
            return "(기록 / 목표) 횟수"
        }
    }
    var isNew: Bool {
        switch self {
        case .date:
            return true
        default:
            return false
        }
    }
    var isEssential: Bool {
        switch self {
        case .content:
            return true
        default:
            return false
        }
    }
    var essentialConditionText: String {
        switch self {
        case .content:
            return "최소 두 글자 이상의 목표가 필요합니다."
        default:
            return "⚠️ warning"
        }
    }
}

