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
    @Published var startDate: Date = Date().defaultDate()
    @Published var endDate: Date = Date().defaultDate().setDefaultEndDate()
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
    @Published var setTime: Date = "00:00".toDateOfSetTime()
    
    @Published var content: String = ""
    @Published var goalType: GoalTypes = .check
    @Published var goalCount: Int = 1
    @Published var symbol: Symbols = .check
    
    @Published var modifyRecord: DailyRecordModel? = nil
    @Published var modifyType: ModifyTypes? = nil
    @Published var modifyIsAll: Bool? = nil
    @Published var modifyDate: Date = Date()
    @Published var modifyRecordCount: Int = 0
    
    private var beforeDate: Date = Date()
    
    // TODO: 추후 DailyGoalView로 이동시 Data에 날짜 데이터 추가, Date 변수들 조정
    init() {
        self.calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
    }
    
    convenience init(goalData: GoalDataModel) {
        self.init()
        
        self.beforeDate = goalData.date
        self.startDate = self.beforeDate.defaultDate()
        self.endDate = self.beforeDate.defaultDate().setDefaultEndDate()
    }
    
    convenience init(modifyData: ModifyDataModel) {
        self.init()
        
        self.setRecord(record: modifyData.modifyRecord)
        self.modifyRecord = modifyData.modifyRecord
        self.modifyType = modifyData.modifyType
        self.modifyIsAll = modifyData.isAll
        self.beforeDate = modifyData.date
        self.modifyDate = self.beforeDate
        self.modifyRecordCount = modifyData.modifyRecord.count
    }
    
    // MARK: - get
    func getNavigationBarTitle() -> String {
        guard let modifyType = self.modifyType else { return "목표추가" }
        switch modifyType {
        case .record:
            return "기록수정"
        case .date:
            return "날짜변경"
        case .goal:
            return "목표수정"
        }
    }
    
    // MARK: - set
    func setRecord(record: DailyRecordModel) {
        if let goal = record.goal {
            self.cycleType = goal.cycleType
            self.isSetTime = goal.isSetTime
            self.setTime = goal.setTime.toDateOfSetTime()
            self.content = goal.content
            self.goalCount = goal.count
            self.symbol = goal.symbol
        }
    }
    
    // MARK: - button func
    func reset() {
        if let modifyRecord {
            self.setRecord(record: modifyRecord)
            modifyDate = beforeDate
        } else {
            content = ""
            symbol = .check
            goalType = .check
            startDate = beforeDate.defaultDate()
            endDate = beforeDate.defaultDate().setDefaultEndDate()
            cycleType = .date
            selectedWeekday = []
            //        goalTime = 300    // TODO: 추후 수정
            goalCount = 1
            isSetTime = false
            setTime = "00:00".toDateOfSetTime()
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
            setTime: setTime.toStringOfSetTime()
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
        var newDate: Date? = nil
        if let record = modifyRecord,
           let goal = record.goal,
           let type = modifyType,
           let isAll = modifyIsAll {
            switch type {
            case .record:
                record.count = modifyRecordCount
                record.isSuccess = goal.count == modifyRecordCount
                try? modelContext.save()
            case .date:
                record.date = modifyDate
                newDate = modifyDate
                try? modelContext.save()
            case .goal:
                if isAll {
                    goal.content = content
                    goal.symbol = symbol
                    goal.type = goalType
                    goal.count = goalCount
                    goal.isSetTime = isSetTime
                    goal.setTime = setTime.toStringOfSetTime()
                    record.isSuccess = goal.count <= modifyRecordCount
                    try? modelContext.save()
                } else {
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
                        setTime: setTime.toStringOfSetTime(),
                        parentGoal: goal
                    )
                    modelContext.insert(newGoal)
                    try? modelContext.save()
                    goal.childGoals.append(newGoal)
                    record.goal = newGoal
                    try? modelContext.save()
                }
            }
        }
        successAction(newDate)
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
