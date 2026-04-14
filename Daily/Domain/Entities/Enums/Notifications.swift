//
//  Notifications.swift
//  Daily
//
//  Created by seungyooooong on 2/5/26.
//

import Foundation

enum Notifications: CaseIterable {
    case noNotification
    case atTime
    case five
    case ten
    case thirty
    case sixty
    case custom
    
    var text: String {
        switch self {
        case .noNotification:
            "no_notification".localized
        case .atTime:
            "at_time".localized
        case .five:
            "before".localized("m".localized(5))
        case .ten:
            "before".localized("m".localized(10))
        case .thirty:
            "before".localized("m".localized(30))
        case .sixty:
            "before".localized("h".localized(1))
        case .custom:
            "custom".localized
        }
    }
    
    var noticeTime: Int? {
        switch self {
        case .atTime:
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
    static func noticeText(noticeTime: Int?, isPushNotice: Bool = false, isToast: Bool = false) -> String {
        guard let noticeTime else { return Notifications.noNotification.text }
        if let notifications = Self.allCases.first(where: { $0.noticeTime == noticeTime }) {
            if isPushNotice && notifications == .atTime { return "its_time".localized }
            if isToast && notifications == .atTime { return "at_the_set_time".localized }
            return isToast ? " " + notifications.text : notifications.text
        } else {    // MARK: .custom
            let h = noticeTime / 60
            let m = noticeTime % 60
            let noticeText = h == 0 ? "m".localized(m) : m == 0 ? "h".localized(h) : "\("h".localized(h)) \("m".localized(m))"
            return isToast ? " " + "before".localized(noticeText) : "before".localized(noticeText)
        }
    }
}
