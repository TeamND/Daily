//
//  DailyRecordModel.swift
//  Daily
//
//  Created by seungyooooong on 12/6/24.
//

import Foundation
import SwiftData

@Model
class DailyRecordModel: Navigatable {
    var goal: DailyGoalModel?
    var date: Date = Date()
    var isSuccess: Bool = false
    var count: Int = 0
    var notice: Int? = nil
    var startTime: Date? = nil
    
    init(
        goal: DailyGoalModel? = nil,
        date: Date = Date(format: .daily),
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
    
    init(from temp: TempRecordModel) {
        self.goal = temp.goal
        self.date = temp.date
        self.isSuccess = temp.isSuccess
        self.count = temp.count
        self.notice = temp.notice
        self.startTime = temp.startTime
    }
}
