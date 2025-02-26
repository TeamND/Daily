//
//  DailyGoalModel.swift
//  DailyWidgetExtension
//
//  Created by seungyooooong on 1/4/25.
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
        type: GoalTypes,
        cycleType: CycleTypes,
        content: String,
        symbol: Symbols,
        count: Int,
        isSetTime: Bool,
        setTime: String,
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
}
