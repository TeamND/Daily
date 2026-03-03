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
        
        if let goal = record.goal, goal.isSetTime,
           let notice = record.notice, notice > 0 {
            guard let noticeDate = PushNoticeManager.shared.getValidNoticeDate(record: record) else {
                // FIXME: 유효하지 않은 알림 토스트 추가 필요
                return
            }
            PushNoticeManager.shared.addNotice(record: record)
        }
    }
    
    func deleteRecord(record: DailyRecordModel) async {
        await repository.deleteRecord(record: record)
    }
    
    func removeNotice(record: DailyRecordModel) {
        record.notice = nil
        PushNoticeManager.shared.removeNotice(id: String(describing: record.id))
    }
    
    func updateTimerNotice(id: String, record: TempRecordModel, goal: TempGoalModel) {
        PushNoticeManager.shared.removeTimerNotice(id: id)
        PushNoticeManager.shared.addTimerNotice(
            id: id,
            content: goal.content,
            date: record.date,
            remainTime: goal.count - record.count
        )
    }
}
