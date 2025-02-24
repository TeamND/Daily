//
//  CalendarUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/23/24.
//

import Foundation

final class CalendarUseCase {
    private let repository: CalendarInterface
    private let calendar: Calendar
    
    init(repository: CalendarInterface) {
        self.repository = repository
        self.calendar = CalendarManager.shared.getDailyCalendar()
    }
    
    func getRatingsOfYear(date: Date) async -> [[Double]] {
        let records = await repository.getYearRecords(date: date)
        let recordsByDate = getRecordsByDate(records: records)
        
        var ratingsOfYear = Array(repeating: Array(repeating: 0.0, count: 31), count: 12)
        for (date, dayRecords) in recordsByDate {
            let successCount = dayRecords.filter { $0.isSuccess }.count
            let totalCount = dayRecords.count
            
            if totalCount > 0 {
                ratingsOfYear[date.month - 1][date.day - 1] = Double(successCount) / Double(totalCount)
            }
        }
        
        return ratingsOfYear
    }
    
    func getMonthDatas(date: Date) async -> [MonthDataModel] {
        let records = await repository.getMonthRecords(date: date)
        let recordsByDate = getRecordsByDate(records: records)
        
        let startOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month, day: 1))!
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        
        var monthDatas: [MonthDataModel] = Array(repeating: MonthDataModel(), count: lengthOfMonth)
        for day in 1 ... lengthOfMonth {
            if let dayDate = calendar.date(from: DateComponents(year: date.year, month: date.month, day: day)),
               let dayRecords = recordsByDate[dayDate] {
                
                var dailySymbols: [DailySymbol] = []
                dayRecords.forEach { record in
                    if let goal = record.goal {
                        dailySymbols.append(DailySymbol(symbol: goal.symbol, isSuccess: record.isSuccess))
                    }
                }
                
                let rating = dayRecords.isEmpty ? 0.0 : Double(dayRecords.filter { $0.isSuccess }.count) / Double(dayRecords.count)
                monthDatas[day - 1] = MonthDataModel(symbol: dailySymbols, rating: rating)
            }
        }
        
        return monthDatas
    }
}

// MARK: - private func
extension CalendarUseCase {
    private func getRecordsByDate(records: [DailyRecordModel]?) -> [Date: [DailyRecordModel]] {
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        
        records?.forEach { record in
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let normalizedDate = calendar.date(from: components) {
                recordsByDate[normalizedDate, default: []].append(record)
            }
        }
        
        return recordsByDate
    }
}

