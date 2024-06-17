//
//  RecordModel.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation

struct RecordModel: Codable {
    let uid: Int
    var goal_uid: Int
    let content: String
    var type: String
    let symbol: String
    var goal_time: Int
    var goal_count: Int
    var record_time: Int
    var record_count: Int
    var issuccess: Bool
    var start_time2: String?
    var is_set_time: Bool
    var set_time: String
    
    init() {
        self.uid = -1
        self.goal_uid = -1
        self.content = ""
        self.type = "check"
        self.symbol = "체크"
        self.goal_time = 0
        self.goal_count = 0
        self.record_time = 0
        self.record_count = 0
        self.issuccess = false
        self.start_time2 = ""
        self.is_set_time = false
        self.set_time = "00:00"
    }
}
