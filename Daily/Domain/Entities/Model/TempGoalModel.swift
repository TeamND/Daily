//
//  TempGoalModel.swift
//  Daily
//
//  Created by seungyooooong on 11/2/25.
//

import Foundation

struct TempGoalModel {
    var type: GoalTypes?
    var cycleType: CycleTypes?
    var content: String = ""
    var symbol: Symbols?
    var count: Int = 1
    var isSetTime: Bool = false
    var setTime: String = "00:00"
    var records: [DailyRecordModel]? = []
    
    mutating func update(goal: DailyGoalModel) {
        self.type = goal.type
        self.cycleType = goal.cycleType
        self.content = goal.content
        self.symbol = goal.symbol
        self.count = goal.count
        self.isSetTime = goal.isSetTime
        self.setTime = goal.setTime
        self.records = goal.records
    }
}
