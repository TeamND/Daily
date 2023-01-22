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
        self.type = "check"
        self.symbol = "운동"
        self.start_date = ""
        self.end_date = ""
        self.cycle_type = ""    // date or repeat from userInfo
        self.cycle_date = ""
        self.goal_time = 300
        self.goal_count = 1
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
    var goalTimeIndex: Int {
        get {
            for i in seconds.indices {
                if seconds[i] == self.goal_time { return i }
            }
            return 0
        }
        set(newValue) { self.goal_time = seconds[newValue] }
    }
}

extension Goal {
    func add(user_uid: Int) {
        let requestData: [String: Any] = [
            "user_uid": user_uid,
            "content": "goal add API test content",
            "symbol": "운동",
            "start_date": "2023-02-12",
            "end_date": "2023-03-20",
            "cycle_type": "repeat",
            "cycle_date": "월,수,금,일",
            "type": "check",
            "goal_count": 1,
            "goal_time": 300
        ]
        
        addGoal(param: requestData)
    }
}
