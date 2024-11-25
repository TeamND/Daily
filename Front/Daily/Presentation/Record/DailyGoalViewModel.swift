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
    @Published var setTime: Date = Date()
    
    @Published var content: String = ""
    @Published var goalCount: Int = 1
    @Published var symbol: String = "체크"
    
//    private let beforeDate: Date
    
    // TODO: 추후 DailyGoalView로 이동시 Data에 날짜 데이터 추가, Date 변수들 조정
    init() {
        let goalRepository = GoalRepository()
        self.goalUseCase = GoalUseCase(repository: goalRepository)
        
//        self.beforeDate = Date()
    }
    
    func reset() {
        content = ""
        symbol = "체크"
//        type = "check"    // TODO: 추후 수정
        startDate = Date()
        endDate = Date().setDefaultEndDate()
        cycleType = .date
        cycleDate = []
//        goalTime = 300    // TODO: 추후 수정
        goalCount = 1
        isSetTime = false
        setTime = Date()
    }
    
    func add() {
        Task {
            guard let userID = UserDefaultManager.userID, let user_uid = Int(userID) else { return }
            let goal: AddGoalRequestModel = AddGoalRequestModel(
                user_uid: user_uid,
                content: content,
                symbol: symbol,
                type: "check",  // TODO: 추후 수정
                start_date: startDate.yyyyMMdd(),
                end_date: endDate.yyyyMMdd(),
                cycle_type: cycleType.rawValue,
                cycle_date: cycleType == .date ? [startDate.yyyyMMdd()] : cycleDate,
                goal_time: 300, // TODO: 추후 수정
                goal_count: goalCount,
                is_set_time: isSetTime,
                set_time: setTime.toStringOfSetTime()   // TODO: 추후 수정
            )
            try await ServerNetwork.shared.request(.addGoal(goal: goal))
        }
    }
}
