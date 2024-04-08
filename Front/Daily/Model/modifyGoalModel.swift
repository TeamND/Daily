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
    
    init (record: RecordModel) {
        self.uid = record.goal_uid
        self.content = record.content
        self.symbol = record.symbol
    }
}
