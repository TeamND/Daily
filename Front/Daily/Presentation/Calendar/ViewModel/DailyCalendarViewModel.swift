//
//  DailyCalendarViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/20/24.
//

import Foundation

class DailyCalendarViewModel: ObservableObject {
    private let testUseCase: TestUseCase
    
    init() {
        let repository = TestRepository()
        self.testUseCase = TestUseCase(repository: repository)
    }
    
    func onAppear(_ currentCalendar: String) {
        print("on Appear is \(currentCalendar)")
    }
    
    func test(userID: String) {
        Task {
            let userInfo = try await testUseCase.getUserInfo(userID: userID)
            print(userInfo)
        }
    }
}
