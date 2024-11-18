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
    
    @Published var type: CalendarType = .month   // TODO: 추후 UserDefaults에서 가져오도록 수정
    
    @Published var year: Int = Date().year
    @Published var month: Int = Date().month
    @Published var startDay: Int = CalendarServices.shared.getStartDay(year: Date().year, month: Date().month, day: Date().day)
    @Published var day: Int = Date().day
    
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
        Task {
            guard let userID = UserDefaultManager.userID else { return }
            let ratingsOnWeek: RatingsOnWeekModel = try await ServerNetwork.shared.request(.getCalendarWeek(userID: userID, startDay: weekSelection))
            await MainActor.run { self.weekDictionary[weekSelection] = ratingsOnWeek }
        }
    }
    
    // MARK: - set
    func setYear(_ year: Int) {
        if self.year == year { return }
        self.year = year
        self.yearSelection = CalendarServices.shared.formatDateString(year: year)
    }
    func setMonth(_ month: Int) {
        if self.month == month { return }
        self.month = month
        self.monthSelection = CalendarServices.shared.formatDateString(year: year, month: month)
    }
    func setStartDay(_ startDay: Int) {
        if self.startDay == startDay { return }
        self.startDay = startDay
        self.weekSelection = CalendarServices.shared.formatDateString(year: year, month: month, day: startDay)
    }
    func setDay(_ day: Int) {
        if self.day == day { return }
        self.day = day
        self.daySelection = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
    }
    func setDate(_ year: Int, _ month: Int, _ day: Int) {
        self.setYear(year)
        self.setMonth(month)
        self.setStartDay(CalendarServices.shared.getStartDay(year: year, month: month, day: day))
        self.setDay(day)
    }
    
    // MARK: - header func
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
        
        if let prevDate = cal.date(byAdding: componentType, value: direction.rawValue, to: today) {
            self.setDate(prevDate.year, prevDate.month, prevDate.day)
        }
    }
}
