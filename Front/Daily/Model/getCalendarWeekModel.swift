//
//  getCalendarWeekModel.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import Foundation

struct getCalendarWeekModel: Codable {
    let code: String
    let message: String
    let data: getCalendarWeekData
}

struct getCalendarWeekData: Codable {
    let rating: [Double]
}
