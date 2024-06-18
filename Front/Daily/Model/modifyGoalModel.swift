//
//  modifyGoalModel.swift
//  Daily
//
//  Created by 최승용 on 4/8/24.
//

import Foundation

struct modifyGoalModel: Codable {
    let uid: Int
    var content: String = ""
    var symbol: String = ""
    var type: String = "check"
    var goal_count: Int = 1
    var goal_time: Int = 300
    var is_set_time: Bool = false
    var set_time: String = "00:00"
    
    init (record: RecordModel) {
        self.uid = record.goal_uid
        self.content = record.content
        self.symbol = record.symbol
        self.type = record.type
        self.goal_count = record.goal_count
        self.goal_time = record.goal_time
        self.is_set_time = record.is_set_time
        self.set_time = record.set_time
    }
}
