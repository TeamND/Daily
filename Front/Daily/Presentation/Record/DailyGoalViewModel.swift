//
//  DailyGoalViewModel.swift
//  Daily
//
//  Created by seungyooooong on 10/28/24.
//

import Foundation

class DailyGoalViewModel: ObservableObject {
    private let goalUseCase: GoalUseCase
    
    @Published var cycleType: CycleType = .date
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date().setDefaultEndDate()
    @Published var cycleDate: [String] = []
    
    @Published var isSetTime: Bool = false
    @Published var setTime: Date = "00:00".toDateOfSetTime()
    
    @Published var content: String = ""
    @Published var goalType: GoalTypes = .check
    @Published var goalCount: Int = 1
    @Published var symbol: Symbols = .check
    
//    private let beforeDate: Date
    
    // TODO: 추후 DailyGoalView로 이동시 Data에 날짜 데이터 추가, Date 변수들 조정
    init() {
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
        
//        self.beforeDate = Date()
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
    
    func add(successAction: @escaping () -> Void) {
        Task {
            guard let userID = UserDefaultManager.userID, let user_uid = Int(userID) else { return }
            if validateContent() { return }
            if cycleType == .rept && validateCycleDate() { return }
            if cycleType == .rept && validateDateRange() { return }
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
    
    // MARK: - validate func
    private func validateContent() -> Bool {
        return content.count < 2
    }
    private func validateDateRange() -> Bool {
        let gap = Calendar.current.dateComponents([.year,.month,.day], from: startDate, to: endDate)
        return gap.year! > 0
    }
    
    private func validateCycleDate() -> Bool {
        if cycleDate.count == 0 { return true }
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
