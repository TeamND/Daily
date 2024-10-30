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
    
    @Published var type: CalendarType = .day   // TODO: 추후 UserDefaults에서 가져오도록 수정
    
    @Published var year: Int = Date().year
    @Published var month: Int = Date().month
    @Published var day: Int = Date().day
    
    @Published var yearSelection: String = Date().year.formatDateString(type: .year)
    @Published var monthSelection: String = Date().year.formatDateString(type: .year) + "-" + Date().month.formatDateString(type: .month)
    @Published var daySelection: String = Date().year.formatDateString(type: .year) + "-" + Date().month.formatDateString(type: .month) + "-" + Date().day.formatDateString(type: .day)
    
    var navigationEnvironment: NavigationEnvironment = NavigationEnvironment()
    
    // MARK: - init
    init() {
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    // MARK: - onAppear
    func onAppear(navigationEnvironment: NavigationEnvironment) {
        print("onAppear of DailyCalendarViewModel is called")
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
        
    }
    func calendarMonthOnAppear() {
        
    }
    func calendarDayOnAppear() {
        
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
        self.yearSelection = year.formatDateString(type: .year)
    }
    func setMonth(_ month: Int) {
        if self.month == month { return }
        self.month = month
        self.monthSelection = year.formatDateString(type: .year) + "-" + month.formatDateString(type: .month)
    }
    func setDay(_ day: Int) {
        if self.day == day { return }
        self.day = day
        self.daySelection = year.formatDateString(type: .year) + "-" + month.formatDateString(type: .month) + "-" + day.formatDateString(type: .day)
    }
}
