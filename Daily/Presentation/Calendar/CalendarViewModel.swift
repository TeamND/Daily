//
//  CalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI
import SwiftData

final class CalendarViewModel: ObservableObject {
    private let calendarUseCase: CalendarUseCase
    
    private var calendar = Calendar.current

    @Published var currentDate: Date = Date(format: .daily)
    @Published var yearDictionary: [String: [[Double]]] = [:]
    @Published var monthDictionary: [String: [MonthDataModel]] = [:]
    @Published var isShowWeeklySummary: Bool = false
    
    func bindSelection(type: CalendarType) -> Binding<String> {
        Binding(
            get: { self.currentDate.getSelection(type: type) },
            set: { self.setDate(selection: $0) }
        )
    }
    
    // MARK: - setDate
    func setDate(selection: String) {
        let selections = CalendarServices.shared.separateSelection(selection)
        self.setDate(year: selections[0], month: selections[safe: 1], day: selections[safe: 2])
    }
    func setDate(year: Int, month: Int? = nil, day: Int? = nil) {
        let month = month ?? 1
        let day = day ?? (year == Date().year && month == Date().month ? Date().day : 1)
        currentDate = CalendarServices.shared.getDate(year: year, month: month, day: day) ?? Date(format: .daily)
    }
    func setDate(byAdding: Calendar.Component, value: Int) {
        currentDate = calendar.date(byAdding: byAdding, value: value, to: currentDate) ?? Date(format: .daily)
    }
    func setDate(date: Date) {
        currentDate = date
    }
    
    // MARK: - init
    init() {
        self.calendar.timeZone = .current
        
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
            let date = calendar.date(byAdding: .day, value: direction.value, to: currentDate) ?? Date(format: .daily)
            return "\(date.month)월 \(date.dailyWeekOfMonth(startDay: UserDefaultManager.startDay ?? 0))주차"
        }
    }
    
    // MARK: - get info func
    func getCalendarInfo(type: CalendarType, index: Int) -> (date: Date, direction: Direction, selection: String) {
        let offset: Int = type == .year ? currentDate.year % 10 : type == .month ? (currentDate.month - 1) : currentDate.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0)
        let date: Date = calendar.date(byAdding: type.byAdding, value: index - offset, to: currentDate) ?? Date(format: .daily)
        
        let maxIndex = type == .year ? 10 : type == .month ? 12 : GeneralServices.week
        let direction: Direction = index < 0 ? .prev : index < maxIndex ? .current : .next
        
        return (date, direction, date.getSelection(type: type))
    }
    func getMonthInfo(date: Date) -> (startOfMonthWeekday: Int, lengthOfMonth: Int, dividerCount: Int) {
        let startOfMonth = calendar.date(from: DateComponents(year: date.year, month: date.month, day: 1))!
        let lengthOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)?.count ?? 0
        let weekday = startOfMonth.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0)
        let dividerCount = (lengthOfMonth + weekday - 1) / GeneralServices.week
        return (weekday + 1, lengthOfMonth, dividerCount)
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
    
    // MARK: - record list func
    

    // MARK: - Query filter
    static func recordsForDateDescriptor(_ date: Date) -> FetchDescriptor<DailyRecordModel> {
        let tommorow = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        
        let predicate = #Predicate<DailyRecordModel> { record in
            date <= record.date && record.date < tommorow
        }
        
        return FetchDescriptor<DailyRecordModel>(predicate: predicate)
    }
    
    static func recordsForWeekDescriptor(_ date: Date) -> FetchDescriptor<DailyRecordModel> {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -date.dailyWeekday(startDay: UserDefaultManager.startDay ?? 0), to: date)!
        let endDate = calendar.date(byAdding: .day, value: GeneralServices.week, to: startDate)!
        
        let predicate = #Predicate<DailyRecordModel> { record in
            startDate <= record.date && record.date < endDate
        }
        
        return FetchDescriptor<DailyRecordModel>(predicate: predicate)
    }
    
    // MARK: - fetch func
    func fetchYearData(date: Date, selection: String) {
        Task { @MainActor in
            yearDictionary[selection] = await calendarUseCase.getRatingsOfYear(date: date)
        }
    }
    
    func fetchMonthData(date: Date, selection: String) {
        Task { @MainActor in
            monthDictionary[selection] = await calendarUseCase.getMonthDatas(date: date)
        }
    }
}
