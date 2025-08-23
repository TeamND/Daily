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
    
    var modifyType: ModifyTypes?
    
    var originalGoal: DailyGoalModel = DailyGoalModel()
    var originalRecord: DailyRecordModel = DailyRecordModel()
    
    private var isBlockPopover: Bool = false
    @Published var popoverPosition: CGPoint = .zero
    @Published var popoverContent: AnyView? = nil
    
    @Published var goal: DailyGoalModel = DailyGoalModel()
    @Published var record: DailyRecordModel = DailyRecordModel()
    
    @Published var repeatType: RepeatTypes = .weekly
    @Published var startDate: Date = Date(format: .daily)
    @Published var endDate: Date = Date(format: .daily).monthLater()
    @Published var selectedWeekday: [Bool] = Array(repeating: false, count: GeneralServices.week)
    @Published var selectedDates: [Date] = [Date(format: .daily)]
    
    var repeatDates: [String] {
        switch goal.cycleType {
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
        
        self.goal = originalGoal.copy()
        self.record = originalRecord.copy()
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
    func add(successAction: @escaping (Date?) -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        if let validate = validate() { validateAction(validate); return }
        Task { @MainActor in
            let records = repeatDates.map { DailyRecordModel(goal: goal, date: $0.toDate()!) }
            for record in records { await goalUseCase.addRecord(record: record) }
            
            goal.records = records
            await goalUseCase.addGoal(goal: goal)
            
            successAction(startDate)
        }
    }
    
    func modify(successAction: @escaping (Date?) -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        guard let modifyType else { return }
        if let validate = validate() { validateAction(validate); return }
        if record.notice != nil && (
            originalRecord.date != record.date ||
            originalGoal.setTime != goal.setTime ||
            originalGoal.isSetTime != goal.isSetTime
        ) {
            goalUseCase.removeNotice(record: record)
            if originalRecord.date != record.date { validateAction(NoticeAlert.dateChanged) }
            if originalGoal.setTime != goal.setTime || originalGoal.isSetTime != goal.isSetTime {
                validateAction(NoticeAlert.setTimeChanged)
            }
        }
        
        Task { @MainActor in
            if modifyType == .single {
                await goalUseCase.deleteRecord(record: originalRecord)
                
                goal.cycleType = .date
                goal.records = []
                await goalUseCase.addGoal(goal: goal)
                record.goal = goal
                record.isSuccess = goal.count <= record.count
                await goalUseCase.addRecord(record: record)
            } else {
                originalGoal.content = goal.content
                originalGoal.symbol = goal.symbol
                originalGoal.count = goal.count
                originalGoal.isSetTime = goal.isSetTime
                originalGoal.setTime = goal.setTime
                
                if modifyType == .record {
                    originalRecord.date = record.date
                    originalRecord.count = record.count
                    originalRecord.notice = record.notice
                    originalRecord.startTime = record.startTime == nil ? nil : Date()
                }
                originalGoal.records.forEach { $0.isSuccess = originalGoal.count <= $0.count }
                
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
