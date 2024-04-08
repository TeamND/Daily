//
//  modifyRecordModel.swift
//  Daily
//
//  Created by 최승용 on 4/7/24.
//

import Foundation

struct modifyRecordModel: Codable {
    let uid: Int
    let date: String
    
    init (uid: Int, date: String) {
        self.uid = uid
        self.date = date
    }
}
