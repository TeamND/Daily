//
//  modifyRecordModel.swift
//  Daily
//
//  Created by 최승용 on 4/7/24.
//

import Foundation

struct modifyRecordModel: Codable {
    let date: String
    
    init (date: String) {
        self.date = date
    }
}
