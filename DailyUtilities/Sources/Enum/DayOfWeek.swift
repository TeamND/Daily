//
//  DayOfWeek.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

public enum DayOfWeek: String, DailyTypes, CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    public var text: String {
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
    
    public var index: Int {
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
    
    public var fullText: String {
        switch self {
        case .sun:
            return "일요일"
        case .mon:
            return "월요일"
        default:
            return ""
        }
    }
}

extension DayOfWeek {
    public static func text(for index: Int) -> String? {
        guard let dayOfWeek = self.from(index: index) else { return nil }
        return dayOfWeek.text
    }
    
    public static func from(index: Int) -> DayOfWeek? {
        return self.allCases.first { $0.index == index }
    }
}
