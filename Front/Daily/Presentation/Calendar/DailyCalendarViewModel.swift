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
    
    var navigationEnvironment: NavigationEnvironment = NavigationEnvironment()
    
    // MARK: - init
    init() {
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    // MARK: - onAppear
    func onAppear(navigationEnvironment: NavigationEnvironment) {
        self.navigationEnvironment = navigationEnvironment
        if type == .month || type == .day {
            self.navigate(type: .month)
            if type == .day {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.navigate(type: .day)
                }
            }
        }
    }
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
    
    // MARK: - navigate
    func navigate(type: CalendarType) {
        switch type {
        case .year:
            return
        case .month:
            let navigationObject = NavigationObject(viewType: .calendarMonth)
            navigationEnvironment.navigate(navigationObject)
        case .day:
            let navigationObject = NavigationObject(viewType: .calendarDay)
            navigationEnvironment.navigate(navigationObject)
        }
    }
    
    // MARK: - select calendar
    func selectMonth(month: Int) {
        setMonth(month)
        navigate(type: .month)
    }
    func selectDay(day: Int) {
        setDay(day)
        setStartDay(CalendarServices.shared.getStartDay(year: self.year, month: self.month, day: day))
        navigate(type: .day)
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
}
