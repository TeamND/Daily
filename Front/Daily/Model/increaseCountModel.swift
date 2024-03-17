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
}

struct increaseCountData: Codable {
    let record_count: Int
    let issuccess: Bool
}
