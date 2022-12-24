//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import Foundation

var goalList: [Goal] = [Goal(), Goal()]

class Goal: ObservableObject, Identifiable {
    @Published var id: UUID = UUID()
    @Published var type: String = "timer"   // check, count, timer
    @Published var beforeSymbol: String = "dumbbell"
    @Published var afterSymbol: String = "dumbbell.fill"
    @Published var content: String = "6시 기상"
    @Published var isSuccess: Bool = false
    @Published var countOrTime: String = "횟수"   // 횟수, 시간
    @Published var recordCount: Int = 2
    @Published var goalCount: Int = 5
    @Published var isStart: Bool = false
    @Published var recordTime: String = "1:00:05"
    @Published var goalTimeIndex: Int = 3


//    @Published var uid: Int
//    @Published var user_uid: Int
//    @Published var content: String
//    @Published var symbol: String
//    @Published var start_date: String
//    @Published var end_date: String
//    @Published var cycle_type: String
//    @Published var cycle_date: String
//    @Published var type: String
//    @Published var goal_time: String
//    @Published var goal_count: Int
//
//    init(uid: Int, user_uid: Int, content: String, symbol: String, start_date: String, end_date: String, cycle_type: String, cycle_date: String, type: String, goal_time: String, goal_count: Int) {
//        self.uid = uid
//        self.user_uid = user_uid
//        self.content = content
//        self.symbol = symbol
//        self.start_date = start_date
//        self.end_date = end_date
//        self.cycle_type = cycle_type
//        self.cycle_date = cycle_date
//        self.type = type
//        self.goal_time = goal_time
//        self.goal_count = goal_count
//    }
}
