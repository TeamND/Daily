//
//  startTimerModel.swift
//  Daily
//
//  Created by 최승용 on 5/2/24.
//

import Foundation

struct startTimerModel: Codable {
    let uid: Int
    var start_time: String = ""
    
    init (record: RecordModel) {
        self.uid = record.uid
        self.start_time = record.start_time
    }
}

struct startTimerResponseModel: Codable {
    let code: String
    let message: String
    let start_time: String
}
