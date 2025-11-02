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
    var type: GoalTypes?
    var cycleType: CycleTypes?
    var content: String = ""
    var symbol: Symbols?
    var count: Int = 1
    var isSetTime: Bool = false
    var setTime: String = "00:00"
    @Relationship(deleteRule: .cascade ,inverse: \DailyRecordModel.goal)
    var records: [DailyRecordModel]? = []
    
    init(
        type: GoalTypes? = .count,
        cycleType: CycleTypes? = .date,
        content: String = "",
        symbol: Symbols? = .check,
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
    
    init(from temp: TempGoalModel) {
        self.type = temp.type
        self.cycleType = temp.cycleType
        self.content = temp.content
        self.symbol = temp.symbol
        self.count = temp.count
        self.isSetTime = temp.isSetTime
        self.setTime = temp.setTime
        self.records = temp.records
    }
}
