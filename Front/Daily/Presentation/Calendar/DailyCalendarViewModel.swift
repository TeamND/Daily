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
    @Published var day: Int = Date().day
    
    @Published var yearSelection: String = CalendarServices.shared.formatDateString(year: Date().year)
    @Published var monthSelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month)
    @Published var daySelection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day)
    
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
    func calendarYearOnAppear() {
        Task {
            let ratingsOnYear: [[Double]] = try await ServerNetwork.shared.request(.getCalendarYear(userID: "123", year: "2024"))
        }
    }
    func calendarMonthOnAppear() {
        Task {
            let symbolsOnMonth: [SymbolsOnMonthModel] = try await ServerNetwork.shared.request(.getCalendarMonth(userID: "123", month: "2024-10"))
        }
    }
    func calendarDayOnAppear() {
        Task {
            let goalListOnDay: GoalListOnDayModel = try await ServerNetwork.shared.request(.getCalendarDay(userID: "123", day: "2024-10-26"))
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
    func setDay(_ day: Int) {
        if self.day == day { return }
        self.day = day
        self.daySelection = CalendarServices.shared.formatDateString(year: year, month: month, day: day)
    }
}
