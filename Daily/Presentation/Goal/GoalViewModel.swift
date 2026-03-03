//
//  GoalViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation
import SwiftUI

class GoalViewModel: ObservableObject {
    private let goalUseCase: GoalUseCase
    private let calendar: Calendar = CalendarManager.shared.getDailyCalendar()
    
    private(set) var modifyType: ModifyTypes?
    private(set) var alertEnvironment: AlertEnvironment?
    
    private(set) var originalGoal: DailyGoalModel = DailyGoalModel()
    private(set) var originalRecord: DailyRecordModel = DailyRecordModel()
    
    private var isBlockPopover: Bool = false
    @Published var popoverPosition: CGPoint = .zero
    @Published var popoverContent: AnyView? = nil
    
    @Published var goal: TempGoalModel = TempGoalModel()
    @Published var record: TempRecordModel = TempRecordModel()
    
    @Published var repeatType: RepeatTypes = .weekly
    @Published var startDate: Date = Date(format: .daily)
    @Published var endDate: Date = Date(format: .daily).monthLater()
    @Published var selectedWeekday: [Bool] = Array(repeating: false, count: GeneralServices.week)
    @Published var selectedDates: [Date] = [Date(format: .daily)]
    
    var repeatDates: [String] {
        guard let cycleType = goal.cycleType else { return [] }
        switch cycleType {
        case .date:
            return [startDate.getSelection()]
        case .rept:
            switch repeatType {
            case .weekly:
                return stride(from: startDate, through: endDate, by: 24 * 60 * 60).compactMap {
                    selectedWeekday[calendar.component(.weekday, from: $0) - 1] ? $0.getSelection() : nil
                }
            case .custom:
                return selectedDates.map { $0.getSelection() }
            }
        }
    }
    
    var setTime: Binding<Date> {
        Binding(
            get: { self.goal.setTime.toDate(format: .setTime) ?? Date(format: .daily) },
            set: { self.goal.setTime = $0.toString(format: .setTime) }
        )
    }
    
    init() {
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
    }
    
    convenience init(goalData: GoalDataEntity) {
        self.init()
        
        self.modifyType = goalData.modifyType
        
        let originalDate = goalData.record.date
        self.startDate = originalDate
        self.endDate = originalDate.monthLater()
        self.selectedWeekday = Array(repeating: false, count: GeneralServices.week)
        self.selectedDates = [originalDate]
        
        self.originalGoal = goalData.record.goal ?? DailyGoalModel()
        self.originalRecord = goalData.record
        
        self.goal.update(goal: originalGoal)
        self.record.update(record: originalRecord)
    }
    
    // FIXME: 추후에 alertType을 반환하는 구조로 개선해서 viewModel에서 UI조작을 하지 않도록 개선
    func setAlertEnvironment(_ alertEnvironment: AlertEnvironment) {
        self.alertEnvironment = alertEnvironment
    }
}

// MARK: - popover func
extension GoalViewModel {
    func showPopover(at position: CGPoint, @ViewBuilder content: @escaping () -> some View) {
        if isBlockPopover && popoverPosition == position { return }

        popoverPosition = position
        withAnimation(.easeInOut(duration: 0.3)) {
            popoverContent = AnyView(content())
        }
    }
    
    func hidePopover() {
        if popoverContent != nil {
            isBlockPopover = true
            withAnimation(.easeInOut(duration: 0.3)) {
                popoverContent = nil
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isBlockPopover = false
            }
        }
    }
}

// MARK: - button func
extension GoalViewModel {
    func add(successAction: @escaping (Date) -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        if let validate = validate() { validateAction(validate); return }
        Task { @MainActor in
            let goal = DailyGoalModel(from: goal)
            let records = repeatDates.map { DailyRecordModel(goal: goal, date: $0.toDate()!, notice: record.notice) }
            for record in records { await goalUseCase.addRecord(record: record) }
            
            goal.records = records
            await goalUseCase.addGoal(goal: goal)
            
            successAction(startDate)
            alertEnvironment?.showToast(alertType: SuccessAlert.addGoal)
            // FIXME: 토스트 순차적으로 뜨게 수정 후 추가
//            if goal.isSetTime, record.notice ?? 0 > 0 {
//                alertEnvironment?.showToast(
//                    alertType: NoticeAlert.setNoticeTime(
//                        noticeTime: Notifications.from(noticeTime: record.notice).text
//                    )
//                )
//            }
        }
    }
    
    func modify(successAction: @escaping (Date) -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        guard let modifyType else { return }
        if let validate = validate() { validateAction(validate); return }
        
        // FIXME: 삭제 가능 (통합 할 예정)
        if record.notice != nil && (
            originalRecord.date != record.date ||
            originalGoal.setTime != goal.setTime ||
            originalGoal.isSetTime != goal.isSetTime
        ) {
            goalUseCase.removeNotice(record: originalRecord)
            if originalRecord.date != record.date { validateAction(NoticeAlert.dateChanged) }
            if originalGoal.setTime != goal.setTime || originalGoal.isSetTime != goal.isSetTime {
                validateAction(NoticeAlert.setTimeChanged)
            }
        }
        
        if record.startTime != nil && (
            originalRecord.date != record.date ||
            originalRecord.count != record.count ||
            originalGoal.content != goal.content ||
            originalGoal.count != goal.count
        ) {
            let timerNoticeId = "\(String(describing: originalRecord.id))-timer"
            goalUseCase.updateTimerNotice(id: timerNoticeId, record: record, goal: goal)
        }
        
        // FIXME: record notice 수정 조건 검토 후 추가 필요
        Task { @MainActor in
            if modifyType == .single {
                // MARK: 단일 수정 (기록만 수정)
                if goal.isSetTime == originalGoal.isSetTime &&
                    goal.setTime == originalGoal.setTime &&
                    goal.content == originalGoal.content &&
                    goal.symbol == originalGoal.symbol &&
                    goal.count == originalGoal.count
                {
                    originalRecord.date = record.date
                    originalRecord.count = record.count
                    originalRecord.notice = record.notice
                    originalRecord.startTime = record.startTime == nil ? nil : Date()
                    originalRecord.isSuccess = originalGoal.count <= record.count
                    
                    await goalUseCase.updateData()
                } else {    // MARK: 단일 수정 (목표도 수정)
                    originalGoal.records?.removeAll() { $0.id == originalRecord.id }
                    await goalUseCase.deleteRecord(record: originalRecord)
                    
                    goal.cycleType = .date
                    goal.records = []
                    let goal = DailyGoalModel(from: goal)
                    
                    record.goal = goal
                    record.isSuccess = goal.count <= record.count
                    let record = DailyRecordModel(from: record)
                    await goalUseCase.addRecord(record: record)
                    
                    goal.records = [record]
                    await goalUseCase.addGoal(goal: goal)
                }
            } else {    // MARK: 일괄 수정
                originalGoal.isSetTime = goal.isSetTime
                originalGoal.setTime = goal.setTime
                originalGoal.content = goal.content
                originalGoal.symbol = goal.symbol
                originalGoal.count = goal.count
                
                if modifyType == .record {
                    originalRecord.date = record.date
                    originalRecord.count = record.count
                    originalRecord.notice = record.notice
                    originalRecord.startTime = record.startTime == nil ? nil : Date()
                }
                originalGoal.records?.forEach { $0.isSuccess = originalGoal.count <= $0.count }
                
                await goalUseCase.updateData()
            }
            successAction(record.date)
        }
    }
}
    
// MARK: - validate func
extension GoalViewModel {
    private func validate() -> DailyAlert? {
        if validateContent() { return ContentAlert.tooShoertLength }
        if validateCount() { return CountAlert.tooSmallCount }
        if modifyType == nil && goal.cycleType == .rept {
            if repeatType == .weekly {
                if startDate > endDate { return DateAlert.wrongDateRange }
                if validateDateRange() { return DateAlert.overDateRange }
                if selectedWeekday.allSatisfy({ $0 == false }) { return DateAlert.emptySelectedWeekday }
            }
            if repeatDates.count == 0 { return DateAlert.emptyRepeatDates }
        }
        return nil
    }
    private func validateContent() -> Bool {
        return goal.content.count < 2
    }
    private func validateCount() -> Bool {
        return goal.count < 1
    }
    private func validateDateRange() -> Bool {
        let gap = calendar.dateComponents([.year,.month,.day], from: startDate, to: endDate)
        return gap.year! > 0
    }
}
