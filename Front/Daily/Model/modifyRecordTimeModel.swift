//
//  modifyRecordTimeModel.swift
//  Daily
//
//  Created by 최승용 on 7/7/24.
//

import Foundation

struct modifyRecordTimeModel: Codable {
    let uid: Int
    let record_time: Int
    
    init (uid: Int, record_time: Int) {
        self.uid = uid
        self.record_time = record_time
    }
}
