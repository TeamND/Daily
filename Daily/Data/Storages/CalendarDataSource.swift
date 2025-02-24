//
//  CalendarDataSource.swift
//  Daily
//
//  Created by seungyooooong on 2/24/25.
//

import Foundation
import SwiftData

@MainActor
final class CalendarDataSource {
    static let shared = CalendarDataSource()
    
    private let context: ModelContext
    private let calendar: Calendar
    
    private init() {
        context = SwiftDataManager.shared.getContext()
        calendar = CalendarManager.shared.getDailyCalendar()
    }
    
    func fetchYearRecords(date: Date) -> [DailyRecordModel]? {
        let startOfYear = calendar.date(from: DateComponents(year: date.year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: date.year, month: 12, day: 31))!
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfYear <= record.date && record.date <= endOfYear
            }
        )
        
        return try? context.fetch(descriptor)
    }
    
    func fetchMonthRecords(date: Date) -> [DailyRecordModel]? {
        let startOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month, day: 1))!
        let endOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month + 1, day: 1))!.addingTimeInterval(-1)
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfMonth <= record.date && record.date <= endOfMonth
            }
        )
        
        return try? context.fetch(descriptor)
    }
}
