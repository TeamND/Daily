//
//  ModifyGoalRequestModel.swift
//  Daily
//
//  Created by seungyooooong on 12/2/24.
//

import Foundation

struct ModifyGoalRequestModel: Encodable {
    let uid: Int
    let content: String
    let symbol: String
    let type: String
    let goal_count: Int
    let goal_time: Int
    let is_set_time: Bool
    let set_time: String
}
