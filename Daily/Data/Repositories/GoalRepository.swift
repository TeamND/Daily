//
//  GoalRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

class GoalRepository: GoalInterface {
    func updateData() async {
        await DailyDataSource.shared.updateData()
    }
    
    func addGoal(goal: DailyGoalModel) async {
        await DailyDataSource.shared.addGoal(goal: goal)
    }
    
    func addRecord(record: DailyRecordModel) async {
        await DailyDataSource.shared.addRecord(record: record)
    }
}
