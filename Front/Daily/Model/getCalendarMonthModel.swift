//
//  getCalendarMonthModel.swift
//  Daily
//
//  Created by 최승용 on 3/18/24.
//

import Foundation

struct getCalendarMonthModel: Codable {
    let code: String
    let message: String
    let data: getCalendarMonthData
}

struct getCalendarMonthData: Codable {
    // 1~31 까지 키값으로 dayOnMonthModel 타입의 벨류를 갖는 값이 있을 수도, 없을 수도 있음
    let one: dayOnMonthModel
    let two: dayOnMonthModel
    
    enum CodingKeys: String, CodingKey {
        case one = "1"
        case two = "2"
    }
}

struct dayOnMonthModel: Codable {
    let symbol: [symbolOnMonthModel]
    let rating: Double
}

struct symbolOnMonthModel: Codable {
    let imageName: String
    let isSuccess: Bool
}
