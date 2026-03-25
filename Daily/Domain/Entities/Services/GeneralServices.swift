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
    static let week: Int = 7
    static let maxLineCount: Int = 6
    static let daySpacing: CGFloat = 12
    
    // MARK: - Record
    static func noRecordText(isEmpty: Bool) -> String {
        if isEmpty { return "no_goals_yet".localized }
        else { return "no_goals_match_the_selected_filter".localized }
    }
    static func noRecordDescriptionText(isEmpty: Bool) -> String {
        if isEmpty { return "add_a_goal_for_today".localized }
        else { return "try_adding_a_new_goal".localized }
    }
}
