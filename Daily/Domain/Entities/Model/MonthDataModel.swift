//
//  MonthDataModel.swift
//  Daily
//
//  Created by seungyooooong on 1/1/25.
//

import Foundation

struct MonthDataModel: DailyDataModel {
    let daysOnMonth: [DayOnMonth]
    let filterData: [Symbols: Int]
    
    init(daysOnMonth: [DayOnMonth] = Array(repeating: DayOnMonth(), count: 31), filterData: [Symbols: Int] = [:]) {
        self.daysOnMonth = daysOnMonth
        self.filterData = filterData
    }
}

struct DayOnMonth {
    let symbols: [DailySymbol]
    let rating: Double?
    
    init(symbols: [DailySymbol] = [], rating: Double? = nil) {
        self.symbols = symbols
        self.rating = rating
    }
}

struct DailySymbol {
    let symbol: Symbols?
    let isSuccess: Bool
    
    init(symbol: Symbols? = nil, isSuccess: Bool = false) {
        self.symbol = symbol
        self.isSuccess = isSuccess
    }
}
