//
//  GoalViewModel.swift
//  Daily
//
//  Created by 최승용 on 6/27/24.
//

import Foundation

class GoalViewModel: ObservableObject {
    @Published var goalModel: GoalModel = GoalModel()
    
    func setSymbol(symbol: String) {
        self.goalModel.symbol = symbol
    }
    
    @Published var start_date: Date = Date()
    @Published var end_date: Date = Date()
    @Published var beforeDate: Date = Date()
    
    func setEndDate(end_date: Date) {
        self.end_date = end_date
    }
    
    
    @Published var is_set_time: Bool = false
    @Published var set_time = Date()
    
    
    
    @Published var isShowAlert: Bool = false
    @Published var isShowContentLengthAlert: Bool = false
    @Published var isShowCountRangeAlert: Bool = false
    
    
    let cycle_types: [String] = ["날짜 선택", "요일 반복"]
    @Published var typeIndex: Int = 0
    @Published var selectedWOD: [Int] = []
    @Published var isSelectedWOD: [Bool] = Array(repeating: false, count: 7)
    
    func setTypeIndex(typeIndex: Int) {
        self.typeIndex = typeIndex
    }
    func setSelectedWOD(selectedWOD: [Int]) {
        self.selectedWOD = selectedWOD
    }
    
    func resetAll() {
        self.setSymbol(symbol: "체크")
        self.setTypeIndex(typeIndex: 0)
        self.setSelectedWOD(selectedWOD: [])
    }
}
