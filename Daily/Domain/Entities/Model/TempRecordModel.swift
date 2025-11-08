//
//  TempRecordModel.swift
//  Daily
//
//  Created by seungyooooong on 11/2/25.
//

import Foundation

struct TempRecordModel {
    var goal: DailyGoalModel?
    var date: Date = Date()
    var isSuccess: Bool = false
    var count: Int = 0
    var notice: Int? = nil
    var startTime: Date? = nil
    
    mutating func update(record: DailyRecordModel) {
        self.goal = record.goal
        self.date = record.date
        self.isSuccess = record.isSuccess
        self.count = record.count
        self.notice = record.notice
        self.startTime = record.startTime
    }
}
