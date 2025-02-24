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
    private init() { }
    
    func fetchYearData(date: Date, selection: String) -> [DailyRecordModel]? {
        let context = SwiftDataManager.shared.getContext()
        let calendar = CalendarManager.shared.getDailyCalendar()
        
        let startOfYear = calendar.date(from: DateComponents(year: date.year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: date.year, month: 12, day: 31))!
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfYear <= record.date && record.date <= endOfYear
            }
        )
        
        return try? context.fetch(descriptor)
    }
}
