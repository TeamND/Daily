//
//  GeneralServices.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import Foundation

class GeneralServices {
    // MARK: - GoalCount
    static let minimumGoalCount: Int = 1
    static let maximumGoalCount: Int = 10
    
    // MARK: - Calendar
    static let today: String = "오늘"
    static let week: Int = 7
    
    // MARK: - Record
    static func noRecordText(isEmpty: Bool) -> String {
        if isEmpty { return "아직 목표가 없어요" }
        else { return "해당 조건에 맞는 목표가 없어요" }
    }
    static func noRecordDescriptionText(isEmpty: Bool) -> String {
        if isEmpty { return "오늘의 목표를 추가해보세요" }
        else { return "목표를 하나 더 추가해볼까요?" }
    }
}
