//
//  AnalyticsEvent.swift
//  Daily
//
//  Created by seungyooooong on 7/15/26.
//

import FirebaseAnalytics

enum AnalyticsEvent {
    // MARK: - 앱 진입 / 종료
    case openApp
    case openFromWidget
    case openFromNotification
    case enterAppBackground
    
    // MARK: - 캘린더
    case openDailyCalendar
    case openMonthlyCalendar
    case openYearlyCalendar
    case navigateCalendar
    case navigateCalendarByButton
    
    // MARK: - 목표 생성 플로우
    case openGoalView
    case changeGoalType
    case changeGoalProgressDate
    case changeGoalProgressType
    case changeGoalNotification
    case saveGoalAttempt
    case saveGoalError
    case saveGoalSuccess
    
    // MARK: - 목표 관리
    case completeGoal
    case completeTimerGoal
    case deleteGoalAttempt
    
    // MARK: - 통계
    case openStatistics
    case changeStatisticsType
    
    // MARK: - 설정
    case openSettings
    case changeLanguage
}

extension AnalyticsEvent {
    var name: String {
        switch self {
            // MARK: - 앱 진입 / 종료
        case .openApp:
            return "open_app"
        case .openFromWidget:
            return "open_from_widget"
        case .openFromNotification:
            return "open_from_notification"
        case .enterAppBackground:
            return "enter_app_background"
            
            // MARK: - 캘린더
        case .openDailyCalendar:
            return "open_daily_calendar"
        case .openMonthlyCalendar:
            return "open_monthly_calendar"
        case .openYearlyCalendar:
            return "open_yearly_calendar"
        case .navigateCalendar:
            return "navigate_calendar"
        case .navigateCalendarByButton:
            return "navigate_calendar_by_button"
            
            // MARK: - 목표 생성 플로우
        case .openGoalView:
            return "open_goal_view"
        case .changeGoalType:
            return "change_goal_type"
        case .changeGoalProgressDate:
            return "change_goal_progress_date"
        case .changeGoalProgressType:
            return "change_goal_progress_type"
        case .changeGoalNotification:
            return "change_goal_notification"
        case .saveGoalAttempt:
            return "save_goal_attempt"
        case .saveGoalError:
            return "save_goal_error"
        case .saveGoalSuccess:
            return "save_goal_success"
            
            // MARK: - 목표 관리
        case .completeGoal:
            return "complete_goal"
        case .completeTimerGoal:
            return "complete_timer_goal"
        case .deleteGoalAttempt:
            return "delete_goal_attempt"
            
            // MARK: - 통계
        case .openStatistics:
            return "open_statistics"
        case .changeStatisticsType:
            return "change_statistics_type"
            
            // MARK: - 설정
        case .openSettings:
            return "open_settings"
        case .changeLanguage:
            return "change_language"
        }
    }
}
