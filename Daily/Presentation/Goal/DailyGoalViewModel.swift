//
//  DailyGoalViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation
import SwiftUI
import SwiftData

class DailyGoalViewModel: ObservableObject {
    private let goalUseCase: GoalUseCase
    private var calendar = Calendar.current
    
    @Published var cycleType: CycleTypes = .date
    @Published var startDate: Date = Date(format: .daily)
    @Published var endDate: Date = Date(format: .daily).monthLater()
    var selectedWeekday: [Int] = []
    var repeatDates: [String] {
        switch cycleType {
        case .date:
            return [startDate.getSelection()]
        case .rept:
            return stride(from: startDate, through: endDate, by: 24 * 60 * 60)
                .compactMap { selectedWeekday.contains(calendar.component(.weekday, from: $0)) ? $0.getSelection() : nil }
        }
    }
    
    @Published var isSetTime: Bool = false
    @Published var setTime: Date = "00:00".toDate(format: .setTime) ?? Date(format: .daily)
    
    @Published var content: String = ""
    @Published var goalType: GoalTypes = .check
    @Published var recordCount: Int = 0
    @Published var goalCount: Int = 1
    @Published var symbol: Symbols = .check
    
    @Published var modifyRecord: DailyRecordModel? = nil
    @Published var modifyType: ModifyTypes? = nil
    private var beforeDate: Date = Date(format: .daily)
    private var beforeRecord: Int = 0
    
    // TODO: 추후 DailyGoalView로 이동시 Data에 날짜 데이터 추가, Date 변수들 조정
    init() {
        self.calendar.timeZone = .current
        
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
    }
    
    convenience init(goalData: GoalDataModel) {
        self.init()
        
        self.beforeDate = goalData.date
        self.startDate = self.beforeDate
        self.endDate = self.beforeDate.monthLater()
    }
    
    convenience init(modifyData: ModifyDataModel) {
        self.init()
        
        self.setRecord(record: modifyData.modifyRecord)
        self.modifyRecord = modifyData.modifyRecord
        self.modifyType = modifyData.modifyType
        self.cycleType = modifyData.modifyType == .all ? .rept : .date
        self.beforeDate = modifyData.date
        self.startDate = self.beforeDate
        self.beforeRecord = modifyData.modifyRecord.count
        self.recordCount = self.beforeRecord
    }
    
    // MARK: - set
    func setRecord(record: DailyRecordModel) {
        if let goal = record.goal {
            self.cycleType = goal.cycleType
            self.isSetTime = goal.isSetTime
            self.setTime = goal.setTime.toDate(format: .setTime) ?? Date(format: .daily)
            self.content = goal.content
            self.goalCount = goal.count
            self.symbol = goal.symbol
        }
    }
    
    // MARK: - button func
    func reset() {
        if let modifyRecord {
            self.setRecord(record: modifyRecord)
            startDate = beforeDate
            recordCount = beforeRecord
        } else {
            content = ""
            symbol = .check
            goalType = .check
            startDate = beforeDate
            endDate = beforeDate.monthLater()
            cycleType = .date
            selectedWeekday = []
            goalCount = 1
            isSetTime = false
            setTime = "00:00".toDate(format: .setTime) ?? Date(format: .daily)
        }
    }
    
    func add(modelContext: ModelContext, successAction: @escaping () -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        if let validate = validate(validateType: .add) { validateAction(validate); return }
        let newGoal = DailyGoalModel(
            type: goalType,
            cycleType: cycleType,
            content: content,
            symbol: symbol,
            startDate: startDate,
            endDate: endDate,
            repeatDates: repeatDates,
            count: goalCount,
            isSetTime: isSetTime,
            setTime: setTime.toString(format: .setTime)
        )
        modelContext.insert(newGoal)
        try? modelContext.save()
        
        repeatDates.forEach { repeatDate in
            guard let date = repeatDate.toDate() else { return }
            modelContext.insert(DailyRecordModel(goal: newGoal, date: date))
        }
        try? modelContext.save()
        successAction()
    }
    
    func modify(modelContext: ModelContext, successAction: @escaping (Date?) -> Void, validateAction: @escaping (DailyAlert) -> Void) {
        if let validate = validate(validateType: .modify) { validateAction(validate); return }
        if let record = modifyRecord, let goal = record.goal, let modifyType {
            switch modifyType {
            case .record:
                goal.content = content
                goal.symbol = symbol
                goal.type = goalType
                goal.count = goalCount
                goal.isSetTime = isSetTime
                goal.setTime = setTime.toString(format: .setTime)
                record.date = startDate
                record.count = recordCount
                record.isSuccess = goalCount <= recordCount
                try? modelContext.save()
            case .single:
                if goal.content != content || goal.symbol != symbol || goal.type != goalType || goal.count != goalCount || goal.isSetTime != isSetTime || goal.setTime != setTime.toString(format: .setTime) {
                    let newGoal = DailyGoalModel(
                        type: goalType,
                        cycleType: cycleType,
                        content: content,
                        symbol: symbol,
                        startDate: startDate,
                        endDate: endDate,
                        repeatDates: repeatDates,
                        count: goalCount,
                        isSetTime: isSetTime,
                        setTime: setTime.toString(format: .setTime),
                        parentGoal: goal
                    )
                    modelContext.insert(newGoal)
                    try? modelContext.save()
                    goal.childGoals.append(newGoal)
                    record.goal = newGoal
                }
                record.date = startDate
                record.count = recordCount
                record.isSuccess = goalCount <= recordCount
                try? modelContext.save()
            case .all:
                goal.content = content
                goal.symbol = symbol
                goal.type = goalType
                goal.count = goalCount
                goal.isSetTime = isSetTime
                goal.setTime = setTime.toString(format: .setTime)
                record.isSuccess = goalCount <= recordCount
                try? modelContext.save()
            }
            successAction(startDate)
        }
    }
    
    // MARK: - validate func
    private func validate(validateType: ButtonTypes) -> DailyAlert? {
        if validateContent() { return ContentAlert.tooShoertLength }
        if validateType == .add && cycleType == .rept {
            if selectedWeekday.count == 0 { return DateAlert.emptySelectedWeekday }
            if startDate > endDate { return DateAlert.wrongDateRange }
            if validateDateRange() { return DateAlert.overDateRange }
            if repeatDates.count == 0 { return DateAlert.emptyRepeatDates }
        }
        return nil
    }
    private func validateContent() -> Bool {
        return content.count < 2
    }
    private func validateDateRange() -> Bool {
        let gap = calendar.dateComponents([.year,.month,.day], from: startDate, to: endDate)
        return gap.year! > 0
    }
}
