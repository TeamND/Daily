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
//    var type: GoalTypes
    var typeRaw: String = GoalTypes.count.rawValue
//    var cycleType: CycleTypes
    var cycleTypeRaw: String = CycleTypes.date.rawValue
    var content: String = ""
//    var symbol: Symbols
    var symbolRaw: String = Symbols.check.rawValue
    var count: Int = 1
    var isSetTime: Bool = false
    var setTime: String = "00:00"
    @Relationship(deleteRule: .cascade ,inverse: \DailyRecordModel.goal)
    var records: [DailyRecordModel]? = []
    
    var type: GoalTypes {
        get { GoalTypes(rawValue: typeRaw) ?? .count }
        set { typeRaw = newValue.rawValue }
    }
    var cycleType: CycleTypes {
        get { CycleTypes(rawValue: cycleTypeRaw) ?? .date }
        set { cycleTypeRaw = newValue.rawValue }
    }
    var symbol: Symbols {
        get { Symbols(rawValue: symbolRaw) ?? .check }
        set { symbolRaw = newValue.rawValue }
    }
    
    init(
        type: GoalTypes = .count,
        cycleType: CycleTypes = .date,
        content: String = "",
        symbol: Symbols = .check,
        count: Int = 1,
        isSetTime: Bool = false,
        setTime: String = "00:00",
        records: [DailyRecordModel] = []
    ) {
//        self.type = type
        self.typeRaw = type.rawValue
//        self.cycleType = cycleType
        self.cycleTypeRaw = cycleType.rawValue
        self.content = content
//        self.symbol = symbol
        self.symbolRaw = symbol.rawValue
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
        setTime: String? = nil
    ) -> DailyGoalModel {
        DailyGoalModel(
            type: type ?? self.type,
            cycleType: cycleType ?? self.cycleType,
            content: content ?? self.content,
            symbol: symbol ?? self.symbol,
            count: count ?? self.count,
            isSetTime: isSetTime ?? self.isSetTime,
            setTime: setTime ?? self.setTime
        )
    }
}
