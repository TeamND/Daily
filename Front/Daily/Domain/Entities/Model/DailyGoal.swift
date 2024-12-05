//
//  DailyGoal.swift
//  Daily
//
//  Created by seungyooooong on 12/3/24.
//

import Foundation
import SwiftData

@Model
class DailyGoal {
    var date: Date
    var content: String
    var symbol: Symbols
    var goalType: GoalTypes
    var recordCount: Int
    var goalCount: Int
    var isSetTime: Bool
    var cycleType: CycleTypes
    var isSuccess: Bool
    
    init(
        date: Date,
        content: String,
        symbol: Symbols,
        goalType: GoalTypes,
        recordCount: Int,
        goalCount: Int,
        isSetTime: Bool,
        cycleType: CycleTypes,
        isSuccess: Bool = false
    ) {
        self.date = date
        self.content = content
        self.symbol = symbol
        self.goalType = goalType
        self.recordCount = recordCount
        self.goalCount = goalCount
        self.isSetTime = isSetTime
        self.cycleType = cycleType
        self.isSuccess = isSuccess
    }
}
