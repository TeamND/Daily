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
    
    func copy(
        type: GoalTypes? = nil,
        cycleType: CycleTypes? = nil,
        content: String? = nil,
        symbol: Symbols? = nil,
        count: Int? = nil,
        isSetTime: Bool? = nil,
        setTime: String? = nil,
        records: [DailyRecordModel]? = nil
    ) -> DailyGoalModel {
        DailyGoalModel(
            type: type ?? self.type,
            cycleType: cycleType ?? self.cycleType,
            content: content ?? self.content,
            symbol: symbol ?? self.symbol,
            count: count ?? self.count,
            isSetTime: isSetTime ?? self.isSetTime,
            setTime: setTime ?? self.setTime,
            records: records ?? self.records
        )
    }
}
