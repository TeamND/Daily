//
//  DailyAlert.swift
//  Daily
//
//  Created by seungyooooong on 12/30/24.
//

import Foundation

protocol DailyAlert {
    var titleText: String { get }
    var messageText: String { get }
}

// MARK: - CountAlert
enum CountAlert: DailyAlert {
    case tooSmallCount
    
    var titleText: String {
        switch self {
        case .tooSmallCount:
            return ""
        }
    }
    
    var messageText: String {
        switch self {
        case .tooSmallCount:
            return "최소한의 목표를 지정해주세요 🐥"
        }
    }
}

// MARK: - ContentAlert
enum ContentAlert: DailyAlert {
    case tooShoertLength
    
    var titleText: String {
        switch self {
        case .tooShoertLength:
            return "목표의 길이가 너무 짧아요 😵"
        }
    }
    
    var messageText: String {
        switch self {
        case .tooShoertLength:
            return "최소 2글자 이상의 목표를 설정해주세요"
        }
    }
}

// MARK: - DateAlert
enum DateAlert: DailyAlert {
    case wrongDateRange
    case overDateRange
    case emptySelectedWeekday
    case emptyRepeatDates
    
    var titleText: String {
        switch self {
        case .wrongDateRange:
            return "날짜 범위가 잘못 되었어요 🤯"
        case .overDateRange:
            return "날짜 범위를 초과했어요 🤢"
        case .emptySelectedWeekday:
            return "아직 반복 요일을 설정하지 않았어요 🧐"
        case .emptyRepeatDates:
            return ""
        }
    }
    
    var messageText: String {
        switch self {
        case .wrongDateRange:
            return "종료일은 시작일 이후로 설정해주세요"
        case .overDateRange:
            return "날짜 범위는 1년 이내로 설정해주세요"
        case .emptySelectedWeekday:
            return "반복 요일을 먼저 설정해주세요"
        case .emptyRepeatDates:
            return "유효한 날짜를 선택해주세요"
        }
    }
}

// MARK: - NoticeAlert
enum NoticeAlert: DailyAlert {
    case denied
    case dateChanged
    case setTimeChanged
    
    var titleText: String {
        switch self {
        case .denied:
            return "알림 설정이 꺼져있어, 일부 기능이 제한된 상태에요 😱"
        default:
            return ""
        }
    }
    
    var messageText: String {
        switch self {
        case .denied:
            return "Daily의 알림을 받아보세요 🙌🙌"
        case .dateChanged:
            return "목표 날짜가 변경되어 알림이 삭제되었어요 🫥"
        case .setTimeChanged:
            return "목표 시간이 변경되어 알림이 삭제되었어요 🫥"
        }
    }
    
    var primaryButtonText: String {
        switch self {
        case .denied:
            return "설정으로 이동"
        default:
            return ""
        }
    }
    
    var secondaryButtonText: String {
        switch self {
        case .denied:
            return "다음에 하기"
        default:
            return ""
        }
    }
}
