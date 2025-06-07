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
    var date: Date
    var isSuccess: Bool
    var count: Int
    var notice: Int?
    var startTime: Date?
    
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
    
    func copy(
        goal: DailyGoalModel? = nil,
        date: Date? = nil,
        isSuccess: Bool? = nil,
        count: Int? = nil,
        notice: Int? = nil,
        startTime: Date? = nil
    ) -> DailyRecordModel {
        DailyRecordModel(
            goal: goal ?? self.goal,
            date: date ?? self.date,
            isSuccess: isSuccess ?? self.isSuccess,
            count: count ?? self.count,
            notice: notice ?? self.notice,
            startTime: startTime ?? self.startTime
        )
    }
}
