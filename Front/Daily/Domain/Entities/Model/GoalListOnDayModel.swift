//
//  GoalListOnDayModel.swift
//  Daily
//
//  Created by seungyooooong on 10/30/24.
//

import Foundation

struct GoalListOnDayModel: Decodable, Hashable {
    var goalList: [Goal]
    
    init(goalList: [Goal] = []) {
        self.goalList = goalList
    }
}

struct Goal: Decodable, Hashable {
    var uid: Int
    var goal_uid: Int
    var content: String
    var symbol: String
    var type: String
    var record_time: Int
    var goal_time: Int
    var record_count: Int
    var goal_count: Int
    var set_time: Bool
    var is_set_time: Bool
    var cycle_type: String
    var parnet_uid: Int
    var issuccess: Bool
    var start_time: String
}
