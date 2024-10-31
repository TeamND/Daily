//
//  GoalListOnDaysModel.swift
//  Daily
//
//  Created by seungyooooong on 10/31/24.
//

import Foundation

struct GoalListOnDaysModel {
    var daySelection: String
    var goalListOnDay: GoalListOnDayModel
    
    init(
        daySelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day),
        goalListOnDay: GoalListOnDayModel = GoalListOnDayModel()
    ) {
        self.daySelection = daySelection
        self.goalListOnDay = goalListOnDay
    }
}
