//
//  CalendarRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarRepository: CalendarInterface {
    func getYearRecords(selection: String) async -> [DailyRecordModel]? {
        return await DailyDataSource.shared.fetchYearRecords(selection: selection)
    }
    
    func getMonthRecords(selection: String) async -> [DailyRecordModel]? {
        return await DailyDataSource.shared.fetchMonthRecords(selection: selection)
    }
    
    func getWeekRecords(selection: String) async -> [DailyRecordModel]? {
        return await DailyDataSource.shared.fetchWeekRecords(selection: selection)
    }
    
    func getDayRecords(selection: String) async -> [DailyRecordModel]? {
        return await DailyDataSource.shared.fetchDayRecords(selection: selection)
    }
    
    func getFutureRecords() async -> [DailyRecordModel]? {
        return await DailyDataSource.shared.fetchFutureRecords()
    }
    
    func updateData() async {
        await DailyDataSource.shared.updateData()
    }
    
    func deleteRecord(record: DailyRecordModel) async {
        await DailyDataSource.shared.deleteRecord(record: record)
    }
    
    func deleteGoal(goal: DailyGoalModel) async {
        await DailyDataSource.shared.deleteGoal(goal: goal)
    }
}
