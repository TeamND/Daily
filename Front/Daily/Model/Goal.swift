//
//  Goal.swift
//  Daily
//
//  Created by 최승용 on 2022/11/14.
//

import Foundation

class Goal: ObservableObject, Identifiable {
    @Published var id: UUID = UUID()
    @Published var type: String = "count"   // check, count, timer
    @Published var symbol: String = "dumbbell.fill"
    @Published var content: String = "6시 기상"
    @Published var isSuccess: Bool = false
    @Published var recordCount: Int = 2
    @Published var goalCount: Int = 5
    @Published var isStart: Bool = false
    @Published var recordTime: String = "1:00:05"
    @Published var goalTime: String = "2:00:00"
}
