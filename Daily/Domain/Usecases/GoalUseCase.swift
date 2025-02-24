//
//  GoalUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

class GoalUseCase {
    private let repository: GoalInterface
    
    init(repository: GoalInterface) {
        self.repository = repository
    }
    
    func updateData() async {
        await repository.updateData()
    }
    
    func addGoal(goal: DailyGoalModel) async {
        await repository.addGoal(goal: goal)
    }
    
    func addRecord(goal: DailyGoalModel, date: Date) async {
        await repository.addRecord(record: DailyRecordModel(goal: goal, date: date))
    }
    
    func addRecords(goal: DailyGoalModel, dates: [String]) async {
        for date in dates {
            guard let date = date.toDate() else { return }
            await addRecord(goal: goal, date: date)
        }
    }
}
