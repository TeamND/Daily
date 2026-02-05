//
//  Notifications.swift
//  Daily
//
//  Created by seungyooooong on 2/5/26.
//

import Foundation

enum Notifications: CaseIterable {
    case noNotification
    case onTime
    case five
    case ten
    case thirty
    case sixty
    case custom
    
    var text: String {
        switch self {
        case .noNotification:
            "no_notification".localized
        case .onTime:
            "on_time".localized
        case .five:
            "before".localized("minutes".localized(5))
        case .ten:
            "before".localized("minutes".localized(10))
        case .thirty:
            "before".localized("minutes".localized(30))
        case .sixty:
            "before".localized("hour".localized(1))
        case .custom:
            "custom".localized
        }
    }
    
    var noticeTime: Int? {
        switch self {
        case .onTime:
            return 0
        case .five:
            return 5
        case .ten:
            return 10
        case .thirty:
            return 30
        case .sixty:
            return 60
        default:
            return nil
        }
    }
}

extension Notifications {
    static func from(noticeTime: Int?) -> Notifications {
        guard let noticeTime else { return .noNotification }
        return Self.allCases.first { $0.noticeTime == noticeTime } ?? .custom
    }
}
