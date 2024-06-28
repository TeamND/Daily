//
//  GoalViewModel.swift
//  Daily
//
//  Created by 최승용 on 6/27/24.
//

import Foundation

class GoalViewModel: ObservableObject {
    // MARK: - goalModel
    @Published var goalModel: GoalModel = GoalModel()
    func setSymbol(symbol: String) {
        self.goalModel.symbol = symbol
    }
    func setContent(content: String) {
        self.goalModel.content = content
    }
    func setType(type: String) {
        self.goalModel.type = type
    }
    func setCycleType(cycle_type: String) {
        self.goalModel.cycle_type = cycle_type
    }
    func setGoalCount(goal_count: Int) {
        self.goalModel.goal_count = goal_count
    }
    func setIsSetTime(is_set_time: Bool) {
        self.goalModel.is_set_time = is_set_time
    }
    
    // MARK: - date
    @Published var start_date: Date = Date()
    @Published var end_date: Date = Date()
    @Published var before_date: Date = Date()
    func setStartDate(start_date: Date) {
        self.start_date = start_date
    }
    func setEndDate(end_date: Date) {
        self.end_date = end_date
    }
    func setBeforeDate(before_date: Date) {
        self.before_date = before_date
    }
    
    // MARK: - set_time
    @Published var set_time = Date()
    func setSetTime(set_time: Date) {
        self.set_time = set_time
    }
    
    // MARK: - cycle_type
    let cycle_types: [String] = ["날짜 선택", "요일 반복"]
    @Published var typeIndex: Int = 0
    @Published var selectedWOD: [Int] = []
    @Published var isSelectedWOD: [Bool] = Array(repeating: false, count: 7)
    func setTypeIndex(typeIndex: Int) {
        self.typeIndex = typeIndex
        self.setCycleType(cycle_type: typeIndex == 0 ? "date" : "repeat")
    }
    func setSelectedWOD(selectedWOD: [Int]) {
        self.selectedWOD = selectedWOD
    }
    func setIsSelectedWOD(isSelectedWOD: [Bool]) {
        self.isSelectedWOD = isSelectedWOD
    }
    
    // MARK: - alert
    @Published var isShowAlert: Bool = false
    @Published var isShowContentLengthAlert: Bool = false
    @Published var isShowCountRangeAlert: Bool = false
    func showAlert(type: String) {
        self.isShowAlert = true
        
        switch(type) {
        case "content":
            self.isShowContentLengthAlert = true
            break
        case "count":
            self.isShowCountRangeAlert = true
            break
        default:
            return
        }
    }
    
    // MARK: - functions
    func resetAll(calendarViewModel: CalendarViewModel) {
        self.setSymbol(symbol: "체크")
        self.setContent(content: "")
        self.setType(type: "check")
        self.setGoalCount(goal_count: 1)
        self.setIsSetTime(is_set_time: false)
        self.setSetTime(set_time: "00:00".toDateOfSetTime())
        
        self.setTypeIndex(typeIndex: 0)
        self.setSelectedWOD(selectedWOD: [])
        self.setIsSelectedWOD(isSelectedWOD: Array(repeating: false, count: 7))
        
        self.setStartDate(start_date: self.before_date)
        self.setEndDate(end_date: self.before_date)
        
        calendarViewModel.setCurrentYear(year: self.start_date.year)
        calendarViewModel.setCurrentMonth(month: self.start_date.month)
        calendarViewModel.setCurrentDay(day: self.start_date.day)
    }
    
    func validateGoal(userInfoViewModel: UserInfoViewModel, calendarViewModel: CalendarViewModel, complete: @escaping (GoalModel) -> Void) {
        if self.goalModel.content.count < 2 {
            self.showAlert(type: "content")
        } else {
            self.goalModel.user_uid = userInfoViewModel.userInfo.uid
            self.goalModel.set_time = set_time.toStringOfSetTime()
            if goalModel.cycle_type == "date" {
                self.goalModel.start_date = self.start_date.yyyyMMdd()
                self.goalModel.end_date = self.start_date.yyyyMMdd()
                self.goalModel.cycle_date = [self.start_date.yyyyMMdd()]
            } else {
                // repeat case
                self.goalModel.start_date = self.start_date.yyyyMMdd()
                self.goalModel.end_date = self.end_date.yyyyMMdd()
//                self.goalModel.cycle_date = self.selectedWOD  // [Int] to type [String]
            }
            complete(self.goalModel)
        }
    }
    
    func initDatesAndSetTime(calendarViewModel: CalendarViewModel) {
        self.setStartDate(start_date: calendarViewModel.getCurrentDate())
        self.setEndDate(end_date: calendarViewModel.getCurrentDate())
        self.before_date = self.start_date
        self.set_time = "00:00".toDateOfSetTime()
    }
}
