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
            await MainActor.run { print(result) }
        }
    }
}
