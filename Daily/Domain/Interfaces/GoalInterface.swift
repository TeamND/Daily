//
//  GoalInterface.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

protocol GoalInterface {
    func updateData() async
    func addGoal(goal: DailyGoalModel) async
    func addRecord(record: DailyRecordModel) async
}
