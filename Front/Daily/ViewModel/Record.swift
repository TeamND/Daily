//
//  Record.swift
//  Daily
//
//  Created by 최승용 on 2023/01/18.
//

import Foundation

class Record: ObservableObject {
    @Published var uid: Int
    @Published var goal_uid: Int
    @Published var content: String
    @Published var type: String
    @Published var symbol: String
    @Published var goal_time: Int
    @Published var goal_count: Int
    @Published var record_time: Int
    @Published var record_count: Int
    @Published var issuccess: Bool
    @Published var start_time: String
    
    init(uid: Int, goal_uid: Int, content: String, type: String, symbol: String,
         goal_time: Int, goal_count: Int, record_time: Int, record_count: Int, issuccess: Bool, start_time: String) {
        self.uid = uid
        self.goal_uid = goal_uid
        self.content = content
        self.type = type
        self.symbol = symbol
        self.goal_time = goal_time
        self.goal_count = goal_count
        self.record_time = record_time
        self.record_count = record_count
        self.issuccess = issuccess
        self.start_time = start_time
    }
}
