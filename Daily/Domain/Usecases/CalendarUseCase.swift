//
//  CalendarUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarUseCase {
    private let repository: CalendarInterface
    
    init(repository: CalendarInterface) {
        self.repository = repository
    }
    
    func getRatingsOfYear(date: Date, selection: String) async -> [[Double]] {
        let records = await repository.getYearData(date: date, selection: selection)
        let calendar = CalendarManager.shared.getDailyCalendar()
        
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        records?.forEach { record in
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let normalizedDate = calendar.date(from: components) {
                recordsByDate[normalizedDate, default: []].append(record)
            }
        }
        
        var newRatings = Array(repeating: Array(repeating: 0.0, count: 31), count: 12)
        for (date, dayRecords) in recordsByDate {
            let successCount = dayRecords.filter { $0.isSuccess }.count
            let totalCount = dayRecords.count
            
            if totalCount > 0 {
                newRatings[date.month - 1][date.day - 1] = Double(successCount) / Double(totalCount)
            }
        }
        
        return newRatings
    }
}

