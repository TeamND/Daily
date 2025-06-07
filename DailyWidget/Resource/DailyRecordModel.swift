//
//  DailyRecordModel.swift
//  DailyWidgetExtension
//
//  Created by seungyooooong on 1/4/25.
//

import Foundation
import SwiftData

@Model
class DailyRecordModel: Navigatable {
    var goal: DailyGoalModel?
    var date: Date
    var isSuccess: Bool
    var count: Int
    var notice: Int?
    var startTime: Date?
    
    init(
        goal: DailyGoalModel?,
        date: Date,
        isSuccess: Bool = false,
        count: Int = 0,
        notice: Int? = nil,
        startTime: Date? = nil
    ) {
        self.goal = goal
        self.date = date
        self.isSuccess = isSuccess
        self.count = count
        self.notice = notice
        self.startTime = startTime
    }
}
