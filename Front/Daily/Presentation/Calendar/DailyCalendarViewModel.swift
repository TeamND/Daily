//
//  DailyCalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class DailyCalendarViewModel: ObservableObject {
    private let testUseCase: TestUseCase
    private let calendarUseCase: CalendarUseCase
    
    @Published var test: String = "testString of DailyCalendarViewModel"
    @Published var type: CalendarType = .year
    @Published var selection: String = CalendarServices.shared.formatDateString(year: Date().year, month: Date().month, day: Date().day, joiner: .hyphen)
    
    @Published var year: Int = Date().year
    @Published var month: Int = Date().month
    @Published var day: Int = Date().day
    
    init() {
        let repository = TestRepository()
        self.testUseCase = TestUseCase(repository: repository)
        let calendarRepository = CalendarRepository()
        self.calendarUseCase = CalendarUseCase(repository: calendarRepository)
    }
    
    func onAppear(_ currentCalendar: String) {
        print("on Appear is \(currentCalendar)")
    }
    
    func printTest() {
        print(test)
    }
    
    func changeTest() {
        self.test = "change test"
    }
    
    func setSelection(year: Int) {
        self.year = year
    }
}
