//
//  DailyGoalModel.swift
//  Daily
//
//  Created by seungyooooong on 12/3/24.
//

import Foundation
import SwiftData

@Model
class DailyGoalModel: Navigatable {
    var type: GoalTypes
    var cycleType: CycleTypes
    var content: String
    var symbol: Symbols
    var startDate: Date
    var endDate: Date
    var repeatDate: String
    var repeatDates: [String] {
        get {
            if let data = repeatDate.data(using: .utf8),
               let array = try? JSONDecoder().decode([String].self, from: data) {
                return array
            }
            return []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                repeatDate = string
            }
        }
    }
    var count: Int
    var isSetTime: Bool
    var setTime: String
    @Relationship(deleteRule: .cascade ,inverse: \DailyRecordModel.goal)
    var records: [DailyRecordModel]
    var childGoals: [DailyGoalModel]?
    
    init(
        type: GoalTypes,
        cycleType: CycleTypes,
        content: String,
        symbol: Symbols,
        startDate: Date,
        endDate: Date,
        repeatDates: [String] = [],
        count: Int,
        isSetTime: Bool,
        setTime: String,
        records: [DailyRecordModel] = [],
        childGoals: [DailyGoalModel]? = nil
    ) {
        self.type = type
        self.cycleType = cycleType
        self.content = content
        self.symbol = symbol
        self.startDate = startDate
        self.endDate = endDate
        if let data = try? JSONEncoder().encode(repeatDates),
           let repeatDate = String(data: data, encoding: .utf8) {
            self.repeatDate = repeatDate
        } else {
            self.repeatDate = "[]"
        }
        self.count = count
        self.isSetTime = isSetTime
        self.setTime = setTime
        self.records = records
        self.childGoals = childGoals
    }
}
