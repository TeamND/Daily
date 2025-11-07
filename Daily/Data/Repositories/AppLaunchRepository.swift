//
//  AppLaunchRepository.swift
//  Daily
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

final class AppLaunchRepository: AppLaunchInterface {
    func getGoals() async -> [DailyGoalModel]? {
        await DailyDataSource.shared.getGoals()
    }
    
    func getRecords() async -> [DailyRecordModel]? {
        await DailyDataSource.shared.getRecords()
    }
    
    func addGoal(goal: DailyGoalModel) async {
        await DailyDataSource.shared.addGoal(goal: goal)
    }
    
    func addRecord(record: DailyRecordModel) async {
        await DailyDataSource.shared.addRecord(record: record)
    }
    
    func deleteGoal(goal: DailyGoalModel) async {
        await DailyDataSource.shared.deleteGoal(goal: goal)
    }
    
    func deleteRecord(record: DailyRecordModel) async {
        await DailyDataSource.shared.deleteRecord(record: record)
    }
    
    func updateData() async {
        await DailyDataSource.shared.updateData()
    }
    
    // MARK: - Legacy
    func getLegacyGoals() async -> [DailyGoalModel]? {
        await DailyDataSource.shared.getLegacyGoals()
    }
    
    func getLegacyRecords() async -> [DailyRecordModel]? {
        await DailyDataSource.shared.getLegacyRecords()
    }
    
    func deleteLegacyGoal(goal: DailyGoalModel) async {
        await DailyDataSource.shared.deleteLegacyGoal(goal: goal)
    }
    
    func deleteLegacyRecord(record: DailyRecordModel) async {
        await DailyDataSource.shared.deleteLegacyRecord(record: record)
    }
    
    func updateLegacyData() async {
        await DailyDataSource.shared.updateLegacyData()
    }
}
