//
//  AnalyticsEvent.swift
//  Daily
//
//  Created by seungyooooong on 7/15/26.
//

import FirebaseAnalytics

enum AnalyticsEvent {
    // MARK: - 앱 진입 / 종료
    case appOpen
    case openFromWidget
    case openFromNotification
    case appClose   // FIXME: background 진입 이벤트로 수정
    
    // MARK: - 캘린더
    case viewDailyCalendar  // FIXME: 삭제 예정
    case viewWeeklyCalendar
    case viewMonthlyCalendar
    case viewYearlyCalendar
    case navigateCalendarByButton   // FIXME: 방향과 달력의 타입을 파라미터로 추가
    case navigateCalendarBySwipe    // FIXME: 방향과 달력의 타입을 파라미터로 추가
    
    // MARK: - 목표 생성 플로우
    case openGoalCreate
    case changeGoalType_single
    case changeGoalType_repeat
    case changeGoalTitle
    case changeGoalDate
    case changeGoalRepeat
    case changeGoalTimer
    case enableGoalNotification
    case disableGoalNotification
    case saveGoalAttempt
    case saveGoalError
    case createGoalComplete
    case cancelGoalCreate
    
    // MARK: - 목표 관리
    case completeGoal
    case completeTimerGoal
    case editGoal
    case deleteGoal
    
    // MARK: - 알림
    case enableNotification
    case disableNotification
    case notificationClick
    
    // MARK: - 통계
    case viewStatistics
    case viewDailyStatistics
    case viewWeeklyStatistics
    case viewMonthlyStatistics
    case viewYearlyStatistics
    
    // MARK: - 설정
    case openSettings
    case changeLanguage
}

extension AnalyticsEvent {
    var name: String {
        switch self {
            // MARK: - 앱 진입 / 종료
        case .appOpen:
            return "app_open"
        case .openFromWidget:
            return "open_from_widget"
        case .openFromNotification:
            return "open_from_notification"
        case .appClose:
            return "app_close"
            
            // MARK: - 캘린더
        case .viewDailyCalendar:
            return "view_daily_calendar"
        case .viewWeeklyCalendar:
            return "view_weekly_calendar"
        case .viewMonthlyCalendar:
            return "view_monthly_calendar"
        case .viewYearlyCalendar:
            return "view_yearly_calendar"
        case .navigateCalendarByButton:
            return "navigate_calendar_by_button"
        case .navigateCalendarBySwipe:
            return "navigate_calendar_by_swipe"
            
            // MARK: - 목표 생성 플로우
        case .openGoalCreate:
            return "open_goal_create"
        case .changeGoalType_single:
            return "change_goal_type_single"
        case .changeGoalType_repeat:
            return "change_goal_type_repeat"
        case .changeGoalTitle:
            return "change_goal_title"
        case .changeGoalDate:
            return "change_goal_date"
        case .changeGoalRepeat:
            return "change_goal_repeat"
        case .changeGoalTimer:
            return "change_goal_timer"
        case .enableGoalNotification:
            return "enable_goal_notification"
        case .disableGoalNotification:
            return "disable_goal_notification"
        case .saveGoalAttempt:
            return "save_goal_attempt"
        case .saveGoalError:
            return "save_goal_error"
        case .createGoalComplete:
            return "create_goal_complete"
        case .cancelGoalCreate:
            return "cancel_goal_create"
            
            // MARK: - 목표 관리
        case .completeGoal:
            return "complete_goal"
        case .completeTimerGoal:
            return "complete_timer_goal"
        case .editGoal:
            return "edit_goal"
        case .deleteGoal:
            return "delete_goal"
            
            // MARK: - 알림
        case .enableNotification:
            return "enable_notification"
        case .disableNotification:
            return "disable_notification"
        case .notificationClick:
            return "notification_click"
            
            // MARK: - 통계
        case .viewStatistics:
            return "view_statistics"
        case .viewDailyStatistics:
            return "view_daily_statistics"
        case .viewWeeklyStatistics:
            return "view_weekly_statistics"
        case .viewMonthlyStatistics:
            return "view_monthly_statistics"
        case .viewYearlyStatistics:
            return "view_yearly_statistics"
            
            // MARK: - 설정
        case .openSettings:
            return "open_settings"
        case .changeLanguage:
            return "change_language"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
}
