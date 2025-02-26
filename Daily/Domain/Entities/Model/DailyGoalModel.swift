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
    var count: Int
    var isSetTime: Bool
    var setTime: String
    @Relationship(deleteRule: .cascade ,inverse: \DailyRecordModel.goal)
    var records: [DailyRecordModel]
    
    init(
        type: GoalTypes = .check,
        cycleType: CycleTypes = .date,
        content: String = "",
        symbol: Symbols = .check,
        count: Int = 1,
        isSetTime: Bool = false,
        setTime: String = "00:00",
        records: [DailyRecordModel] = []
    ) {
        self.type = type
        self.cycleType = cycleType
        self.content = content
        self.symbol = symbol
        self.count = count
        self.isSetTime = isSetTime
        self.setTime = setTime
        self.records = records
    }
    
    func copy() -> DailyGoalModel {
        return DailyGoalModel(
            type: self.type,
            cycleType: self.cycleType,
            content: self.content,
            symbol: self.symbol,
            count: self.count,
            isSetTime: self.isSetTime,
            setTime: self.setTime,
            records: self.records
        )
    }
}
