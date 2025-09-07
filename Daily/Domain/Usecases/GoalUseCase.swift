//
//  GoalUseCase.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

final class GoalUseCase {
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
    
    func addRecord(record: DailyRecordModel) async {
        await repository.addRecord(record: record)
    }
    
    func deleteRecord(record: DailyRecordModel) async {
        await repository.deleteRecord(record: record)
    }
    
    func removeNotice(record: DailyRecordModel) {
        record.notice = nil
        PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
    }
}
