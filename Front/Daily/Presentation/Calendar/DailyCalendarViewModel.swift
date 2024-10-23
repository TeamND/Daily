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
    @Published var mode: CalendarMode = .year
    @Published var selection: String = "2024-10-26"
    
    @Published var year: Int = 2024
    @Published var month: Int = 10
    @Published var day: Int = 26
    
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
