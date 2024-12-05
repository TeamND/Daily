//
//  DailyGoalViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

class DailyGoalViewModel: ObservableObject {
    private let goalUseCase: GoalUseCase
    
    @Published var cycleType: CycleTypes = .date
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().setDefaultEndDate()
    @Published var cycleDate: [String] = []
    
    @Published var isSetTime: Bool = false
    @Published var setTime: Date = "00:00".toDateOfSetTime()
    
    @Published var content: String = ""
    @Published var goalType: GoalTypes = .check
    @Published var goalCount: Int = 1
    @Published var symbol: Symbols = .check
    
    @Published var modifyRecord: Goal? = nil
    @Published var modifyType: ModifyTypes? = nil
    @Published var modifyIsAll: Bool? = nil
    @Published var modifyDate: Date = Date()
    var beforeDateString: String? = nil
    @Published var modifyRecordCount: Int = 0
    
//    private let beforeDate: Date
    
    // TODO: 추후 DailyGoalView로 이동시 Data에 날짜 데이터 추가, Date 변수들 조정
    init() {
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
        
//        self.beforeDate = Date()
    }
    
    convenience init(modifyData: ModifyDataModel) {
        self.init()
        
        self.setRecord(record: modifyData.modifyRecord)
        self.modifyRecord = modifyData.modifyRecord
        self.modifyType = modifyData.modifyType
        self.modifyIsAll = modifyData.isAll
        
        if let year = modifyData.year,
           let month = modifyData.month,
           let day = modifyData.day,
           let date = CalendarServices.shared.getDate(year: year, month: month, day: day) {
            self.modifyDate = date
            self.beforeDateString = "\(CalendarServices.shared.formatDateString(year: date.year, month: date.month, day: date.day, joiner: .dot, hasSpacing: true, hasLastJoiner: true))\(date.getKoreaDOW())"
        }
        
        self.modifyRecordCount = modifyData.modifyRecord.record_count
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
    func setRecord(record: Goal) {
        self.cycleType = CycleTypes(rawValue: record.cycle_type) ?? .date
        self.isSetTime = record.is_set_time
        self.setTime = record.set_time.toDateOfSetTime()
        self.content = record.content
        self.goalCount = record.goal_count
        self.symbol = Symbols(rawValue: record.symbol) ?? .check
    }
    
    // MARK: - button func
    func reset() {
        content = ""
        symbol = .check
        goalType = .check
        startDate = Date()
        endDate = Date().setDefaultEndDate()
        cycleType = .date
        cycleDate = []
//        goalTime = 300    // TODO: 추후 수정
        goalCount = 1
        isSetTime = false
        setTime = "00:00".toDateOfSetTime()
    }
    
    func add(successAction: @escaping () -> Void, validateAction: @escaping (String) -> Void) {
        Task {
            guard let userID = UserDefaultManager.userID, let user_uid = Int(userID) else { return }
            if validateContent() { validateAction(contentLengthAlertMessageText); return }
            if cycleType == .rept {
                if cycleDate.count == 0 { validateAction(wrongDateAlertTitleText(type: "emptySelectedWOD")); return }
                if startDate > endDate { validateAction(wrongDateAlertTitleText(type: "wrongDateRange")); return }
                if validateDateRange() { validateAction(wrongDateAlertTitleText(type: "overDateRange")); return }
                if validateCycleDate() { validateAction(wrongDateAlertTitleText(type: "")); return }
            }
            let goal: AddGoalRequestModel = AddGoalRequestModel(
                user_uid: user_uid,
                content: content,
                symbol: symbol.rawValue,
                type: goalType.rawValue,
                start_date: startDate.yyyyMMdd(),
                end_date: cycleType == .date ? startDate.yyyyMMdd() : endDate.yyyyMMdd(),
                cycle_type: cycleType.rawValue,
                cycle_date: cycleType == .date ? [startDate.yyyyMMdd()] : cycleDate,
                goal_time: 300, // TODO: 추후 수정
                goal_count: goalCount,
                is_set_time: isSetTime,
                set_time: setTime.toStringOfSetTime()   // TODO: 추후 수정
            )
            try await ServerNetwork.shared.request(.addGoal(goal: goal))
            await MainActor.run { successAction() }
        }
    }
    
    func modify(successAction: @escaping () -> Void, validateAction: @escaping (String) -> Void) {
        Task {
            if let record = modifyRecord,
               let type = modifyType,
               let isAll = modifyIsAll {
                switch type {
                case .record:
                    let record: ModifyCountModel = ModifyCountModel(uid: record.uid, record_count: modifyRecordCount)
                    try await ServerNetwork.shared.request(.modifyRecordCount(record: record))
                case .date:
                    let record: ModifyDateModel = ModifyDateModel(uid: record.uid, date: modifyDate.yyyyMMdd())
                    try await ServerNetwork.shared.request(.modifyRecordDate(record: record))
                case .goal:
                    if validateContent() { validateAction(contentLengthAlertMessageText); return }
                    let goal: ModifyGoalRequestModel = ModifyGoalRequestModel(
                        uid: record.goal_uid,
                        content: content,
                        symbol: symbol.rawValue,
                        type: goalType.rawValue,
                        goal_count: goalCount,
                        goal_time: 300, // TODO: 추후 수정
                        is_set_time: isSetTime,
                        set_time: setTime.toStringOfSetTime()   // TODO: 추후 수정
                    )
                    if isAll {
                        try await ServerNetwork.shared.request(.modifyGoal(goalID: String(goal.uid), goal: goal))
                    } else {
                        try await ServerNetwork.shared.request(.separateGoal(recordID: String(record.uid), goal: goal))
                    }
                }
            }
            await MainActor.run { successAction() }
        }
    }
    
    // MARK: - validate func
    private func validateContent() -> Bool {
        return content.count < 2
    }
    private func validateDateRange() -> Bool {
        let gap = Calendar.current.dateComponents([.year,.month,.day], from: startDate, to: endDate)
        return gap.year! > 0
    }
    
    private func validateCycleDate() -> Bool {
        let gap = Calendar.current.dateComponents([.year,.month,.day], from: startDate, to: endDate)
        
        if gap.year! == 0 && gap.month! == 0 && gap.day! < 6 {
            let s_DOW = startDate.getKoreaDOW()
            let e_DOW = endDate.getKoreaDOW()
            var s_DOWIndex = 0
            var e_DOWIndex = 0
            
            for dayOfWeek in DayOfWeek.allCases {
                if dayOfWeek.text == s_DOW { s_DOWIndex = dayOfWeek.index }
                if dayOfWeek.text == e_DOW { e_DOWIndex = dayOfWeek.index }
            }
            
            for i in 0 ..< s_DOWIndex {
                if cycleDate.contains(String(i)) { return true }
            }
            for i in e_DOWIndex + 1 ..< 7 {
                if cycleDate.contains(String(i)) { return true }
            }
        }
        return false
    }
}
