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
    
    var originalDate: Date = Date(format: .daily)
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
    
    convenience init(goalData: GoalDataModel) {
        self.init()
        
        self.originalDate = goalData.date
        
        self.startDate = originalDate
        self.endDate = originalDate.monthLater()
        self.selectedWeekday = Array(repeating: false, count: GeneralServices.week)
        
        self.originalGoal = goal.copy()
    }
    
    convenience init(modifyData: ModifyDataModel) {
        self.init()
        
        self.originalDate = modifyData.date
        self.modifyType = modifyData.modifyType
        
        self.goal = modifyData.modifyRecord.goal ?? DailyGoalModel()
        self.record = modifyData.modifyRecord
        
        self.originalGoal = goal.copy()
        self.originalRecord = record.copy()
    }
}

// MARK: - popover func
extension GoalViewModel {
    func showPopover(at position: CGPoint, @ViewBuilder content: @escaping () -> some View) {
        if isBlockPopover { return }

        self.popoverPosition = position
        self.popoverContent = AnyView(content())
    }
    
    func hidePopover() {
        if popoverContent != nil {
            isBlockPopover = true
            popoverPosition = .zero
            popoverContent = nil
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isBlockPopover = false
            }
        }
    }
}

// MARK: - button func
extension GoalViewModel {
    func reset(exceptGoal: Bool = false, exceptRecord: Bool = false) {
        if !exceptGoal {
            self.goal.type = originalGoal.type
            self.goal.cycleType = originalGoal.cycleType
            self.goal.content = originalGoal.content
            self.goal.symbol = originalGoal.symbol
            self.goal.count = originalGoal.count
            self.goal.isSetTime = originalGoal.isSetTime
            self.goal.setTime = originalGoal.setTime
        }
        
        if !exceptRecord {
            self.record.date = originalDate
            self.record.isSuccess = originalRecord.isSuccess
            self.record.count = originalRecord.count
            self.record.notice = originalRecord.notice
        }
        
        self.startDate = originalDate
        self.endDate = originalDate.monthLater()
        self.selectedWeekday = Array(repeating: false, count: GeneralServices.week)
    }
    
    func add(successAction: @escaping (Date?) -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        if let validate = validate(validateType: .add) { validateAction(validate); return }
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
        if let validate = validate(validateType: .modify) { validateAction(validate); return }
        if record.notice != nil && (
            record.date != originalDate ||
            originalGoal.setTime != goal.setTime ||
            originalGoal.isSetTime != goal.isSetTime
        ) {
            goalUseCase.removeNotice(record: record)
            if record.date != originalDate { validateAction(NoticeAlert.dateChanged) }
            if originalGoal.setTime != goal.setTime || originalGoal.isSetTime != goal.isSetTime {
                validateAction(NoticeAlert.setTimeChanged)
            }
        }
        
        Task { @MainActor in
            // TODO: 추후 개선
            if modifyType == .single {
                let newGoal = goal.copy(cycleType: .date, records: [])
                await goalUseCase.addGoal(goal: newGoal)
                
                reset(exceptRecord: true)
                goal.records.removeAll { $0 == record }
                record.goal = newGoal
                record.isSuccess = newGoal.count <= record.count
            } else {
                record.isSuccess = goal.count <= record.count
            }
            
            await goalUseCase.updateData()
            successAction(record.date)
        }
    }
    
}
    
// MARK: - validate func
extension GoalViewModel {
    private func validate(validateType: ButtonTypes) -> DailyAlert? {
        if validateContent() { return ContentAlert.tooShoertLength }
        if validateType == .add && goal.cycleType == .rept {
            if startDate > endDate { return DateAlert.wrongDateRange }
            if validateDateRange() { return DateAlert.overDateRange }
            if selectedWeekday.allSatisfy({ $0 == false }) { return DateAlert.emptySelectedWeekday }
            if repeatDates.count == 0 { return DateAlert.emptyRepeatDates }
        }
        return nil
    }
    private func validateContent() -> Bool {
        return goal.content.count < 2
    }
    private func validateDateRange() -> Bool {
        let gap = calendar.dateComponents([.year,.month,.day], from: startDate, to: endDate)
        return gap.year! > 0
    }
}
