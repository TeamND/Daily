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
    
    @Published var selection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day, joiner: .hyphen)
    @Published var type: CalendarType = .day   // TODO: 추후 UserDefaults에서 가져오도록 수정
    
    @Published var year: Int = Date().year
    @Published var month: Int = Date().month
    @Published var day: Int = Date().day
    
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
        print("selected month is \(month)")
        navigate(type: .month)
    }
    func selectDay(day: Int) {
        print("selected day is \(day)")
        navigate(type: .day)
    }
}
