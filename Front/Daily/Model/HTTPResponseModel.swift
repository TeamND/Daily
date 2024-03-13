//
//  HTTPResponseModel.swift
//  Daily
//
//  Created by 최승용 on 3/13/24.
//

import Foundation

struct HTTPResponseModel: Codable {
    let code: String
    let message: String
    let data: getCalendarDayData
}

struct getCalendarDayData: Codable {
    let goalList: [RecordModel]
}
