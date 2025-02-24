//
//  MonthDataModel.swift
//  Daily
//
//  Created by seungyooooong on 1/1/25.
//

import Foundation

struct MonthDataModel: Decodable {
    let symbol: [DailySymbol]
    let rating: Double
    
    init(symbol: [DailySymbol] = [], rating: Double = 0.0) {
        self.symbol = symbol
        self.rating = rating
    }
}

struct DailySymbol: Decodable {
    let symbol: Symbols?
    let isSuccess: Bool
    
    init(symbol: Symbols? = nil, isSuccess: Bool = false) {
        self.symbol = symbol
        self.isSuccess = isSuccess
    }
}
