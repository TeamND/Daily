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
    
    @Published private(set) var currentDate: Date = Date(format: .daily)
    @Published private(set) var yearDictionary: [String: [[Double]]] = [:]
    @Published private(set) var monthDictionary: [String: [MonthDataModel]] = [:]
    @Published private(set) var weekDictionary: [String: [Double]] = [:]
    @Published private(set) var dayDictionary: [String: [DailyRecordModel]] = [:]
    @Published private(set) var weeklyPercentage: [String: Int] = [:]
    @Published var isShowWeeklySummary: Bool = false    // TODO: 추후 수정
    
    func bindSelection(type: CalendarType) -> Binding<String> {
        Binding(
            get: { self.currentDate.getSelection(type: type) },
            set: { self.setDate(selection: $0) }
        )
    }
    
    init() {
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
}

// MARK: - setDate
extension CalendarViewModel {
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
        var calendar = Calendar.current
        calendar.timeZone = .current
        currentDate = calendar.date(byAdding: byAdding, value: value, to: currentDate) ?? Date(format: .daily)
    }
    func setDate(date: Date) {
        currentDate = date
    }
}

// MARK: - info
extension CalendarViewModel {
    func loadText(type: CalendarType, direction: Direction) -> String {
        calendarUseCase.getLoadText(currentDate: currentDate, type: type, direction: direction)
    }
    
    func headerText(type: CalendarType, textPosition: TextPositionInHeader = .title) -> String {
        calendarUseCase.getHeaderText(currentDate: currentDate, type: type, textPosition: textPosition)
    }
    
    func calendarInfo(type: CalendarType, index: Int) -> (date: Date, direction: Direction, selection: String) {
        calendarUseCase.getCalendarInfo(currentDate: currentDate, type: type, index: index)
    }
    
    func monthInfo(date: Date) -> (startOfMonthWeekday: Int, lengthOfMonth: Int, dividerCount: Int) {
        calendarUseCase.getMonthInfo(date: date)
    }
}

// MARK: - fetch func
extension CalendarViewModel {
    func fetchYearData(selection: String) {
        Task { @MainActor in
            yearDictionary[selection] = await calendarUseCase.getRatingsOfYear(selection: selection)
        }
    }
    
    func fetchMonthData(selection: String) {
        Task { @MainActor in
            monthDictionary[selection] = await calendarUseCase.getMonthDatas(selection: selection)
        }
    }
    
    func fetchWeekData(selection: String) {
        Task { @MainActor in
            weekDictionary[selection] = await calendarUseCase.getRatingsOfWeek(selection: selection)
            weeklyPercentage[selection] = await calendarUseCase.getWeeklyPercentage(selection: selection)
        }
    }
    
    func fetchDayData(selection: String) {
        Task { @MainActor in
            dayDictionary[selection] = await calendarUseCase.getRecords(selection: selection)
        }
    }
}
