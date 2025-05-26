//
//  ChartDataModel.swift
//  Daily
//
//  Created by seungyooooong on 5/22/25.
//

import Foundation

struct ChartDataModel: Identifiable {
    let id: String = UUID().uuidString
    let isNow: Bool
    let unit: ChartUnit
    let rating: Double?
}

struct ChartUnit {
    let weekday: String
    let string: String
}
