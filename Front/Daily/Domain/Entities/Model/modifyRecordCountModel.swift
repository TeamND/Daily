//
//  modifyRecordCountModel.swift
//  Daily
//
//  Created by 최승용 on 7/7/24.
//

import Foundation

struct modifyRecordCountModel: Codable {
    let uid: Int
    let record_count: Int
    
    init (uid: Int, record_count: Int) {
        self.uid = uid
        self.record_count = record_count
    }
}
