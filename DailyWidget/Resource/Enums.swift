//
//  Enums.swift
//  DailyWidgetExtension
//
//  Created by seungyooooong on 1/4/25.
//

import SwiftUI

protocol Navigatable: Hashable {}

enum GoalTypes: String, CaseIterable, Codable {
    case check  // TODO: 추후 삭제
    case count
    case timer
}

enum CycleTypes: String, CaseIterable, Codable {
    case date = "date"
    case rept = "repeat"
    
    var text: String {
        switch self {
        case .date:
            return "날짜 선택"
        case .rept:
            return "요일 반복"
        }
    }
}

enum Symbols: String, CaseIterable, Codable {
    case all = "전체"
    case check = "체크"
    case training = "운동"
    case running = "런닝"
    case study = "공부"
    case keyboard = "키보드"
    case money = "돈"
    case heart = "하트"
    case star = "별"
    case couple = "커플"
    case people = "모임"
    
    func icon(isSuccess: Bool, isTransparent: Bool) -> ImageResource {
        switch self {
        case .check:
            if isTransparent { return isSuccess ? .checkTransparent : .checkYetTransparent }
            else { return isSuccess ? .check : .checkYet }
        case .training:
            if isTransparent { return isSuccess ? .trainingTransparent : .trainingYetTransparent }
            else { return isSuccess ? .training : .trainingYet }
        case .running:
            if isTransparent { return isSuccess ? .runningTransparent : .runningYetTransparent }
            else { return isSuccess ? .running : .runningYet }
        case .study:
            if isTransparent { return isSuccess ? .studyTransparent : .studyYetTransparent }
            else { return isSuccess ? .study : .studyYet }
        case .keyboard:
            if isTransparent { return isSuccess ? .keyboardTransparent : .keyboardYetTransparent }
            else { return isSuccess ? .keyboard : .keyboardYet }
        case .money:
            if isTransparent { return isSuccess ? .moneyTransparent : .moneyYetTransparent }
            else { return isSuccess ? .money : .moneyYet }
        case .heart:
            if isTransparent { return isSuccess ? .heartTransparent : .heartYetTransparent }
            else { return isSuccess ? .heart : .heartYet }
        case .star:
            if isTransparent { return isSuccess ? .starTransparent : .starYetTransparent }
            else { return isSuccess ? .star : .starYet }
        case .couple:
            if isTransparent { return isSuccess ? .coupleTransparent : .coupleYetTransparent }
            else { return isSuccess ? .couple : .coupleYet }
        case .people:
            if isTransparent { return isSuccess ? .groupTransparent : .groupYetTransparent }
            else { return isSuccess ? .group : .groupYet }
        default:
            if isTransparent { return isSuccess ? .checkTransparent : .checkYetTransparent }
            else { return isSuccess ? .check : .checkYet }
        }
    }
}

enum DayOfWeek: String, Codable, CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
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
}
