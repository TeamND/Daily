//
//  increaseCountModel.swift
//  Daily
//
//  Created by 최승용 on 3/17/24.
//

import Foundation

struct increaseCountModel: Codable {
    let code: String
    let message: String
    let data: increaseCountData
    
    init() {
        self.code = "99"
        self.message = "Network Error"
        self.data = increaseCountData()
    }
}

struct increaseCountData: Codable {
    let record_count: Int
    let issuccess: Bool
    
    init() {
        self.record_count = 0
        self.issuccess = false
    }
}
