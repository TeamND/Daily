//
//  DailyCalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI
import SwiftData

class DailyCalendarViewModel: ObservableObject {
    private let calendarUseCase: CalendarUseCase
    private var calendar = Calendar.current

    @Published var currentDate: Date = Date()
    @Published var yearDictionary: [String: [[Double]]] = [:]
    @Published var monthDictionary: [String: [MonthDatas]] = [:]
    @Published var isShowWeeklySummary: Bool = false
    
    func bindSelection(type: CalendarType) -> Binding<String> {
        Binding(
            get: { self.currentDate.getSelection(type: type) },
            set: { self.setDate(selection: $0) }
        )
    }
    
    func setDate(selection: String) {
        let selections = CalendarServices.shared.separateSelection(selection)
        self.setDate(year: selections[0], month: selections[safe: 1], day: selections[safe: 2])
    }
    func setDate(year: Int, month: Int? = nil, day: Int? = nil) {
        let month = month ?? 1
        let day = day ?? (year == Date().year && month == Date().month ? Date().day : 1)
        currentDate = CalendarServices.shared.getDate(year: year, month: month, day: day) ?? Date()
    }
    func setDate(byAdding: Calendar.Component, value: Int) {
        currentDate = calendar.date(byAdding: byAdding, value: value, to: currentDate) ?? Date()
    }
    func setDate(date: Date) {
        currentDate = date.startOfDay()
    }
    
    // MARK: - init
    init() {
        self.calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    func loadText(type: CalendarType, direction: Direction) -> String {
        switch type {
        case .year:
            let decade = (currentDate.year / 10 + direction.value) * 10
            return "\(String(decade))년대"
        case .month:
            let year = currentDate.year + direction.value
            return "\(String(year))년"
        case .day:
            let date = calendar.date(byAdding: .day, value: direction.value, to: currentDate) ?? Date()
            return "\(date.month)월 \(date.weekOfMonth)주차"
        }
    }
    
    // MARK: - onAppear
    func calendarYearOnAppear(modelContext: ModelContext, date: Date, selection: String) {
        let startOfYear = calendar.date(from: DateComponents(year: date.year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: date.year, month: 12, day: 31))!
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfYear <= record.date && record.date <= endOfYear
            }
        )
        
        guard let records = try? modelContext.fetch(descriptor) else { return }
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        records.forEach { record in
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
        
        yearDictionary[selection] = newRatings
    }
    func calendarMonthOnAppear(modelContext: ModelContext, date: Date, selection: String) {
        let startOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month, day: 1))!
        let endOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month + 1, day: 1))!.addingTimeInterval(-1)
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfMonth <= record.date && record.date <= endOfMonth
            }
        )
        
        guard let records = try? modelContext.fetch(descriptor) else { return }
        var recordsByDate: [Date: [DailyRecordModel]] = [:]
        records.forEach { record in
            let components = calendar.dateComponents([.year, .month, .day], from: record.date)
            if let normalizedDate = calendar.date(from: components) {
                recordsByDate[normalizedDate, default: []].append(record)
            }
        }
        
        var monthDatas: [MonthDatas] = Array(repeating: MonthDatas(), count: lengthOfMonth)
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
                monthDatas[day - 1] = MonthDatas(symbol: dailySymbols, rating: rating)
            }
        }
        
        monthDictionary[selection] = monthDatas
    }
    
    // MARK: - get info func
    func getCalendarInfo(type: CalendarType, index: Int) -> (date: Date, direction: Direction, selection: String) {
        let offset: Int = type == .year ? currentDate.year % 10 : type == .month ? (currentDate.month - 1) : (currentDate.weekday - 1)
        let date: Date = calendar.date(byAdding: type.byAdding, value: index - offset, to: currentDate) ?? Date()
        
        let maxIndex = type == .year ? 10 : type == .month ? 12 : 7
        let direction: Direction = index < 0 ? .prev : index < maxIndex ? .current : .next
        
        return (date, direction, date.getSelection(type: type))
    }
    func getMonthInfo(date: Date) -> (startOfMonthWeekday: Int, lengthOfMonth: Int, dividerCount: Int) {
        let startOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month, day: 1))!
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        let dividerCount = (lengthOfMonth + (startOfMonth.weekday - 1) - 1) / 7
        return (startOfMonth.weekday, lengthOfMonth, dividerCount)
    }
    
    // MARK: - header func
    func headerText(type: CalendarType, textPosition: TextPositionInHeader = .title) -> String {
        switch type {
        case .year:
            return textPosition == .title ? String(self.currentDate.year) + "년" : ""
        case .month:
            return textPosition == .title ? String(self.currentDate.month) + "월" : String(self.currentDate.year) + "년"
        case .day:
            return textPosition == .title ? String(self.currentDate.day) + "일" : String(self.currentDate.month) + "월"
        }
    }

    // MARK: - Query filter
    static func recordsForDateDescriptor(_ date: Date) -> FetchDescriptor<DailyRecordModel> {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let descriptor = FetchDescriptor<DailyRecordModel>(
            predicate: #Predicate<DailyRecordModel> { record in
                startOfDay <= record.date && record.date < endOfDay
            }
        )
        return descriptor
    }
    
    static func recordsForWeekDescriptor(_ date: Date) -> FetchDescriptor<DailyRecordModel> {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -(date.weekday - 1), to: date)!
        let endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        
        let predicate = #Predicate<DailyRecordModel> { record in
            startDate <= record.date && record.date < endDate
        }
        
        return FetchDescriptor<DailyRecordModel>(predicate: predicate)
    }
}
