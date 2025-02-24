//
//  CalendarRepository.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarRepository: CalendarInterface {
    func getYearData(date: Date, selection: String) async -> [DailyRecordModel]? {
        return await CalendarDataSource.shared.fetchYearData(date: date, selection: selection)
    }
}
