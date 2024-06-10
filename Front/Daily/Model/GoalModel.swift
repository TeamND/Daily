//
//  GoalModel.swift
//  Daily
//
//  Created by 최승용 on 3/19/24.
//

import Foundation

struct GoalModel: Codable {
    var uid: Int = -1
    var user_uid: Int = -1
    var content: String = ""
    var symbol: String = "체크"
    var type: String = "check"
    var start_date: String = ""
    var end_date: String = ""
    var cycle_type: String = "date"
    var cycle_date: [String] = []
    var goal_time: Int = 300
    var goal_count: Int = 1
//    var isAllDay: Bool = true
//    var set_time: String = "00:00"
    
    init() {}
    init(recordModel: RecordModel) {
        self.uid = recordModel.goal_uid
        self.content = recordModel.content
        self.symbol = recordModel.symbol
        self.type = recordModel.type
        self.goal_time = recordModel.goal_time
        self.goal_count = recordModel.goal_count
    }
//    init(user_uid: Int, content: String, symbol: String, cycle_date: [String]) {
//        self.user_uid = user_uid
//        self.content = content
//        self.symbol = symbol
//        self.start_date = cycle_date[0]
//        self.end_date = cycle_date[cycle_date.count - 1]
//        self.cycle_date = cycle_date
//    }
}
