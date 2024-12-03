//
//  DailyRecordViewModel.swift
//  Daily
//
//  Created by seungyooooong on 11/29/24.
//

import Foundation

class DailyRecordViewModel: ObservableObject {
    @Published var record: Goal
    
    init(record: Goal) {
        self.record = record
    }
    
    func increaseCount() {
        Task {
            let result: increaseCountData = try await ServerNetwork.shared.request(.increaseCount(recordID: String(record.uid)))
            await MainActor.run {
                self.record.record_count = result.record_count
                self.record.issuccess = result.issuccess
            }
        }
    }
    
    func removeRecord(isAll: Bool) {
        Task {
            if isAll {
                try await ServerNetwork.shared.request(.removeRecordAll(goalID: String(record.goal_uid)))
            } else {
                try await ServerNetwork.shared.request(.removeRecord(recordID: String(record.uid)))
            }
        }
    }
    func removeGoal() {
        Task {
            try await ServerNetwork.shared.request(.removeGoal(goalID: String(record.goal_uid)))
        }
    }
}
