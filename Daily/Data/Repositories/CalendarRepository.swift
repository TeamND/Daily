//
//  CalendarRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarRepository: CalendarInterface {
    func getYearRecords(selection: String) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchYearRecords(selection: selection)
    }
    
    func getMonthRecords(selection: String) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchMonthRecords(selection: selection)
    }
    
    func getWeekRecords(selection: String) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchWeekRecords(selection: selection)
    }
    
    func getDayRecords(selection: String) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchDayRecords(selection: selection)
    }
}
