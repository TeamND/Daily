//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import Foundation

class Goal: ObservableObject {
    @Published var uid: Int
    @Published var user_uid: Int
    @Published var content: String
    @Published var type: String
    @Published var symbol: String
    @Published var start_date: String
    @Published var end_date: String
    @Published var cycle_type: String
    @Published var cycle_date: String
    @Published var goal_time: Int
    @Published var goal_count: Int
    
    init() {
        self.uid = 0
        self.user_uid = 0
        self.content = ""
        self.type = ""
        self.symbol = ""
        self.start_date = ""
        self.end_date = ""
        self.cycle_type = ""
        self.cycle_date = ""
        self.goal_time = 0
        self.goal_count = 0
    }

    init(uid: Int, user_uid: Int, content: String, type: String, symbol: String,
         start_date: String, end_date: String, cycle_type: String, cycle_date: String, goal_time: Int, goal_count: Int) {
        self.uid = uid
        self.user_uid = user_uid
        self.content = content
        self.type = type
        self.symbol = symbol
        self.start_date = start_date
        self.end_date = end_date
        self.cycle_type = cycle_type
        self.cycle_date = cycle_date
        self.goal_time = goal_time
        self.goal_count = goal_count
    }
}

extension Goal {
    var countOrTime: String {
        get {
            if self.type == "check" { return "횟수" }
            else                    { return "시간" }
        }
        set(newValue) {
            if newValue == "횟수" { self.type = "check" }
            else                 { self.type = "timer" }
        }
    }
    var isSuccess: Bool {
        get {
            if goal_count > 0 { return true }
            else { return false }
        }
    }
}
