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
    
    func fetchYearRecords(selection: String) -> [DailyRecordModel]? {
        let selections = CalendarServices.shared.separateSelection(selection)
        let startOfYear = calendar.date(from: DateComponents(year: selections[0], month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: selections[0], month: 12, day: 31))!
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfYear <= record.date && record.date <= endOfYear
            }
        )
        
        return try? context.fetch(descriptor)
    }
    
    func fetchMonthRecords(selection: String) -> [DailyRecordModel]? {
        let selections = CalendarServices.shared.separateSelection(selection)
        let startOfMonth = calendar.date(from: DateComponents(year: selections[0], month: selections[1], day: 1))!
        let endOfMonth = calendar.date(from: DateComponents(year: selections[0], month: selections[1] + 1, day: 1))!.addingTimeInterval(-1)
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfMonth <= record.date && record.date <= endOfMonth
            }
        )
        
        return try? context.fetch(descriptor)
    }
    
    func fetchWeekRecords(selection: String) -> [DailyRecordModel]? {
        let startDay = selection.toDate()!
        let endDay = calendar.date(byAdding: .day, value: 7, to: startDay)!
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startDay <= record.date && record.date < endDay
            }
        )
        
        return try? context.fetch(descriptor)
    }
    
    func fetchDayRecords(selection: String) -> [DailyRecordModel]? {
        let today = selection.toDate()!
        let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                today <= record.date && record.date < tommorow
            }
        )
        
        return try? context.fetch(descriptor)
    }
}
