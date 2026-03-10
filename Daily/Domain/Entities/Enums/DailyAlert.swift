//
//  DailyAlert.swift
//  Daily
//
//  Created by seungyooooong on 12/30/24.
//

import SwiftUI

protocol DailyAlert {
    var icon: ImageResource? { get }
    var titleText: String { get }
    var messageText: String { get }
}

// MARK: - CountAlert
enum CountAlert: DailyAlert {
    case tooSmallCount
    
    var icon: ImageResource? { return .notice }
    
    var titleText: String { return "" }
    
    var messageText: String {
        switch self {
        case .tooSmallCount:
            return "timer_must_be_at_least_1_second".localized
        }
    }
}

// MARK: - ContentAlert
enum ContentAlert: DailyAlert {
    case tooShoertLength
    
    var icon: ImageResource? { return .notice }
    
    var titleText: String { return "" }
    
    var messageText: String {
        switch self {
        case .tooShoertLength:
            return "enter_at_least_2_characters".localized
        }
    }
}

// MARK: - DateAlert
enum DateAlert: DailyAlert {
    case wrongDateRange
    case overDateRange
    case emptySelectedWeekday
    case emptyRepeatDates
    
    var icon: ImageResource? { return .notice }
    
    var titleText: String { return "" }
    
    var messageText: String {
        switch self {
        case .wrongDateRange:
            return "end_date_must_be_after_start_date".localized
        case .overDateRange:
            return "maximum_period_is_1_year".localized
        case .emptySelectedWeekday:
            return "select_at_least_one_day".localized
        case .emptyRepeatDates:
            return "repeat_day_not_within_selected_period".localized
        }
    }
}

// MARK: - NoticeAlert
enum NoticeAlert: DailyAlert {
    case deniedAtAppOpen
    case deniedAtSetTime
    case setNoticeTime(noticeTime: String)
    case removeNoticeTimeWithGoal
    
    var icon: ImageResource? {
        switch self {
        case .setNoticeTime, .removeNoticeTimeWithGoal:
            return .complete
        default:
            return nil
        }
    }
    
    var titleText: String {
        switch self {
        case .deniedAtAppOpen:
            return "notifications_are_off_so_some_features_are_limited".localized
        case .deniedAtSetTime:
            return "notifications_are_turned_off".localized
        default:
            return ""
        }
    }
    
    var messageText: String {
        switch self {
        case .deniedAtAppOpen:
            return "stay_on_track_with_reminders".localized
        case .deniedAtSetTime:
            return "please_allow_notifications_in_settings".localized
        case .setNoticeTime(let noticeTime):
            return "you_will_be_notified".localized(noticeTime)
        case .removeNoticeTimeWithGoal:
            return "notification_deleted_with_the_goal".localized
        }
    }
    
    var primaryButtonText: String {
        switch self {
        case .deniedAtAppOpen, .deniedAtSetTime:
            return "go_to_settings".localized
        default:
            return ""
        }
    }
    
    var secondaryButtonText: String {
        switch self {
        case .deniedAtAppOpen:
            return "remind_me_later".localized
        case .deniedAtSetTime:
            return "close".localized
        default:
            return ""
        }
    }
}

// MARK - SuccessAlert
enum SuccessAlert: DailyAlert {
    case addGoal
    
    var icon: ImageResource? { return .complete }
    
    var titleText: String { return "" }
    
    var messageText: String {
        switch self {
        case .addGoal:
            return "goal_added".localized
        }
    }
    
}
