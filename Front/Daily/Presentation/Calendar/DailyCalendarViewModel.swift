//
//  DailyCalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation
import SwiftUI

class DailyCalendarViewModel: ObservableObject {
    private let calendarUseCase: CalendarUseCase
    
    @Published var yearSelection: String = CalendarServices.shared.formatDateString(year: Date().year)
    @Published var monthSelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month)
    @Published var weekSelection: String = CalendarServices.shared.weekSelection(daySelection: CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day))
    @Published var daySelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day)
    
    @Published var yearDictionary: [String: [[Double]]] = [
        CalendarServices.shared.formatDateString(year: Date().year)
        : Array(repeating: Array(repeating: 0, count: 31), count: 12)
    ]
    @Published var monthDictionary: [String: [SymbolsOnMonthModel]] = [
        CalendarServices.shared.formatDateString(year: Date().year, month: Date().month)
        : Array(repeating: SymbolsOnMonthModel(), count: 31)
    ]
    @Published var weekDictionary: [String: RatingsOnWeekModel] = [
        CalendarServices.shared.weekSelection(daySelection: CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day))
        : RatingsOnWeekModel()
    ]
    @Published var dayDictionary: [String: GoalListOnDayModel] = [
        CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day)
        : GoalListOnDayModel()
    ]
    
    // MARK: - init
    init() {
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    // MARK: - onAppear
    func calendarYearOnAppear(yearSelection: String) {
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let ratingsOnYear: [[Double]] = try await ServerNetwork.shared.request(.getCalendarYear(userID: userID, year: yearSelection))
            await MainActor.run { self.yearDictionary[yearSelection] = ratingsOnYear }
        }
    }
    func calendarMonthOnAppear(monthSelection: String) {
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let symbolsOnMonth: [SymbolsOnMonthModel] = try await ServerNetwork.shared.request(.getCalendarMonth(userID: userID, month: monthSelection))
            await MainActor.run { self.monthDictionary[monthSelection] = symbolsOnMonth }
        }
    }
    func calendarDayOnAppear(daySelection: String) {
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let goalListOnDay: GoalListOnDayModel = try await ServerNetwork.shared.request(.getCalendarDay(userID: userID, day: daySelection))
            await MainActor.run { self.dayDictionary[daySelection] = goalListOnDay }
        }
    }
    // TODO: 추후 개선
    func weekIndicatorOnChange(weekSelection: String) async throws {
        guard let userID = UserDefaultManager.userID else { return }
        let ratingsOnWeek: RatingsOnWeekModel = try await ServerNetwork.shared.request(.getCalendarWeek(userID: userID, startDay: weekSelection))
        await MainActor.run { self.weekDictionary[weekSelection] = ratingsOnWeek }
    }
    
    // MARK: - get
    func getDate(type: CalendarType) -> Int {
        let dateComponents = self.daySelection.split(separator: DateJoiner.hyphen.rawValue).compactMap { Int($0) }
        switch type {
        case .year:
            return dateComponents[0]
        case .month:
            return dateComponents[1]
        case .day:
            return dateComponents[2]
        }
    }
    
    // MARK: - set
    func setDate(_ year: Int, _ month: Int, _ day: Int) {
        self.yearSelection = CalendarServices.shared.formatDateString(year: year)
        self.monthSelection = CalendarServices.shared.formatDateString(year: year, month: month)
        self.daySelection = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
        self.weekSelection = CalendarServices.shared.weekSelection(daySelection: daySelection)
    }
    
    // MARK: - header func
    func headerText(type: CalendarType, textPosition: TextPositionInHeader) -> String {
        switch type {
        case .year:
            return textPosition == .title ? String(self.getDate(type: type)) + "년" : ""
        case .month:
            return textPosition == .title ? String(self.getDate(type: type)) + "월" : String(self.getDate(type: .year)) + "년"
        case .day:
            return textPosition == .title ? String(self.getDate(type: type)) + "일" : String(self.getDate(type: .month)) + "월"
        }
    }
    func moveDate(type: CalendarType, direction: Direction) {
        guard let today = self.daySelection.toDate() else { return }
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let componentType: Calendar.Component
        switch type {
        case .year:
            componentType = .year
        case .month:
            componentType = .month
        case .day:
            componentType = .day
        }
        
        if let prevDate = cal.date(byAdding: componentType, value: direction.value, to: today) {
            self.setDate(prevDate.year, prevDate.month, prevDate.day)
        }
    }
    
    // MARK: - weekIndicator func
    func tapWeekIndicator(dayOfWeek: DayOfWeek) {
        let startDate = self.weekSelection.toDate()!
        
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "UTC")!
        let date = cal.date(byAdding: .day, value: dayOfWeek.index, to: startDate)!
        
        self.setDate(date.year, date.month, date.day)
    }
}
