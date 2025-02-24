//
//  CalendarRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarRepository: CalendarInterface {
    func getYearRecords(date: Date) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchYearRecords(date: date)
    }
    
    func getMonthRecords(date: Date) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchMonthRecords(date: date)
    }
}
