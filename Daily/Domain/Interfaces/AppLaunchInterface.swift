//
//  AppLaunchInterface.swift
//  Daily
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

protocol AppLaunchInterface {
    func getGoals() async -> [DailyGoalModel]?
    func getRecords() async -> [DailyRecordModel]?
    
    func addGoal(goal: DailyGoalModel) async
    func addRecord(record: DailyRecordModel) async
    
    func deleteGoal(goal: DailyGoalModel) async
    func deleteRecord(record: DailyRecordModel) async
    
    func updateData() async
    
    func getLegacyGoals() async -> [DailyGoalModel]?
    func getLegacyRecords() async -> [DailyRecordModel]?
    
    func deleteLegacyGoal(goal: DailyGoalModel) async
    func deleteLegacyRecord(record: DailyRecordModel) async
    
    func updateLegacyData() async
}
