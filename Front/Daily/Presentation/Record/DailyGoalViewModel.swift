//
//  DailyGoalViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

class DailyGoalViewModel: ObservableObject {
    private let goalUseCase: GoalUseCase
    
    @Published var cycleType: CycleType = .date
    
    init() {
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
    }
    
}
