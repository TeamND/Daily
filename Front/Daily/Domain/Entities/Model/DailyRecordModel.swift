//
//  DailyRecordModel.swift
//  Daily
//
//  Created by seungyooooong on 12/6/24.
//

import Foundation
import SwiftData

@Model
class DailyRecordModel {
    var goal: DailyGoalModel?
    var date: Date
    var isSuccess: Bool
    var count: Int
    
    init(goal: DailyGoalModel?, date: Date, isSuccess: Bool, count: Int) {
        self.goal = goal
        self.date = date
        self.isSuccess = isSuccess
        self.count = count
    }
}
