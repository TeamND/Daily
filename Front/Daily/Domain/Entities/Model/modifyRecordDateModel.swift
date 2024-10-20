//
//  modifyRecordDateModel.swift
//  Daily
//
//  Created by 최승용 on 7/7/24.
//

import Foundation

struct modifyRecordDateModel: Codable {
    let uid: Int
    let date: String
    
    init (uid: Int, date: String) {
        self.uid = uid
        self.date = date
    }
}
