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
        addNotice(record: record)
    }
    
    func deleteRecord(record: DailyRecordModel) async {
        removeNotice(record: record)
        await repository.deleteRecord(record: record)
    }
    
    func addNotice(record: DailyRecordModel) {
        guard let noticeDate = CalendarServices.shared.getValidNoticeDate(record: record), noticeDate > Date() else { return }
        PushNoticeManager.shared.addNotice(noticeDate: noticeDate, record: record)
    }
    
    func removeNotice(record: DailyRecordModel) {
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
    
    func getAlerts(records: [DailyRecordModel]?) -> [DailyAlert] {
        let records = records?.sorted { $0.date < $1.date }
        guard let records, let firstRecord = records.first, let lastRecord = records.last else { return [] }
        
        var alerts: [DailyAlert] = []
        
        if let noticeDate = CalendarServices.shared.getValidNoticeDate(record: lastRecord), noticeDate > Date() {
            alerts.append(NoticeAlert.setNoticeTime(
                noticeText: Notifications.noticeText(noticeTime: lastRecord.notice, isToast: true)
            ))
        }
        
        if let noticeDate = CalendarServices.shared.getValidNoticeDate(record: firstRecord), noticeDate < Date() {
            alerts.append(NoticeAlert.noNotificationsForPastEvents)
        }
        
        return alerts
    }
}
