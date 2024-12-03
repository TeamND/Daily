//
//  AddGoalRequestModel.swift
//  Daily
//
//  Created by seungyooooong on 11/25/24.
//

import Foundation

struct AddGoalRequestModel: Encodable {
    let user_uid: Int
    let content: String
    let symbol: String
    let type: String
    let start_date: String
    let end_date: String
    let cycle_type: String
    let cycle_date: [String]
    let goal_time: Int
    let goal_count: Int
    let is_set_time: Bool
    let set_time: String
}
