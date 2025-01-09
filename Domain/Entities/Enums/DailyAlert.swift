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
            return "선택한 요일이 날짜 범위 안에 없어요 🫠"
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
            return "날짜 범위를 늘리거나 요일을 다시 설정해주세요"
        }
    }
}
