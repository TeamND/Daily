//
//  DailyCalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class DailyCalendarViewModel: ObservableObject {
    private let testUseCase: TestUseCase
    
    @Published var test: String = "testString of DailyCalendarViewModel"
    
    init() {
        let repository = TestRepository()
        self.testUseCase = TestUseCase(repository: repository)
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
}
