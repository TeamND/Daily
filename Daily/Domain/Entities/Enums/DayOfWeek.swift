//
//  DayOfWeek.swift
//  Daily
//
//  Created by seungyooooong on 12/17/25.
//

import Foundation

enum DayOfWeek: String, DailyTypes, Codable, CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var text: String {
        switch self {
        case .sun:
            return "sunday".localized
        case .mon:
            return "monday".localized
        default:
            return ""
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
    
    var txt: String {
        switch self {
        case .sun:
            return "sun".localized
        case .mon:
            return "mon".localized
        case .tue:
            return "tue".localized
        case .wed:
            return "wed".localized
        case .thu:
            return "thu".localized
        case .fri:
            return "fri".localized
        case .sat:
            return "sat".localized
        }
    }
}

extension DayOfWeek {
    static func txt(for index: Int) -> String? {
        guard let dayOfWeek = self.from(index: index) else { return nil }
        return dayOfWeek.txt
    }
    
    static func from(index: Int) -> DayOfWeek? {
        return self.allCases.first { $0.index == index }
    }
}
