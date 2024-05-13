//
//  startTimerRequestModel.swift
//  Daily
//
//  Created by 최승용 on 5/2/24.
//

import Foundation

struct startTimerRequestModel: Codable {
    let uid: Int
    var start_time: String = ""
    
    init (record: RecordModel) {
        self.uid = record.uid
        self.start_time = record.start_time2!
    }
}

struct startTimerResponseModel: Codable {
    let code: String
    let message: String
    let data: startTimerData
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = startTimerData()
    }
}

struct startTimerData: Codable {
    let start_time: Int
    
    init() {
        self.start_time = 0
    }
}
