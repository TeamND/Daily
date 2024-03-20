//
//  GoalModel.swift
//  Daily
//
//  Created by 최승용 on 3/19/24.
//

import Foundation

struct GoalModel: Codable {
    var uid: Int = 0
    var user_uid: Int = 0
    var content: String = ""
    var symbol: String = ""
    var type: String = "check"
    var start_date: String = ""
    var end_date: String = ""
    var cycle_type: String = "date"
    var cycle_date: [String] = []
    var goal_time: Int = 300
    var goal_count: Int = 1
    
    init(user_uid: Int, content: String, symbol: String, cycle_date: [String]) {
        self.user_uid = user_uid
        self.content = content
        self.symbol = symbol
        self.start_date = cycle_date[0]
        self.end_date = cycle_date[cycle_date.count - 1]
        self.cycle_date = cycle_date
    }
}
