//
//  MonthDataModel.swift
//  Daily
//
//  Created by seungyooooong on 1/1/25.
//

import Foundation

struct MonthDataModel: Decodable {
    let symbols: [DailySymbol]
    let rating: Double
    
    init(symbols: [DailySymbol] = [], rating: Double = 0.0) {
        self.symbols = symbols
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
